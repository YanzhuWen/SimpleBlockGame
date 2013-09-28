//
//  globalData.m
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "globalData.h"


@implementation globalData
@synthesize TwoD_STYLES;

-(globalData*) init{
	self = [ super init];
	if( self ){
		int STYLES2[7][4] = {
			{0x0f00, 0x4444, 0x0f00, 0x4444}, 
			{0x04e0, 0x0464, 0x00e4, 0x04c4},
			{0x4620, 0x6c00, 0x4620, 0x6c00},
			{0x2640, 0xc600, 0x2640, 0xc600}, 
			{0x6220, 0x1700, 0x2230, 0x0740}, 
			{0x6440, 0x0e20, 0x44c0, 0x8e00}, 
			{0x0660, 0x0660, 0x0660, 0x0660}
		};
		
		TwoD_STYLES = [ [NSArray alloc]  initWithObjects:
					   [NSMutableArray new],
					   [NSMutableArray new],
					   [NSMutableArray new],
					   [NSMutableArray new], 
					   [NSMutableArray new], 
					   [NSMutableArray new], 
					   [NSMutableArray new], nil];
		for( int i=0; i<7; i++ ){
			for( int j=0; j<4;j++) {
				[[TwoD_STYLES objectAtIndex:i] addObject:[NSNumber numberWithInt:STYLES2[i][j] ]];
			}
		}
	}
	return self;
}

- (void)dealloc {	
	[super dealloc];
}

static  globalData* shareuserData = nil;
+ ( globalData*) shareuserData{
	@synchronized( self) {
		if( shareuserData == nil){
			shareuserData = [[self alloc] init ];
		}
	}
	return shareuserData;
}

-(int)getStylebyindex:(int)index{
	globalData* g = [globalData shareuserData];
	
	int row = (index%28)/4;
	NSMutableArray* array = [ g.TwoD_STYLES objectAtIndex: row ];
	int col = (index-4*row)%4;
	
	int result = [[array objectAtIndex: col] intValue];
	return result;
}

-(int)getStylebyrc:(int)row :(int)col{
	
	globalData* g = [globalData shareuserData];
	

	NSMutableArray* array = [ g.TwoD_STYLES objectAtIndex: row ];
	int result = [[array objectAtIndex: col] intValue];
	return result;
	
	
}

@end
