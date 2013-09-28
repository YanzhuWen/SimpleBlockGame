//
//  globalData.h
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface globalData : NSObject {
	NSArray* TwoD_STYLES;
}
//declare constructor
-(globalData*)init;
+(globalData*)shareuserData;

-(int)getStylebyindex:(int)index;
-(int)getStylebyrc:(int)row :(int)col;

@property (nonatomic, retain) NSArray* TwoD_STYLES;

@end

