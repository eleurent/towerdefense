//
//  Path.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Path.h"

@implementation Path
- (id) initWithPositionX:(int)x Y:(int)y andDirection:(int)direction {
    self = [[Path alloc] initWithPositionX:x Y:y];
    if (self) {
        self.direction = direction;
    }
    return self;
}

+ (Cell*) nextPositionInMap:(Map*)map {
    Path *last = [map.paths lastObject];
    switch(last.direction) {
        case (NORTH): {
            Cell* newCell = [[Cell alloc] initWithPositionX:last.x Y:last.y-1];
            return newCell;
        } break;
        case (EAST): {
            Cell* newCell = [[Cell alloc] initWithPositionX:last.x+1 Y:last.y];
            return newCell;
        } break;
        case (SOUTH): {
            Cell* newCell = [[Cell alloc] initWithPositionX:last.x Y:last.y+1];
            return newCell;
        } break;
        case (WEST): {
            Cell* newCell = [[Cell alloc] initWithPositionX:last.x-1 Y:last.y];
            return newCell;
        } break;
        default:
            return nil;
    }
}

+ (void) addPath:(Path*)path toMap:(Map*)map {
    Path *last = [map.paths lastObject];
    last.next = path;
    path.previous = last;
    [map.paths addObject:path];
}

+ (void) addNorthToMap:(Map*)map {
    Cell *newCell = [Path nextPositionInMap:map];
    Path *newPath = [[Path alloc] initWithPositionX:newCell.x Y:newCell.y andDirection:NORTH];
    [Path addPath:newPath toMap:map];
}

+ (void) addEastToMap:(Map*)map {
    Cell *newCell = [Path nextPositionInMap:map];
    Path *newPath = [[Path alloc] initWithPositionX:newCell.x Y:newCell.y andDirection:EAST];
    [Path addPath:newPath toMap:map];
}

+ (void) addSouthToMap:(Map*)map {
    Cell *newCell = [Path nextPositionInMap:map];
    Path *newPath = [[Path alloc] initWithPositionX:newCell.x Y:newCell.y andDirection:SOUTH];
    [Path addPath:newPath toMap:map];
}

+ (void) addWestToMap:(Map*)map {
    Cell *newCell = [Path nextPositionInMap:map];
    Path *newPath = [[Path alloc] initWithPositionX:newCell.x Y:newCell.y andDirection:WEST];
    [Path addPath:newPath toMap:map];
}
@end
