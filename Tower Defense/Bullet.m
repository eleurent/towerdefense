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
- (id) initWithPosition:(CGPoint)pos direction:(CGPoint)dir length:(float)length width:(float)width speed:(float)speed damages:(int)damages effect:(int)effect area:(BOOL)area color:(UIColor*)color undestroyable:(BOOL)undestroyable {
    self = [[Bullet alloc] init];
    if (self ) {
        position = pos;
        direction = dir;
        float n = sqrt(direction.x*direction.x + direction.y*direction.y);
        direction.x/=n;
        direction.y/=n;
        self.length = length;
        self.width = width;
        self.speed = speed;
        self.damages = damages;
        self.effect = effect;
        self.color = color;
        self.undestroyable = undestroyable;
    }
    return self;
}

-(CGPoint) position {
    return position;
}

-(CGPoint) direction {
    return direction;
}

- (void) moveInMap:(Map*)map {
    position.x+=direction.x*self.speed;
    position.y+=direction.y*self.speed;
    
    if(position.x < -self.length || position.x > map.width + self.length || position.y < -self.length || position.y > map.height + self.length)
        [map.toDelete addObject:self];
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
    if (self.effect == FREEZE) {
        creep.isFrozen = YES;
        creep.freezeDuration = DURATION_FREEZE;
    }
    
    if (self.effect == POISON) {
        creep.isPoisonned = YES;
        creep.poisonDuration = DURATION_POISON;
    }
    
    [creep hitByDamages:self.damages inMap:map]; //ATTENTION LE MONSTRE ACTUEL PEUT DISPARAITRE ICI
    if (!self.undestroyable)
        [map.toDelete addObject:self]; //ATTENTION PROJECTILE DEJA RETIRE EN CAS DE DEGATS DE ZONE
}

+ (void) destroyBulletsInMap:(Map*)map {
    [map.bullets removeObjectsInArray:map.toDelete];
}

- (void) hitCreepsAroundCreep:(Creep*)creep inMap:(Map*)map {
    for (Creep* creepNeighbor in map.creeps) {
        if ([Tower distanceBetween: [creep getCoordinates] and:position] < DISTANCE_AREA) {
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