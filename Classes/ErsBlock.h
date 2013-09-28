//
//  ErsBlock.h
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErsBox.h"
#import "GameCanvas.h"

const static int BOXES_ROWS = 4;
const static int BOXES_COLS = 4;
const static int LEVEL_FLATNESS_GENE = 3;
const static int BETWEEN_LEVELS_DEGRESS_TIME = 50;
const static int BLOCK_KIND_NUMBER = 7;
const static int BLOCK_STATUS_NUMBER = 4;
const static int MAX_LEVEL = 10;


@interface ErsBlock : NSObject {
	int style;
	int	y;
	int x;
	int level;
	BOOL pausing;
	BOOL moving;
	BOOL isEnded;
	GameCanvas* canvas;
	NSArray* TwoD_boxes;

	}

@property (nonatomic ) int style;
@property (nonatomic ) int y;
@property (nonatomic ) int x;
@property (nonatomic ) int level;
@property (nonatomic ) BOOL pausing;
@property (nonatomic ) BOOL moving;
@property (nonatomic ) BOOL isEnded;
@property (nonatomic, retain) GameCanvas* canvas;


@property (nonatomic, retain) NSArray* TwoD_boxes;

-(ErsBlock*) initWithParam: (GameCanvas*) canvas_l;
-(void)setupErsBlock:(int)box_index : (int) style_l :(int) y_l : (int) x_l : (int) level_l;

-(void)display;
-(void)erase;
-(BOOL)isMoveAble: (int) newRow :(int) newCol;
-(BOOL)moveTo: (int) newRow : (int) newCol ;
-(void)moveDown;
-(void)moveLeft;
-(void)moveRight;
-(void)turnNext;
-(void)turnNext_AntiClock;

-(void)pauseMove;
-(void)resumeMove;
-(void)stopMove;

-(BOOL)isTurnAble:(int) newStyle;
-(BOOL)turnTo:(int) newStyle;

-(void)mainLoop;

@end
