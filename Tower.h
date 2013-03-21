//
//  Tower.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Cell.h"
#import "Creep.h"

@interface Tower : Cell
@property (assign, nonatomic) float fieldOfView;
@property (assign, nonatomic) float radius;
@property (assign, nonatomic) int reloadTime;
@property (assign, nonatomic) int reloadDelay;
@property (assign, nonatomic) int damages;
@property (assign, nonatomic) float bulletSpeed;
@property (assign, nonatomic) float bulletLength;
@property (assign, nonatomic) float bulletWidth;
@property (strong, nonatomic) UIColor *bulletColor;
@property (assign, nonatomic) int effect;
@property (assign, nonatomic) BOOL areaEffect;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) Creep *target;

- (id) initStandardWithPositionX:(int)x Y:(int)y;
- (float) getRadiusWithZoom:(float)zoom;
- (float) getFOVWithZoom:(float)zoom;
- (void) searchTargetAmong:(NSMutableArray*)creeps;
- (void) searchAndDestroy:(Map*)map;
- (void) fireTo:(NSMutableArray*)bullets;

+ (float) distanceBetween:(CGPoint)A and:(CGPoint)B;
+ (CGPoint) differenceBetween:(CGPoint)A and:(CGPoint)B;


@end