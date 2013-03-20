//
//  Cell.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Cell.h"


static int cellSize=20;

@implementation Cell

+ (int)cellSize {
    return cellSize;
}

- (id) initWithPositionX:(int)x Y:(int)y {
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}

- (BOOL) isInX:(int)x Y:(int)y {
    return x >= self.x && x < self.x + cellSize && y >= self.y && y < self.y + cellSize;
}

- (BOOL) isVisibleInMap:(Map*)map WithOffsetX:(int)x Y:(int)y andZoom:(float)zoom {
    return x <= self.x*cellSize + cellSize/2 && x + zoom * map.width*cellSize >= self.x*cellSize - cellSize/2
        && y <= self.y*cellSize + cellSize/2 && y + zoom * map.height*cellSize >= self.y*cellSize - cellSize/2;
}

- (CGPoint) getCoordinatesinMap:(Map*)map withOffsetX:(int)x Y:(int)y andZoom:(float)zoom {
    return CGPointMake(x+zoom*(self.x+0.5)*cellSize, y+zoom*(self.y+0.5)*cellSize);
}

- (float) getSizeWithZoom:(float)zoom {
    return cellSize*zoom;
}

@end



