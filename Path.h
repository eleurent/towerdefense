//
//  Path.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Cell.h"

#define NORTH 0
#define EAST  1
#define SOUTH 2
#define WEST  3

@interface Path : Cell
@property (assign, nonatomic) int direction;
@property (strong, nonatomic) Path *previous;
@property (strong, nonatomic) Path *next;

- (id) initWithPositionX:(int)x Y:(int)y andDirection:(int)direction;
+ (Cell*) nextPositionInMap:(Map*)map;
+ (void) addPath:(Path*)path toMap:(Map*)map;
+ (void) addNorthToMap:(Map*)map;
+ (void) addEastToMap:(Map*)map;
+ (void) addSouthToMap:(Map*)map;
+ (void) addWestToMap:(Map*)map;

@end
