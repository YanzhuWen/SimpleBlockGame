//
//  TetrisGameViewController.m
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TetrisGameViewController.h"
#import "globalData.h"
#import "ErsBlock.h"

@implementation TetrisGameViewController
@synthesize contentView,uiGameCanvasview,uiPreview,tipview,playing,game_aBlock;

-(BOOL)isGameOver{
	for (int i = 0; i < self.contentView.rows; i++) {
		ErsBox* aBox = [ self.contentView getBox: 0 : i];
		if( aBox.isColor ) 
			return TRUE;
	}
	return FALSE;		
}

-(void)blockRunRoutine{
	[game_aBlock mainLoop ];
}

static int randomNumber1;
static int style_l;
static int block_index_l;

-(void)cleanOneGame{
	
	if( timer_for_mainloop != nil ){
		[timer_for_mainloop invalidate];
		timer_for_mainloop = nil;
		[timer_for_mainloop release];
	}

	
	if( timer_for_block != nil ){
		[timer_for_block invalidate];
		timer_for_block = nil;
		[timer_for_block release];
	}	
}


-(void)mainRoutine{

	if( game_aBlock.isEnded == TRUE ){
		if ( [self isGameOver] ) {     
			NSLog( @"Game Over" );
			
			 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Info!" message: @"Game over!\nPress start to have a new game." delegate:self
			 cancelButtonTitle:@"OK"
			 otherButtonTitles:nil];
			 [alertView  show];
			 [alertView  release];
			
			[self stopClicked: nil];
			return;
		}			
		int initx = arc4random() % (self.contentView.cols-4);
		[game_aBlock setupErsBlock: block_index_l : style_l: -1: initx : 1 ];
		NSLog( @"game_aBlock.isEnded Next block, style_l=%x,randomNumber1=%d, block_index_l=%d, initx=%d", style_l, randomNumber1, block_index_l,initx);
	
		randomNumber1 =   arc4random() % 28;
		style_l = [ [globalData shareuserData] getStylebyindex: randomNumber1%28 ];
		block_index_l = randomNumber1/4;
		//NSLog( @"game_aBlock.isEnded Next tip, style_l=%x,randomNumber1=%d, block_index_l=%d", style_l, randomNumber1, block_index_l);
		self.tipview.block_index = block_index_l;
		self.tipview.style  = style_l;	
		[self.tipview setNeedsDisplay];
		
	}
	
}

-(void)levelUpdate{
	if( level < MAX_LEVEL ){
		level +=1;
		[self.contentView resetScoreForlevelUpdate ];
		[audioPlayer3 play];
	}
}

-(void)scoreandLevelRoutine{
	uiScore.text = [NSString stringWithFormat: @"%d", self.contentView.score ];
	uiLevel.text = [NSString stringWithFormat: @"%d", level ];

	int scoreforupdate = self.contentView.scoreForLevelUpdate;
	if( scoreforupdate >= PER_LEVEL_SCORE && scoreforupdate > 0 ){
		[self levelUpdate];
		double timeinterval[ 11 ] = { 0.8, 0.7, 0.75, 0.65, 0.45, 0.35, 0.28, 0.24, 0.20, 0.15, 0.09};
		double timenew = timeinterval[ level ];
		[timer_for_block invalidate];
		NSLog( @"new timer interval = %f", timenew );
		timer_for_block = [NSTimer scheduledTimerWithTimeInterval:timenew target:self 
							selector:@selector(blockRunRoutine) userInfo:nil repeats:YES];

	}
	
}

-(IBAction) GameStartClicked:(id) sender {
	self.playing = TRUE;

	//set Timer to mainloop
	timer_for_mainloop  = [NSTimer scheduledTimerWithTimeInterval:(0.05) target:self 
							selector:@selector(mainRoutine) userInfo:nil repeats:YES];
	//set Timer to repeat push down the block
	timer_for_block = [NSTimer scheduledTimerWithTimeInterval:(0.6) target:self 
					selector:@selector(blockRunRoutine) userInfo:nil repeats:YES];
	
	timer_for_scoreandlevelupdate = [NSTimer scheduledTimerWithTimeInterval:(1.5) target:self 
									selector:@selector(scoreandLevelRoutine) userInfo:nil repeats:YES];
	level = 1;
	[audioPlayer3 play];
	playbutton.enabled = FALSE;
	stopbutton.enabled = TRUE;
	[self enablebutton];
	NSLog( @"GameStartClicked" );
		 
}

-(IBAction) stopClicked:(id) sender{
	if( game_aBlock != nil ){
		game_aBlock.y = 0;
		[game_aBlock erase] ;
	}
	playbutton.enabled = TRUE;
	stopbutton.enabled = FALSE;
	[self disablebutton];
	[self cleanOneGame ];
	self.playing = FALSE;
	[self.contentView resetCanvas];
	[self.uiGameCanvasview setNeedsDisplay];
	[audioPlayer4  play];
	NSLog( @"stopClicked ");
	
}

//static NSDate* lasttimeforleft;
//static NSDate* thistimeforleft;
-(IBAction) leftClicked:(id) sender{
	//NSLog( @"leftClicked ");
	[audioPlayer1 play];
	[game_aBlock moveLeft];	
	
		
}

//static NSDate* lasttimeforright;
//static NSDate* thistimeforright;
-(IBAction) rightClicked:(id) sender{
	//NSLog( @"rightClicked ");
	[audioPlayer1 play];
	[game_aBlock moveRight];
	

	
}

static NSDate* lasttime;
static NSDate* thistime;
-(IBAction) downClicked:(id) sender{
	NSLog( @"downClicked ");
	[audioPlayer1 play];
	[game_aBlock moveDown];
	
	NSTimeInterval test_duration;
	if( lasttime == nil ){  //first time click
		lasttime = [[NSDate alloc] init];
	}else{
		thistime = [[NSDate alloc] init];
		test_duration = [thistime timeIntervalSinceDate:lasttime];
		NSString *thirdMessage =[NSString stringWithFormat:@"%0.0f", test_duration];
		[lasttime release];
		lasttime = thistime;
		double dd = [thirdMessage doubleValue ]  ;
		NSLog( @"downClicked time interval =%f, %@", dd, thirdMessage );
		if(  dd < 1 ){
			for( int i=0;i<3;i++ ){
				[game_aBlock moveDown];
			}
		}
	}
	
}

-(IBAction) touchupOutsideClicked:(id) sender{
	NSLog( @"touchupOutsideClicked ");
}


-(void)repeatMoveDown{
	NSLog( @"repeatMoveDown ");
	[game_aBlock moveDown];
	
}

-(IBAction) turnClicked:(id) sender{
	NSLog( @"turnClicked ");
	[audioPlayer2 play];
	[game_aBlock turnNext];
}

-(IBAction) antiturnClicked:(id) sender{
	NSLog( @"antiturnClicked ");
	[audioPlayer2 play];
	[game_aBlock turnNext_AntiClock];
}
	
-(void) enablebutton{
	left.enabled = true;
	down.enabled = true;
	right.enabled = true;
	clockwise.enabled = true;
	anticlockwise.enabled = true;	
}

-(void) disablebutton{
	
	left.enabled = false;
	down.enabled = false;
	right.enabled = false;
	clockwise.enabled = false;
	anticlockwise.enabled = false;
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect trect = self.uiGameCanvasview.frame;
    
    CGRect newFrame  = trect;
    
    
   
    int screenHeight  =[[UIScreen mainScreen] bounds].size.height;
    if ( screenHeight == 568) {
        int boxHeight = screenHeight/(GAMECANVAS_BOX_ROW+4);
        int leftOver = screenHeight-boxHeight*(GAMECANVAS_BOX_ROW+4);
                                               
        //this is iphone 5 xib
        newFrame = CGRectMake( trect.origin.x, trect.origin.y, trect.size.width, screenHeight-leftOver);
    }else{
        int boxHeight = screenHeight/(GAMECANVAS_BOX_ROW);
        int leftOver = screenHeight-boxHeight*(GAMECANVAS_BOX_ROW);
        //this is 3.5 inch screens xib
        newFrame = CGRectMake( trect.origin.x, trect.origin.y, trect.size.width, screenHeight-leftOver);

    }
	
    self.contentView = [[[GameCanvas alloc] initWithFrame:newFrame] autorelease];
	self.uiGameCanvasview = self.contentView;
	
	trect = self.uiPreview.frame;
	self.tipview = [[[TipCanvas alloc] initWithFrame:trect] autorelease];
	self.uiPreview = self.tipview;
	 
	[self.view addSubview: self.uiGameCanvasview ];
	[self.view addSubview: self.uiPreview ];
	
    self.playing = FALSE;
    [self disablebutton];
    
	UIImage *img = [UIImage imageNamed:@"Arrowleft.png"];
	[left setImage: img forState:UIControlStateNormal];
	[img release];
	
	img = [UIImage imageNamed:@"Arrowdown.png"];
	[down setImage: img forState:UIControlStateNormal];
	[img release];
	
	img = [UIImage imageNamed:@"Arrowright.png"];
	[right setImage: img forState:UIControlStateNormal];
	[img release];
	
	img = [UIImage imageNamed:@"Arrow1.png"];
	[clockwise setImage: img forState:UIControlStateNormal];
	[img release];
	/*
	img = [UIImage imageNamed:@"Arrow2.png"];
	[anticlockwise setImage: img forState:UIControlStateNormal];
	[img release];
	*/
	game_aBlock = [[ ErsBlock alloc ] initWithParam: self.contentView ];
	
	int t =   arc4random() % 28;
	int s_l=  [ [globalData shareuserData] getStylebyindex: t%28 ];
	int b_l = t/4;
	int initx = arc4random() % ( self.contentView.cols-4);
	[game_aBlock setupErsBlock: b_l : s_l: -1:initx:1 ];
	//NSLog( @"nil , game_aBlock style_l=%x, block_index_l=%d, initx=%d", style_l, s_l, b_l, initx);

	randomNumber1 =   arc4random() % 28;
	style_l = [ [globalData shareuserData] getStylebyindex: randomNumber1%28 ];
	block_index_l = randomNumber1/4;
	NSLog( @"viewDidLoad Next tip, style_l=%x,randomNumber1=%d, block_index_l=%d", style_l, randomNumber1, block_index_l);
	self.tipview.block_index = block_index_l;
	self.tipview.style  = style_l;	
	[self.tipview setNeedsDisplay];

	
	NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"Select" ofType:@"caf"];
	NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePath];
	audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:nil];
	[audioPlayer1 prepareToPlay];
	//[audioPlayer1 play];
	
	
	audioFilePath = [[NSBundle mainBundle] pathForResource:@"levelSound" ofType:@"caf"];
	audioFileURL = [NSURL fileURLWithPath:audioFilePath];
	audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:nil];
	[audioPlayer2 prepareToPlay];
	//[audioPlayer1 play];
	
	audioFilePath = [[NSBundle mainBundle] pathForResource:@"GolfHit" ofType:@"caf"];
	audioFileURL = [NSURL fileURLWithPath:audioFilePath];
	audioPlayer3 = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:nil];
	[audioPlayer3 prepareToPlay];
	
	audioFilePath = [[NSBundle mainBundle] pathForResource:@"SynthSweep_GameOver" ofType:@"caf"];
	audioFileURL = [NSURL fileURLWithPath:audioFilePath];
	audioPlayer4 = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:nil];
	[audioPlayer4 prepareToPlay];
	
	playbutton.enabled = TRUE;
	stopbutton.enabled = FALSE;
	
	level = 1;
    
//    UISwipeGestureRecognizer *leftRecognizer;
//    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
//    [leftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
//    [[self view] addGestureRecognizer:leftRecognizer];
//    [leftRecognizer release];
//    
//    UISwipeGestureRecognizer *rightRecognizer;
//    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
//    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
//    [[self view] addGestureRecognizer:rightRecognizer];
//    [rightRecognizer release];
//    
//    UISwipeGestureRecognizer *downRecognizer;
//    downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
//    [downRecognizer setDirection: UISwipeGestureRecognizerDirectionDown];
//    [[self view] addGestureRecognizer:downRecognizer];
//    [downRecognizer release];
//    
    
    UIPanGestureRecognizer *panRecognier = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handlePan:)];
    [[self view] addGestureRecognizer:panRecognier];
    [panRecognier release];
    
    UITapGestureRecognizer *doubleTap =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(tapDetected:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [doubleTap release];
    
    UILongPressGestureRecognizer *longPressRecognizer =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(longPressDetected:)];
    longPressRecognizer.minimumPressDuration = 0.3;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longPressRecognizer];
    [longPressRecognizer release];
    
    
}

- (IBAction)tapDetected:(UIGestureRecognizer *)sender {
    NSLog( @"Double Tap" );
    if( self.playing ){
        [self turnClicked:nil];
    }
    
}

-( void) handleLongPress{

  
    //NSLog( @"gameCanvas, height[%f], width[%f]" , contentView.frame.size.height, contentView.frame.size.width );
    //int pixelLocalationofBlock = contentView.boxWidth*game_aBlock.x;
    
    int columnNo = location_lastLongPressed.x/contentView.boxWidth;
    NSLog( @"handleLongPress, press[%f], block[%d], columNo[%d]", location_lastLongPressed.x,  game_aBlock.x, columnNo);
    if( columnNo < game_aBlock.x || columnNo==0 ){
        [game_aBlock moveLeft];
    }else if ( columnNo > game_aBlock.x ){
        [game_aBlock moveRight];
    }
}

static  CGPoint location_lastLongPressed;
- (IBAction)longPressDetected:(UIGestureRecognizer *)recognizer {
    
    location_lastLongPressed = [recognizer locationInView:self.view];
    NSLog( @"Long Press. x[%f], y[%f]", location_lastLongPressed.x, location_lastLongPressed.y );

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            //NSLog(@"handleLongPress: StateBegan");
            //[self handleLongPress:location_lastLongPressed];
            
            timer_for_touchinput = [NSTimer scheduledTimerWithTimeInterval:(0.15) target:self
                                                    selector:@selector(handleLongPress) userInfo:nil repeats:YES];

            
            break;
        case UIGestureRecognizerStateChanged:
            //NSLog(@"handleLongPress: StateChanged");
            //if(location.y > 75.0 && location.x > 25 && location.x < 300)
            break;
        case UIGestureRecognizerStateEnded:
            //NSLog(@"handleLongPress: StateEnded");
            //break;
            [timer_for_touchinput invalidate];
        default:
            break;
    }
}



- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    const double thresholdArray[] = { 0.00, 0.02, 0.20, 0.55, 0.66, 0.77, 1.4 };
    const double thresholdArrayDistance[] = { 0.00, 30, 40, 70, 80, 90, 110 };
    const int repreatNumArray[] = { 1, 2, 3, 4, 8, 16, 32 };

    
    static CGPoint startLocation;
    static CGPoint stopLocation;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startLocation = [recognizer locationInView:self.view];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        
        stopLocation = [recognizer locationInView:self.view];
        CGFloat dx = stopLocation.x - startLocation.x;
        CGFloat dy = stopLocation.y - startLocation.y;
        CGFloat distance = sqrt(dx*dx + dy*dy );
        
        //normal range of slideFactor is from 0.1 to 2
        int i = 1;
//        for ( ; i<sizeof(thresholdArray)/sizeof(double);i++ ){
//            NSLog(@"i=%d,  thresholdArray[i] [%f]", i, thresholdArray[i]);
//            if(slideFactor < thresholdArray[i] ){
//                break;
//            }
//        }

        for ( ; i<sizeof(thresholdArrayDistance)/sizeof(double);i++ ){
            NSLog(@"i=%d,  thresholdArrayDistance[i] [%f]", i, thresholdArrayDistance[i]);
            if(distance < thresholdArrayDistance[i] ){
                break;
            }
        }

     
        
        int repreatNum = repreatNumArray[i-1];
        if( abs(velocity.y) > abs( velocity.x ) && velocity.y > 0){
            if( slideFactor> thresholdArray[2]){
                repreatNum = repreatNumArray[6]; //if user gesture speed is high enough, then go straight down to buttom even the gesutre distance is short
            	[audioPlayer3 play];
            }
        }
        
        NSLog(@"slideFactor: %f, velocity.y[%f], velocity.x[%f], repreatNum[%d], distance[%f]", slideFactor, velocity.y, velocity.x, repreatNum, distance);
        if( self.playing ){
            for( int j=0;j<repreatNum;j++){
                if( abs(velocity.y) > abs( velocity.x )  ){
                    if(velocity.y < 0)
                    {
                        //NSLog(@"gesture went up");
                    }else{
                        //NSLog(@"gesture went down");
                        [self downClicked:nil];
                    }
                }else{
                    
                    if(velocity.x > 0)
                    {
                        //NSLog(@"gesture went right");
                        [self rightClicked:nil];
                    }
                    else
                    {
                        //NSLog(@"gesture went left");
                        [self leftClicked:nil];
                    }
                }
            }
        }
   
    }
    
}


- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender {


    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"get gesture right");
        [self rightClicked:nil];
        
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"get gesture Left");
         [self leftClicked:nil];
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"get gesture Down");
         [self downClicked:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[audioPlayer3 release];
	[audioPlayer2 release];
	[audioPlayer1 release];
}

@end
