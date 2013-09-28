//
//  GradientDrawingView.m
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GradientDrawingView.h"
#import "ErsBlock.h"


@implementation GradientDrawingView

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		CGFloat colors[] =
		{
			0.549, 0.902, 0.992, 1.00,
			0.173, 0.565, 0.914 ,1.00,
		};
		
		CGFloat colors1[] =
		{
			1.000,  0.522, 0.643, 1.00,
			0.650, 0.173, 0.188,  1.00,
		};
		CGFloat colors2[] =
		{
			0.780, 0.612, 0.996, 1.00,
			0.455, 0.251, 0.831, 1.00,
		};
		
		CGFloat colors3[] =
		{
			0.369, 0.682, 0.996, 1.00,
			0.259, 0.208, 0.831, 1.00,
		};
		
		CGFloat colors4[] =
		{
			1.000, 0.678, 0.325, 1.00,
			0.980, 0.431, 0.302, 1.00,
		};
		CGFloat colors5[] =
		{
			0.600, 0.988, 0.267, 1.00,
			0.185, 0.655, 0.239, 1.00,
		};
		
		CGFloat colors6[] =
		{
			0.996, 0.922, 0.149, 1.00,
			0.916, 0.678, 0.031, 1.00,
		};
		
		
		gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
		CGGradientRef grad1 = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
		gradient_array =  [[NSMutableArray alloc] init];
		[gradient_array addObject: (id)grad1];
				
		grad1 = CGGradientCreateWithColorComponents(rgb, colors1, NULL, 2);
		[gradient_array addObject: (id)grad1];
		
		grad1 = CGGradientCreateWithColorComponents(rgb, colors2, NULL, 2);
		[gradient_array addObject: (id)grad1];

		grad1 = CGGradientCreateWithColorComponents(rgb, colors3, NULL, 2);
		[gradient_array addObject: (id)grad1];

		grad1 = CGGradientCreateWithColorComponents(rgb, colors4, NULL, 2);
		[gradient_array addObject: (id)grad1];

		grad1 = CGGradientCreateWithColorComponents(rgb, colors5, NULL, 2);
		[gradient_array addObject: (id)grad1];

		grad1 = CGGradientCreateWithColorComponents(rgb, colors6, NULL, 2);
		[gradient_array addObject: (id)grad1];
	
		CGColorSpaceRelease(rgb);
	}
	return self;
}

-(void)dealloc
{
	CGGradientRelease(gradient);
	[super dealloc];
}

// Returns an appropriate starting point for the demonstration of a linear gradient
CGPoint demoLGStart(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}

// Returns an appropriate ending point for the demonstration of a linear gradient
CGPoint demoLGEnd(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}

// Returns the center point for for the demonstration of the radial gradient
CGPoint demoRGCenter(CGRect bounds)
{
	return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

// Returns an appropriate inner radius for the demonstration of the radial gradient
CGFloat demoRGInnerRadius(CGRect bounds)
{
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.125;
}

// Returns an appropriate outer radius for the demonstration of the radial gradient
CGFloat demoRGOuterRadius(CGRect bounds)
{
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.5;
}

-(void)drawInContext:(CGContextRef)context :(CGRect) bounds{
	[self drawInContextByType: context: bounds: 6 ];
}

-(void)drawInContextMethod3:(CGContextRef)context :(CGRect) bounds :(int)blocktype;
{
	// The clipping rects we plan to use, which also defines the location and span of each gradient
	CGRect clips[] =
	{
		bounds,
	};
	
	// Linear Gradients
	CGPoint start, end;
	int index_l = blocktype%BLOCK_KIND_NUMBER;
	CGGradientRef grad1 =(CGGradientRef) [gradient_array objectAtIndex: index_l ];
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[0]);
	start = demoLGStart(clips[0]);
	end = demoLGEnd(clips[0]);
	CGContextDrawLinearGradient(context, grad1, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	
	// Drawing with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	// And draw with a blue fill color
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 2.0);
	
	// If you were making this as a routine, you would probably accept a rectangle
	// that defines its bounds, and a radius reflecting the "rounded-ness" of the rectangle.
	CGRect rrect = bounds;
	CGFloat radius = 5.0;
	// NOTE: At this point you may want to verify that your radius is no more than half
	// the width and height of your rectangle, as this technique degenerates for those cases.
	// In order to draw a rounded rectangle, we will take advantage of the fact that
	// CGContextAddArcToPoint will draw straight lines past the start and end of the arc
	// in order to create the path from the current position and the destination position.
	// In order to create the 4 arcs correctly, we need to know the min, mid and max positions
	// on the x and y lengths of the given rectangle.
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	// Next, we will go around the rectangle in the order given by the figure below.
	//       minx    midx    maxx
	// miny    2       3       4
	// midy   1 9              5
	// maxy    8       7       6
	// Which gives us a coincident start and end point, which is incidental to this technique, but still doesn't
	// form a closed path, so we still need to close the path to connect the ends correctly.
	// Thus we start by moving to point 1, then adding arcs through each pair of points that follows.
	// You could use a similar tecgnique to create any shape with rounded corners.
	
	// Start at 1
	CGContextMoveToPoint(context, minx, midy);
	// Add an arc through 2 to 3
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	// Add an arc through 4 to 5
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	// Add an arc through 6 to 7
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	// Add an arc through 8 to 9
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	// Close the path
	CGContextClosePath(context);
	
	// Fill & stroke the path
	//CGContextDrawPath(context, kCGPathFillStroke);
	
	// Show the clipping areas
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, 0.6);
	CGContextStrokePath(context);	
	
		
}

-(void)drawInContextByType:(CGContextRef)context :(CGRect) bounds :(int)blocktype;
{
	// The clipping rects we plan to use, which also defines the location and span of each gradient
	CGRect clips[] =
	{
		bounds,
	};
	
	// Linear Gradients
	CGPoint start, end;
	int index_l = blocktype%BLOCK_KIND_NUMBER;
	CGGradientRef grad1 = (CGGradientRef)[gradient_array objectAtIndex: index_l ];
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[0]);
	start = demoLGStart(clips[0]);
	end = demoLGEnd(clips[0]);
	//CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextDrawLinearGradient(context, grad1, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	// Show the clipping areas
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, 0.8);
	CGContextAddRects(context, clips, sizeof(clips)/sizeof(clips[0]));
	CGContextStrokePath(context);	
}

-(void)drawInBounderByType:(CGContextRef)context :(CGRect) bounds :(int)blocktype;
{
	// The clipping rects we plan to use, which also defines the location and span of each gradient
	CGRect clips[] =
	{
		bounds,
	};
	
	
	//int index_l = blocktype%BLOCK_KIND_NUMBER;
	//CGGradientRef grad1 = [gradient_array objectAtIndex: index_l ];
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[0]);
			
	// Show the clipping areas
	CGContextSetLineWidth(context, 6.0);
	CGContextSetRGBStrokeColor(context,  1.0, 1.0, 1.0, 0.8);
	CGContextAddRects(context, clips, sizeof(clips)/sizeof(clips[0]));
	CGContextStrokePath(context);
	
}

-(void)drawInBounderByType2:(CGContextRef)context :(CGRect[]) bounds : (int)boundsize;
{
			
	// Show the clipping areas
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context,  0.1, 0.1, 0.1, 0.4);
	CGContextAddRects(context, bounds, boundsize);
	CGContextStrokePath(context);
	
}


@end
