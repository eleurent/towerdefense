//
//  Bullet.m
//  Tower Defense
//
//  Created by Edouard Leurent on 20/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Bullet.h"
#import "Tower.h"

@implementation Bullet
- (id) initWithPosition:(CGPoint)pos direction:(CGPoint)dir length:(float)length width:(float)width speed:(float)speed damages:(int)damages effect:(int)effect area:(BOOL)area color:(UIColor*)color {
    self = [[Bullet alloc] init];
    if (self ) {
        position = pos;
        direction = dir;
        self.length = length;
        self.width = width;
        self.speed = speed;
        self.damages = damages;
        self.effect = effect;
        self.color = color;
    }
    return self;
}

-(CGPoint) position {
    return position;
}

-(CGPoint) direction {
    return direction;
}

- (void) move {
    position.x+=direction.x*self.speed;
    position.y+=direction.y*self.speed;
}

- (BOOL) isCollidingCreep:(Creep*)creep {
    return [Tower distanceBetween: [creep getCoordinates] and:position] <= creep.size;
}

- (void) collideInMap:(Map*)map {
    for (Creep* creep in map.creeps) {
        if ([self isCollidingCreep:creep]) {
            if (self.area)
                [self hitCreepsAroundCreep:creep inMap:map];
            else
                [self hitCreep:creep inMap:map];
            break;
        }
    }
}

- (void) hitCreep:(Creep*)creep inMap:(Map*)map{
    if (self.effect == GLACE) {
        [creep freeze];
    }
    
    if (self.effect == POISON) {
        [creep poison];
    }
    
    [creep hitByDamages:self.damages inMap:map]; //ATTENTION LE MONSTRE ACTUEL PEUT DISPARAITRE ICI
    [map.toDelete addObject:self]; //ATTENTION PROJECTILE DEJA RETIRE EN CAS DE DEGATS DE ZONE
}

+ (void) destroyBulletsInMap:(Map*)map {
    [map.bullets removeObjectsInArray:map.toDelete];
}

- (void) hitCreepsAroundCreep:(Creep*)creep inMap:(Map*)map {
    for (Creep* creepNeighbor in map.creeps) {
        if ([Tower distanceBetween: [creep getCoordinates] and:position] < DISTANCE_ZONE) {
            if (creepNeighbor != creep)
                [self hitCreep:creepNeighbor inMap:map];
        }
    }
    [self hitCreep:creep inMap:map];
}

- (CGPoint) getCoordinatesWithOffsetX:(int)x Y:(int)y andZoom:(float)zoom {
    return CGPointMake(x+zoom*position.x*[Cell cellSize], y+zoom*position.y*[Cell cellSize]);
}

- (float) getLengthWithZoom:(float)zoom {
    return self.length * zoom * [Cell cellSize];
}

- (float) getWidthWithZoom:(float)zoom {
    return self.width * zoom * [Cell cellSize];
}

@end