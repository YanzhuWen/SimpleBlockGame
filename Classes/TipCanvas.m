//
//  TipCanvas.m
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TipCanvas.h"
#import "ErsBlock.h"

@implementation TipCanvas

@synthesize block_index,style,isTiled,TwoD_boxes,boxWidth,boxHeight,drawMethod;

- (id)initWithFrame:(CGRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
		// Graphics
		
		CGSize cs = frameRect.size;
		ctx_bitmap = [self getBitMapContextWithWidth:cs.width andHeight:cs.height];
		bitmap = CGBitmapContextGetData(ctx_bitmap);
		CGContextSetRGBFillColor (ctx_bitmap, 0.5, 0.5, 0.5, 1);
		
		TwoD_boxes = [NSArray arrayWithObjects:
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
		self.style =0x04e0;
		
		drawMethod = [[GradientDrawingView alloc] initWithFrame: frameRect ];
	}
	
	return self;
}

- (void) fanning{
	CGRect cg = self.bounds;
	CGSize cs = cg.size;
	
	self.boxWidth =  cs.width / BOXES_COLS;
	self.boxHeight = cs.height /BOXES_ROWS;
	self.isTiled = TRUE;
}


- (void)drawRect:(CGRect)rect {
	NSLog( @"Tip Canvas drawSomeText" );
	
	if( !self.isTiled ) {
		[self fanning ];
	}
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	int key = 0x8000;
	for (int i = 0; i < BOXES_ROWS ; i++) {
		for (int j = 0; j < BOXES_COLS; j++) {
			BOOL color = ( (key & style ) != 0 );
			if( color == TRUE ) {
				CGContextSetRGBFillColor( ctx, 1,1,1,1);
			}else{
				CGContextSetRGBFillColor( ctx, 0,0,0,1);
			}
			CGRect cg = CGRectMake (j * boxWidth, i * boxHeight, boxWidth, boxHeight);
			if( color == TRUE ){
				[ self.drawMethod drawInContextByType :ctx:cg:self.block_index ];
			}else{
				CGContextFillRect (ctx, cg );
			}
			key >>= 1;
		}
	}
	
	NSLog( @"Tip Canvas drawSomeText, end " );	
	
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


@end
