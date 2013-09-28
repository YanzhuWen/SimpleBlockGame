//
//  GradientDrawingView.h
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GradientDrawingView : UIView
{
	NSMutableArray* gradient_array;
	CGGradientRef gradient;
}

-(void)drawInContext:(CGContextRef) my_context :(CGRect) cg;
-(void)drawInContextByType:(CGContextRef) context :(CGRect) cg :(int) blocktype;
-(void)drawInBounderByType:(CGContextRef) context :(CGRect) cg :(int) blocktype;

-(void)drawInBounderByType2:(CGContextRef)context :(CGRect[]) bounds :(int)boundsize;
-(void)drawInContextMethod3:(CGContextRef)context :(CGRect) bounds :(int)blocktype;

@end

