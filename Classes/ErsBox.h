//
//  ErsBox.h
//  TetrisGame
//
//  Created by Yanzhu Wen on 12/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ErsBox : NSObject {
	BOOL isColor;
	int	size;
	int box_type_index;
}

@property (nonatomic ) BOOL isColor;
@property (nonatomic ) int size;
@property (nonatomic ) int box_type_index;


-(ErsBox*) initWithParam: (BOOL) isColor_l : (int)index_l;
-(ErsBox*) clone;


@end
