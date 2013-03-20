//
//  Creep.m
//  Tower Defense
//
//  Created by Edouard Leurent on 20/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Creep.h"

@implementation Creep
- (id) initWithMap:(Map*)map hp:(int)hp speed:(float)speed size:(float)size color:(UIColor*)color price:(int)price {
    self = [[Creep alloc] init];
    if (self) {
        self.map = map;
        self.hp = hp;
        self.speed = speed;
        self.size = size;
        self.color = color;
        self.price = price;
    }
    return self;
}

- (id) initWithMap:(Map*)map andCreep:(Creep*)creep {
    self = [[Creep alloc] initWithMap:map hp:creep.hp speed:creep.speed size:creep.size color:creep.color price:creep.price];
    return self;
}

- (id) initSmallCreepInMap:(Map*)map {
    self = [[Creep alloc] initWithMap:map hp:3 speed:0.2 size:0.7 color:[UIColor yellowColor] price:20];
    return self;
}

- (void) move {
    if (self.freeze) {
        self.abscissa += self.speed/3;
    }
    else {
        self.abscissa += self.speed;
    }
    while (self.abscissa > 1.) {
        if (self.currentPath.next != nil) {
            self.currentPath = self.currentPath.next;
            self.abscissa-=1.;
        }
    }
}

- (CGPoint) getCoordinatesinMap:(Map*)map withOffsetX:(int)x Y:(int)y andZoom:(float)zoom {
    float xCreep = self.currentPath.x;
    float yCreep = self.currentPath.y;
    switch (self.currentPath.direction) {
        case NORTH:
            yCreep -= self.abscissa;
            break;
        case EAST:
            xCreep += self.abscissa;
            break;
        case SOUTH:
            yCreep += self.abscissa;
            break;
        case WEST:
            xCreep -= self.abscissa;
        default:
            break;
    }
    return CGPointMake(x+zoom*(xCreep+0.5)*[Cell cellSize], y+zoom*(yCreep+0.5)*[Cell cellSize]);
}

- (float) getSizeWithZoom:(float)zoom {
    return zoom*self.size*[Cell cellSize];
}

- (void) hitByDamages:(int)damages inMap:(Map*)map {
    self.hp -= damages;
    if (self.hp <= 0)
        [self destroyInMap:map];
}

- (void) destroyInMap:(Map*)map {
    map.money += self.price;
    [map.creeps removeObject:self];
}

@end
