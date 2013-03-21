//
//  Bullet.h
//  Tower Defense
//
//  Created by Edouard Leurent on 20/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Creep.h"
#import "Map.h"

#define NORMAL 0
#define GLACE 1
#define POISON 2
#define DISTANCE_ZONE 1
#define DUREE_GEL = 100
#define DUREE_POISON = 200
#define DELAI_POISON = 30
#define DEGATS_POISON = 1

@interface Bullet : NSObject
{
    CGPoint position;
    CGPoint direction;
}

@property (assign, nonatomic) float length;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float speed;
@property (assign, nonatomic) int damages;
@property (assign, nonatomic) int effect;
@property (assign, nonatomic) BOOL area;
@property (strong, nonatomic) UIColor* color;

- (id) initWithPosition:(CGPoint)pos direction:(CGPoint)dir length:(float)length width:(float)width speed:(float)speed damages:(int)damages effect:(int)effect area:(BOOL)area color:(UIColor*)color;
- (void) move;
- (CGPoint) position;
- (CGPoint) direction;
- (BOOL) isCollidingCreep:(Creep*)creep;
- (void) collideInMap:(Map*)map;
+ (void) destroyBulletsInMap:(Map*)map;
- (void) hitCreep:(Creep*)creep inMap:(Map*)map;
- (void) hitCreepsAroundCreep:(Creep*)creep inMap:(Map*)map;
- (CGPoint) getCoordinatesWithOffsetX:(int)x Y:(int)y andZoom:(float)zoom;
- (float) getLengthWithZoom:(float)zoom;
- (float) getWidthWithZoom:(float)zoom;


@end
