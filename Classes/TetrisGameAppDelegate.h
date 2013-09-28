//
//  TetrisGameAppDelegate.h
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TetrisGameViewController;

@interface TetrisGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TetrisGameViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TetrisGameViewController *viewController;

@end

