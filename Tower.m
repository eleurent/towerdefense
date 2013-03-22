//
//  Tower.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Tower.h"
#import "Bullet.h"
#import <AVFoundation/AVFoundation.h>

@implementation Tower
- (id) initStandardWithPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = 0.4;
        self.fieldOfView = 3.5;
        self.bulletSpeed = 0.20;
        self.bulletLength = 0.3;
        self.bulletWidth = 0.2;
        self.damages = 2;
        self.color = [UIColor colorWithRed:0.8 green:0.2 blue:0.1 alpha:1];
        self.reloadDelay = 20;
        self.bulletColor = [UIColor blackColor];
        self.price = 10;
    }
    return self;
}

- (id) initHeavyWithPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = 0.5;
        self.fieldOfView = 2.5;
        self.bulletSpeed = 0.1;
        self.bulletLength = 0.5;
        self.bulletWidth = 0.5;
        self.damages = 8;
        self.color = [UIColor colorWithWhite:0.1 alpha:1];
        self.reloadDelay = 40;
        self.bulletColor = [UIColor blackColor];
        self.price = 50;
        self.areaEffect = YES;
    }
    return self;
}

- (id) initFreezeWithPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = 0.5;
        self.fieldOfView = 2.5;
        self.bulletSpeed = 0.3;
        self.bulletLength = 0.2;
        self.bulletWidth = 0.2;
        self.damages = 0;
        self.color = [UIColor cyanColor];
        self.reloadDelay = 30;
        self.bulletColor = self.color;
        self.price = 30;
        self.effect = FREEZE;
        self.areaEffect = YES;
    }
    return self;
}

- (id) initFastWithPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = 0.5;
        self.fieldOfView = 6;
        self.bulletSpeed = 1.0;
        self.bulletLength = 3.0;
        self.bulletWidth = 0.2;
        self.damages = 1;
        self.color = [UIColor darkGrayColor];
        self.reloadDelay = 8;
        self.bulletColor = self.color;
        self.price = 150;
        self.effect = NORMAL;
        self.bulletUndestroyable = NO;
        self.areaEffect = NO;
    }
    return self;
}

- (id) initLaserWithPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = 0.5;
        self.fieldOfView = 4;
        self.bulletSpeed = 0.5;
        self.bulletLength = 4.0;
        self.bulletWidth = 0.1;
        self.damages = 1;
        self.color = [UIColor orangeColor];
        self.reloadDelay = 30;
        self.bulletColor = self.color;
        self.price = 90;
        self.effect = NORMAL;
        self.bulletUndestroyable = YES;
        self.areaEffect = NO;
    }
    return self;
}

- (id) initPoisonWithPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = 0.5;
        self.fieldOfView = 2.5;
        self.bulletSpeed = 0.3;
        self.bulletLength = 0.2;
        self.bulletWidth = 0.2;
        self.damages = 0;
        self.color = [UIColor purpleColor];
        self.reloadDelay = 22;
        self.bulletColor = self.color;
        self.price = 60;
        self.effect = POISON;
        self.areaEffect = NO;
    }
    return self;
}

- (id) initFromTower:(Tower*)t withPositionX:(int)x Y:(int)y {
    self = [super initWithPositionX:x Y:y];
    if (self) {
        self.radius = t.radius;
        self.fieldOfView = t.fieldOfView;
        self.bulletSpeed = t.bulletSpeed;
        self.bulletLength = t.bulletLength;
        self.bulletWidth = t.bulletWidth;
        self.damages = t.damages;
        self.color = t.color;
        self.reloadDelay = t.reloadDelay;
        self.bulletColor = t.bulletColor;
        self.price = t.price;
        self.effect = t.effect;
        self.areaEffect = t.areaEffect;
        self.bulletUndestroyable = t.bulletUndestroyable;
        
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
        Bullet* bullet = [[Bullet alloc] initWithPosition:[self getCoordinates] direction:directionBullet length:self.bulletLength width:self.bulletWidth speed:self.bulletSpeed damages:self.damages effect:self.effect area:self.areaEffect color:self.bulletColor undestroyable:self.bulletUndestroyable];
        [bullets addObject:bullet];
        self.reloadTime = self.reloadDelay;
    }
}
@end
