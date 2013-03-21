//
//  Cell.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Cell.h"
#import "tdViewGame.h"


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

- (BOOL) isVisibleInView:(tdViewGame*)view {
    CGPoint position = [self getCoordinatesWithOffsetX:view.xOffset Y:view.yOffset andZoom:view.zoom];
    float size = [self getSizeWithZoom:view.zoom];
    return position.x + size/2 >= 0 && position.x - size/2 < view.bounds.size.width && position.y + size/2 >= 0 && position.y - size/2 < view.bounds.size.height;
}

- (CGPoint) getCoordinatesWithOffsetX:(int)x Y:(int)y andZoom:(float)zoom {
    return CGPointMake(x+zoom*(self.x+0.5)*cellSize, y+zoom*(self.y+0.5)*cellSize);
}

- (float) getSizeWithZoom:(float)zoom {
    return cellSize*zoom;
}

@end



