//
//  ErsBlock.m
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ErsBlock.h"
#import "globalData.h"

@implementation ErsBlock

@synthesize style,y,x,level,pausing,moving,canvas,isEnded;
@synthesize TwoD_boxes;

-(void)setupErsBlock: (int)box_index : (int) style_l :(int) y_l : (int) x_l : (int) level_l{
	self.style = style_l;
	self.y = y_l;
	self.x = x_l;
	self.level = level_l;
	
	int key = 0x8000;
	for (int i = 0; i<BOXES_ROWS; i++){   
		for (int j = 0; j<BOXES_COLS; j++) {
			BOOL isColor = ((style_l&key)!=0);
			ErsBox* aBox = [[TwoD_boxes objectAtIndex:i] objectAtIndex: j ];
			aBox.isColor = isColor;
			aBox.box_type_index = box_index;
			key >>= 1;
		}
	}
	moving = TRUE;
	pausing = FALSE;
	isEnded = FALSE;
	
}

-(ErsBlock*) initWithParam: (GameCanvas*) canvas_l {
	self = [ super init];
	if( self ){
		moving = TRUE;
		pausing = FALSE;
		self.canvas = canvas_l;		
		TwoD_boxes =[ [NSArray alloc]  initWithObjects:
						 [NSMutableArray new],
						 [NSMutableArray new],
						 [NSMutableArray new],
						 [NSMutableArray new], nil];
		for (int i = 0; i<BOXES_ROWS; i++){   
			for (int j = 0; j<BOXES_COLS; j++) {
				ErsBox* aBOX = [[ErsBox alloc]initWithParam: FALSE: -1 ];
				[[TwoD_boxes objectAtIndex:i] addObject: aBOX];
			}
		} 
 	}
	self.isEnded = FALSE;
	[self display];
	return self;
}

-(void)turnNext{
	for (int i = 0; i<BLOCK_KIND_NUMBER; i++){   
		for (int j = 0; j<BLOCK_STATUS_NUMBER; j++) {
			int style_l = [[ globalData  shareuserData] getStylebyrc: i:j ];
			if( style_l == self.style ){
				int newStyle = [[ globalData  shareuserData] getStylebyrc: i: (j+1)%BLOCK_STATUS_NUMBER];
				[self turnTo: newStyle ];
				return;
			}
		}
	}
}

-(void)turnNext_AntiClock{
	for (int i = 0; i<BLOCK_KIND_NUMBER; i++){   
		for (int j = 0; j<BLOCK_STATUS_NUMBER; j++) {
			int style_l = [[ globalData  shareuserData] getStylebyrc: i:j ];
			if( style_l == self.style ){
				int newStyle = [[ globalData  shareuserData] getStylebyrc: i: (j+BLOCK_STATUS_NUMBER-1)%BLOCK_STATUS_NUMBER];
				[self turnTo: newStyle ];
				return;
			}
		}
	}
}


-(BOOL)isTurnAble:(int) newStyle{
	[self erase];
	int key = 0x8000;
	ErsBox* aBOX;
	for (int i = 0; i<BOXES_ROWS; i++){   
		for (int j = 0; j<BOXES_COLS; j++) {
			BOOL isColor = ((newStyle&key)!=0);
			if( isColor == TRUE ){ // check boundary and other box in this block
				aBOX = [canvas getBox: y + i: x + j];
				if (aBOX == nil || aBOX.isColor == TRUE){ //conflict
					[self display];
					return FALSE;
				}			
			}
			key >>= 1;
		}
	}
	[self display];
	return TRUE;
}

-(BOOL) turnTo:(int) newStyle{
	if( ![self isTurnAble: newStyle] || !moving) return FALSE;
	
	[self erase];
	int key = 0x8000;
	
	for (int i = 0; i<BOXES_ROWS; i++){   
		for (int j = 0; j<BOXES_COLS; j++) {
			ErsBox* aBox = [[TwoD_boxes objectAtIndex:i] objectAtIndex: j ];
			BOOL isColor_l = ((newStyle&key)!=0);
			aBox.isColor = isColor_l;
			key >>= 1;
		}
	}
	self.style = newStyle;
	
	[self display];
	[self.canvas setNeedsDisplay];
	return TRUE;
}

-(void)display{
	for (int i = 0; i < BOXES_ROWS; i++) {
		for (int j = 0; j < BOXES_COLS; j++) {
			ErsBox* aBox = [[TwoD_boxes objectAtIndex:i] objectAtIndex: j ];
			if (aBox.isColor) {
				ErsBox* box = [canvas getBox: y + i: x + j];
				if (box == nil) continue;
				box.isColor=TRUE;
				box.box_type_index = aBox.box_type_index;
			}
		}
	}	
}

-(void) erase{
	
	for (int i = 0; i < BOXES_ROWS; i++) {
		for (int j = 0; j < BOXES_COLS; j++) {
			ErsBox* aBox = [[TwoD_boxes objectAtIndex:i] objectAtIndex: j ];
			if (aBox.isColor) {
				ErsBox* box = [canvas getBox: y + i: x + j];
				if (box == nil) continue;
				box.isColor=FALSE;
			}
		}
	}	
}

-(BOOL)isMoveAble: (int) newRow :(int) newCol{
	[self erase ];
	
	for (int i = 0; i < BOXES_ROWS; i++) {
		for (int j = 0; j < BOXES_COLS; j++) {
			ErsBox* aBox = [[TwoD_boxes objectAtIndex:i] objectAtIndex: j ];
			if (aBox.isColor) {
				ErsBox* box = [canvas getBox: newRow + i: newCol + j];
				if (box == nil || box.isColor==TRUE ) {
					[self display];
					return FALSE;
				}
			}
		}
	}	
	[self display ];
	[self.canvas setNeedsDisplay];
	return TRUE;
}


-(BOOL) moveTo: (int) newRow : (int) newCol {
	if ( [self  isMoveAble: newRow: newCol] != TRUE || !self.moving)
		return false;
	
	[self erase];
	self.y = newRow;
	self.x = newCol;
	
	[self display];
	[self.canvas setNeedsDisplay];
	
	return TRUE;
}

-(void)moveDown{
	[self moveTo: self.y+1:self.x ];
}

-(void)moveLeft{
	[self moveTo: self.y:self.x-1 ];
}

-(void)moveRight{
	[self moveTo: self.y:self.x+1 ];
}

-(void)pauseMove{
	pausing = TRUE;
	
}

-(void)resumeMove{
	pausing = FALSE;
}

-(void)stopMove{
	moving = FALSE;
}

-(void)mainLoop{
	
	if(moving){
		//double uSecond = (double)(BETWEEN_LEVELS_DEGRESS_TIME*(MAX_LEVEL-level+LEVEL_FLATNESS_GENE))/1000;
		//NSLog( @"uSecond = %f", uSecond );
		//[NSThread sleepForTimeInterval:uSecond];
		BOOL result = [self moveTo: self.y+1 : self.x ];
		if( result != TRUE){ //not movable when reach the buttom, mark as the end of this block
			NSLog( @"this block reach the buttom, set it as ended" );
			self.canvas.oneBlockReachButtom = TRUE;
			self.isEnded = TRUE;
			[self.canvas setNeedsDisplay];
		}else{
			self.canvas.oneBlockReachButtom = FALSE;
			[self.canvas setNeedsDisplay];
			//[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
		}
		if( !pausing ) moving = result&&moving;
	}
	
	
}

@end
