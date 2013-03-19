//
//  Path.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Path.h"
#define NORTH 0
#define EAST 1
#define SOUTH 2
#define WEST 3

@interface Path : Cell
@property (assign, nonatomic) int direction;
@end
