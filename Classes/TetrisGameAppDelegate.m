//
//  TetrisGameAppDelegate.m
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TetrisGameAppDelegate.h"
#import "TetrisGameViewController.h"

@implementation TetrisGameAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[application setStatusBarHidden:YES animated:NO];

    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    
    
    //[application  setStatusBarHidden:YES withAnimation:NO ];
    
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
