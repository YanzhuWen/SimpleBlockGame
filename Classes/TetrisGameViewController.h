//
//  TetrisGameViewController.h
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCanvas.h"
#import "TipCanvas.h"
#import <AudioToolBox/AudioToolBox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "ErsBlock.h"



@interface TetrisGameViewController : UIViewController {
	
	ErsBlock* game_aBlock;

	GameCanvas* contentView;
	TipCanvas* tipview;
	IBOutlet UIView* uiGameCanvasview;
	IBOutlet UIView* uiPreview;
	IBOutlet UIButton* left;
	IBOutlet UIButton* down;
	IBOutlet UIButton* right;
	IBOutlet UIButton* clockwise;
	IBOutlet UIButton* anticlockwise;
	IBOutlet UIButton* playbutton;
	IBOutlet UIButton* stopbutton;	
	IBOutlet UITextField* uiScore;
	IBOutlet UITextField* uiLevel;
	
	BOOL playing;
	
	NSTimer* timer_for_block;
	NSTimer* timer_for_mainloop;
	NSTimer* timer_for_scoreandlevelupdate;
    
    NSTimer* timer_for_touchinput;

	AVAudioPlayer *audioPlayer1;
	AVAudioPlayer *audioPlayer2;
	AVAudioPlayer *audioPlayer3;
	AVAudioPlayer *audioPlayer4;

	
	int level;

	
}
@property (nonatomic, retain) GameCanvas* contentView;
@property (nonatomic, retain) TipCanvas* tipview;

@property (nonatomic, retain) UIView* uiGameCanvasview;
@property (nonatomic, retain) UIView* uiPreview;

@property (nonatomic, retain) ErsBlock* game_aBlock;

@property (nonatomic )BOOL playing;

-(IBAction) GameStartClicked:(id) sender;
-(IBAction) stopClicked:(id) sender;
-(IBAction) leftClicked:(id) sender;
-(IBAction) rightClicked:(id) sender;
-(IBAction) downClicked:(id) sender;
-(IBAction) turnClicked:(id) sender;
-(IBAction) antiturnClicked:(id) sender;
-(IBAction) touchupOutsideClicked:(id) sender;

-(void)repeatMoveDown;
-(void)mainRoutine;
-(void)blockRunRoutine;
-(BOOL)isGameOver;
-(void)cleanOneGame;
-(void)scoreandLevelRoutine;
-(void)levelUpdate;

-(void)enablebutton;
-(void)disablebutton;

@end

