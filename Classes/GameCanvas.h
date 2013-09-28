//
//  GameCanvas.h
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErsBox.h"
#import "GradientDrawingView.h"
#import <AVFoundation/AVAudioPlayer.h>

const static int PER_LINE_SCORE = 100;
const static int PER_LEVEL_SCORE = 1300;
const static int DEFAULT_LEVEL = 1;

#define  GAMECANVAS_BOX_ROW 19
#define  GAMECANVAS_BOX_COL 10

@interface GameCanvas :UIView {

	BOOL isTiled;	
	int rows;
	int cols;
	int score;
	int scoreForLevelUpdate;
	NSMutableArray* TwoD_boxes;
	int boxWidth;
	int boxHeight;
	
	// Graphics
	CGContextRef ctx_bitmap;
	char* bitmap;
	GradientDrawingView* drawMethod;
	
	AVAudioPlayer *audioPlayer;
	BOOL oneBlockReachButtom;
	
}

@property (nonatomic ) BOOL oneBlockReachButtom;
@property (nonatomic ) BOOL isTiled;
@property (nonatomic ) int rows;
@property (nonatomic ) int cols;
@property (nonatomic ) int score;
@property (nonatomic ) int scoreForLevelUpdate;
@property (nonatomic ) int boxWidth;
@property (nonatomic ) int boxHeight;

@property (nonatomic, retain) NSMutableArray* TwoD_boxes;
@property (nonatomic, retain) GradientDrawingView* drawMethod;


- (CGContextRef)getBitMapContextWithWidth:(int)bitmap_width andHeight:(int)bitmap_height;
- (void)initWithRowsandCols:(int)rows_l :(int)cols_l;
-(ErsBox*) getBox: (int)row_l : (int)col_l;
-(void)removeLine:(int)row;
-(int)checkFullLine;
-(void)resetCanvas;
- (void)resetScoreForlevelUpdate;

//- (void) fanning;

@end
