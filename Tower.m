//
//  Tower.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Tower.h"
#import "Bullet.h"

@implementation Tower
- (id) initStandardWithPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = 0.5;
        self.fieldOfView = 4.5;
        self.bulletSpeed = 0.2;
        self.bulletLength = 0.8;
        self.bulletWidth = 0.3;
        self.damages = 1;
        self.color = [UIColor colorWithRed:0.8 green:0.2 blue:0.1 alpha:1];
        self.reloadDelay = 10;
        self.bulletColor = [UIColor blackColor];
    }
    return self;
}

- (float) getRadiusWithZoom:(float)zoom {
    return zoom*self.radius*[Cell cellSize];
}

- (float) getFOVWithZoom:(float)zoom {
    return zoom*self.fieldOfView*[Cell cellSize];
}

-(CGPoint) getCoordinates {
    return CGPointMake(self.x+0.5, self.y+0.5);
}

+ (float) distanceBetween:(CGPoint)A and:(CGPoint)B {
    return sqrt((B.x-A.x)*(B.x-A.x) + (B.y-A.y)*(B.y-A.y));
}

+ (CGPoint) differenceBetween:(CGPoint)A and:(CGPoint)B {
    return CGPointMake(B.x-A.x, B.y-A.y);
}

- (void) searchTargetAmong:(NSMutableArray*)creeps {
    self.target = nil;
    for (Creep* creep in creeps) {
        if ([Tower distanceBetween:[self getCoordinates] and:[creep getCoordinates]] <= self.fieldOfView) {
            self.target = creep;
            break;
        }
    }
}

- (void) searchAndDestroy:(Map*)map {
    if (self.reloadTime > 0) {
        self.reloadTime--;
    }
    else {
        if (!self.target) {
            [self searchTargetAmong:map.creeps];
        }
        else {
            [self fireTo:map.bullets];
        }
    }
}

- (void) fireTo:(NSMutableArray*)bullets {
    if (([Tower distanceBetween:[self getCoordinates] and:[self.target getCoordinates]] > self.fieldOfView) || (self.target.hp <= 0)) {
        self.target = nil;
    }
    else {
        CGPoint directionBullet = [Tower differenceBetween:[self getCoordinates] and:[self.target getCoordinates]];
        Bullet* bullet = [[Bullet alloc] initWithPosition:[self getCoordinates] direction:directionBullet length:self.bulletLength width:self.bulletWidth speed:self.bulletSpeed damages:self.damages effect:self.effect area:self.areaEffect color:self.bulletColor];
        [bullets addObject:bullet];
        self.reloadTime = self.reloadDelay;;
    }
}
@end
