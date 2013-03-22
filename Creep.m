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
    self = [[Creep alloc] initWithMap:map hp:5 speed:0.1 size:0.7 color:[UIColor yellowColor] price:2];
    return self;
}

- (id) initBigCreepInMap:(Map*)map {
    self = [[Creep alloc] initWithMap:map hp:10 speed:0.1 size:0.9 color:[UIColor orangeColor] price:3];
    return self;
}

- (id) initFastCreepInMap:(Map*)map {
    self = [[Creep alloc] initWithMap:map hp:3 speed:0.3 size:0.7 color:[UIColor colorWithRed:255 green:255 blue:50 alpha:1] price:5];
    return self;
}

- (id) initToughCreepInMap:(Map*)map {
    self = [[Creep alloc] initWithMap:map hp:35 speed:0.1 size:1.0 color:[UIColor orangeColor] price:10];
    return self;
}

- (id) initToughFastCreepInMap:(Map*)map {
    self = [[Creep alloc] initWithMap:map hp:15 speed:0.3 size:1.0 color:[UIColor darkGrayColor] price:10];
    return self;
}

- (void) moveInMap:(Map*)map {
    if (self.isFrozen) {
        self.abscissa += self.speed/5;
    }
    else {
        self.abscissa += self.speed;
    }
    while (self.abscissa > 1.) {
        if (!self.currentPath.next) {
            map.lives--;
            [self destroyInMap:map];
            break;
        }
        self.currentPath = self.currentPath.next;
        self.abscissa-=1.;
    }
}

- (void) timeoutEffects {
    if (self.isFrozen) {
        self.freezeDuration--;
    }
    if (self.freezeDuration <= 0) {
        self.isFrozen = NO;
    }
    
    if (self.isPoisonned) {
        self.poisonDuration--;
    }
    if (self.poisonDuration <= 0) {
        self.isPoisonned = NO;
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

- (void) undergoPoisonInMap:(Map*)map {
    if (self.isPoisonned && (self.poisonDuration % DELAY_POISON == 0)) {
        [self hitByDamages:DAMAGES_POISON inMap:map];
    }
}

- (void) hitByDamages:(int)damages inMap:(Map*)map {
    self.hp -= damages;
    if (self.hp <= 0) {
        map.money += self.price;
        [self destroyInMap:map];
    }
}

- (void) destroyInMap:(Map*)map {
    [map.toDelete addObject:self];
}

+ (void) destroyCreepsInMap:(Map*)map {
    [map.creeps removeObjectsInArray:map.toDelete];
}

@end
