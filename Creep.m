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
    self = [[Creep alloc] initWithMap:map hp:3 speed:0.2 size:0.7 color:[UIColor yellowColor] price:10];
    return self;
}

- (id) initBigCreepInMap:(Map*)map {
    self = [[Creep alloc] initWithMap:map hp:8 speed:0.1 size:0.9 color:[UIColor colorWithRed:200 green:200 blue:0 alpha:1] price:10];
    return self;
}

- (id) initFastCreepInMap:(Map*)map {
    self = [[Creep alloc] initWithMap:map hp:2 speed:0.4 size:0.7 color:[UIColor colorWithRed:255 green:255 blue:50 alpha:1] price:10];
    return self;
}

- (void) move {
    if (self.freeze) {
        self.abscissa += self.speed/3;
    }
    else {
        self.abscissa += self.speed;
    }
    while (self.abscissa > 1. && self.currentPath.next) {
        self.currentPath = self.currentPath.next;
        self.abscissa-=1.;
    }
}

- (CGPoint) getCoordinates {
    CGPoint position = CGPointMake(self.currentPath.x+0.5, self.currentPath.y+0.5);
    switch (self.currentPath.direction) {
        case NORTH:
            position.y -= self.abscissa;
            break;
        case EAST:
            position.x += self.abscissa;
            break;
        case SOUTH:
            position.y += self.abscissa;
            break;
        case WEST:
            position.x -= self.abscissa;
        default:
            break;
    }
    return position;
}

- (CGPoint) getCoordinatesWithOffsetX:(int)x Y:(int)y andZoom:(float)zoom {
    CGPoint position = [self getCoordinates];
    return CGPointMake(x+zoom*position.x*[Cell cellSize], y+zoom*position.y*[Cell cellSize]);
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
