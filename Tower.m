//
//  Tower.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Tower.h"

@implementation Tower
- (id) initStandardWithPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = 0.5;
        self.fieldOfView = 4;
        self.speed = 1;
    }
    return self;
}

- (float) getRadiusWithZoom:(float)zoom {
    return zoom*self.radius*[Cell cellSize];
}
@end
