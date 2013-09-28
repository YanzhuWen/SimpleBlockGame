//
//  TipCanvas.h
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/24/09.
//  Copyright 2009 Yanzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GradientDrawingView.h"

#define COMMONBACKGROUNDCOLOR  [UIColor colorWithRed:.999 green:.999 blue:.999 alpha:0.95] 
#define COMMONREDCOLOR  [UIColor colorWithRed:.999 green:.0 blue:.0 alpha:0.99] 


@interface TipCanvas : UIView {
	int block_index;
	int style;
	BOOL isTiled;
	NSArray* TwoD_boxes;
	int boxWidth;
	int boxHeight;
    
	
	// Graphics
	CGContextRef ctx_bitmap;
	char* bitmap;
	GradientDrawingView* drawMethod;
	
}

@property (nonatomic ) int block_index;
@property (nonatomic ) int style;
@property (nonatomic ) BOOL isTiled;
@property (nonatomic ) int boxWidth;
@property (nonatomic ) int boxHeight;

@property (nonatomic, retain) NSArray* TwoD_boxes;
@property (nonatomic, retain) GradientDrawingView* drawMethod;

- (CGContextRef)getBitMapContextWithWidth:(int)bitmap_width andHeight:(int)bitmap_height;
- (void) fanning;

@end
