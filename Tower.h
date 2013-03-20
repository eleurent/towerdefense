//
//  Tower.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Cell.h"

@interface Tower : Cell
@property (assign, nonatomic) int fieldOfView;
@property (assign, nonatomic) int speed;
@property (assign, nonatomic) float radius;
@property (assign, nonatomic) float reloadTime;
@property (assign, nonatomic) float damages;
@property (assign, nonatomic) int effect;
@property (assign, nonatomic) BOOL areaEffect;
@property (strong, nonatomic) UIColor *color;

- (id) initStandardWithPositionX:(int)x Y:(int)y;
- (float) getRadiusWithZoom:(float)zoom;
@end