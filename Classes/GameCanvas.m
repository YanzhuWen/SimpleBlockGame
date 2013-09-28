//
//  GameCanvas.m
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameCanvas.h"
#import "ErsBox.h"



@implementation GameCanvas

@synthesize isTiled,rows,cols,score,scoreForLevelUpdate,TwoD_boxes,boxWidth,boxHeight,drawMethod,oneBlockReachButtom;

- (id)initWithFrame:(CGRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
		// Graphics
		CGSize cs = frameRect.size;
		ctx_bitmap = [self getBitMapContextWithWidth:cs.width andHeight:cs.height];
		bitmap = CGBitmapContextGetData(ctx_bitmap);
		CGContextSetRGBFillColor (ctx_bitmap, 0.5, 0.5, 0.5, 1);
        
        int gameCanvas_box_row = GAMECANVAS_BOX_ROW;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            //this is iphone 5 xib
            gameCanvas_box_row+=4;
        }
        
		[self 	initWithRowsandCols: gameCanvas_box_row	:GAMECANVAS_BOX_COL];
		drawMethod = [[GradientDrawingView alloc] initWithFrame: frameRect ];
		//[self setNeedsDisplay];
		
		NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"TennisServe" ofType:@"caf"];
		NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePath];
		audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:nil];
		[audioPlayer prepareToPlay];
		oneBlockReachButtom = FALSE;
	}
	return self;
}

- (void)initWithRowsandCols:(int)rows_l :(int)cols_l{
	self.rows = rows_l;
	self.cols = cols_l;
	
	TwoD_boxes =[ [NSMutableArray alloc]  init  ];
	
	for( int i=0; i<rows_l;i++){
		[TwoD_boxes addObject:[NSMutableArray new]];
	}
	
	for( int i=0; i<rows_l;i++){
		NSMutableArray* array_c = [ TwoD_boxes objectAtIndex:i];
		for( int j=0;j<cols_l;j++){
			ErsBox* aBOX = [[ErsBox alloc]initWithParam: FALSE: -1 ];
			[array_c addObject: aBOX];
		}
	}		
	
}

- (void) resetScoreForlevelUpdate{
	scoreForLevelUpdate -= PER_LEVEL_SCORE;
}
- (void) fanning{
	CGRect cg = self.bounds;
	CGSize cs = cg.size;
	
	self.boxWidth =  cs.width / self.cols;
	self.boxHeight = cs.height /self.rows;
	self.isTiled = TRUE;
}

-(void)resetCanvas{
	for (int i = 0; i < TwoD_boxes.count ; i++) {
		NSMutableArray* array_c = [TwoD_boxes objectAtIndex: i ];
		for (int j = 0; j < array_c.count; j++) {
			ErsBox* box = [array_c objectAtIndex:j];
			box.isColor  = FALSE;
		}
	}
	scoreForLevelUpdate = 0;
	score = 0;
	[self setNeedsDisplay];
}

-(int)checkFullLine{
	if( oneBlockReachButtom != TRUE )
		return -1;
	
	for (int i = 0; i < self.rows; i++) {
		int row = -1;
		BOOL fullLineColorBox = true;
		for (int j = 0; j < self.cols; j++) {
			ErsBox* aBox = [ self getBox: i : j];
			if (!  aBox.isColor) {
				fullLineColorBox = false;
				break;
			}
		}
		if (fullLineColorBox) {
			row = i--;
			return row;
		}
	}
	return -1;
}

- (void)drawRect:(CGRect)rect {
	
	//NSLog( @"GameCanvas drawSomeText" );
	
	if( !self.isTiled ) {
		[self fanning ];
	}

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	for (int i = 0; i < TwoD_boxes.count ; i++) {
		NSMutableArray* array_c = [TwoD_boxes objectAtIndex: i ];
		for (int j = 0; j < array_c.count; j++) {
			ErsBox* box = [array_c objectAtIndex:j];
			if( box.isColor  == TRUE ) {
				CGContextSetRGBFillColor( ctx, 1,1,1,1);
			}else{
				CGContextSetRGBFillColor( ctx, 0.2,0.2,0.2,1);
			}
			CGRect cg = CGRectMake (j * boxWidth, i * boxHeight, boxWidth, boxHeight);
			if( box.isColor == TRUE ){
				//[ self.drawMethod drawInContextByType:ctx:cg: box.box_type_index ];
				[ self.drawMethod drawInContextMethod3:ctx:cg: box.box_type_index ]; 
				
			}else{
				CGContextFillRect (ctx, cg );
			}
		}
	}
	
	//draw the background lines
	CGRect cg2d[TwoD_boxes.count];
	for (int i = 0; i < TwoD_boxes.count ; i++) {
		cg2d[i] = CGRectMake (0, i*boxHeight, boxWidth*self.cols, boxHeight);
	}
	[ self.drawMethod drawInBounderByType2:ctx:cg2d:TwoD_boxes.count ];
	 
	
	NSMutableArray* array_c = [TwoD_boxes objectAtIndex: 0 ];
	CGRect cg2d2[array_c.count];
	for (int j = 0; j < array_c.count; j++){
		cg2d2[j] = CGRectMake (j*boxWidth, 0, boxWidth, boxHeight*self.rows);
	}
	[ self.drawMethod drawInBounderByType2:ctx:cg2d2:array_c.count];
	
	
	int row = [self checkFullLine ];
	int doublefactor = 1;
	while( row != -1 ){
		//highlight this line, and remove it
		NSLog( @"highlight this line, and remove it, row =%d", row );
		CGRect cg = CGRectMake ( 0, row * boxHeight, boxWidth*self.cols, boxHeight);
		[ self.drawMethod drawInBounderByType:ctx:cg: 1 ];
		[self removeLine: row];
		[audioPlayer play ];
		NSLog( @"highlight sleepForTimeInterval  row =%d", row );
		[NSThread sleepForTimeInterval:0.1];
		score += PER_LINE_SCORE*doublefactor;
		scoreForLevelUpdate += PER_LINE_SCORE*doublefactor;
		doublefactor = doublefactor*2;
		row = [self checkFullLine ];
	}

	
	//NSLog( @"GameCanvas drawSomeText, end " );	
}

-(ErsBox*) getBox: (int)row_l : (int)col_l{
	NSMutableArray* array = [TwoD_boxes objectAtIndex: 0 ];

	if( row_l<0 || row_l >= TwoD_boxes.count 
		|| col_l<0 || col_l >= array.count  )
		return nil;
	
	NSMutableArray* array_c = [TwoD_boxes objectAtIndex: row_l ];
	ErsBox* box = [array_c objectAtIndex:col_l];

	return box;

}

-(CGContextRef)getBitMapContextWithWidth:(int)bitmap_width andHeight:(int)bitmap_height {
	CGContextRef context = NULL;
	CGColorSpaceRef color_space;
	char * bitmap_data;
	int mem_size;
	int bytes_per_row;
	
	bytes_per_row = bitmap_width * 4;
	mem_size = bytes_per_row * bitmap_height;
	color_space = CGColorSpaceCreateDeviceRGB();
	bitmap_data = malloc(mem_size);
	if(bitmap_data == NULL) {
		fprintf(stderr, "Memory not allocated!");
		return NULL;
	}
	
	for(int i=0; i<mem_size; i++)
		if(i % 4 == 3) 
			bitmap_data[i] = 255;
		else
			bitmap_data[i] = 127;
	
	context = CGBitmapContextCreate(bitmap_data, bitmap_width, bitmap_height, 8, bytes_per_row, color_space, kCGImageAlphaPremultipliedLast);
	if(context == NULL) {
		free(bitmap_data);
		fprintf(stderr, "Context not created!");
		return NULL;
	}
	
	CGColorSpaceRelease(color_space);
	
	return context;
}




-(void)removeLine:(int)row{
	for (int i = row; i > 0; i--) {
		for (int j = 0; j < self.cols; j++){
			ErsBox* oldbox = [[TwoD_boxes objectAtIndex: i-1]objectAtIndex:j];
			ErsBox* newbox = [oldbox clone];
			ErsBox* currentBox = [[TwoD_boxes objectAtIndex : i]objectAtIndex:j];
			NSMutableArray* mta = [TwoD_boxes objectAtIndex : i];
			[mta  replaceObjectAtIndex: j withObject: newbox ];
			[currentBox release];
		}
	}
}

@end
