//
//  ErsBox.m
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ErsBox.h"


@implementation ErsBox

@synthesize isColor, size, box_type_index;


-(ErsBox*) initWithParam: (BOOL) isColor_l :(int)box_type_index_l {
	self = [ super init];
	if( self ){
		self.isColor = isColor_l;
		self.box_type_index = box_type_index_l;
	}
	return self;
}

-(ErsBox*) clone {
	ErsBox* newBox = [ [ ErsBox alloc ] initWithParam: self.isColor:self.box_type_index ];
	newBox.size = self.size;
	
	return newBox;
}

@end
