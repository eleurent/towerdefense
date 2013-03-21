//
//  Creep.h
//  Tower Defense
//
//  Created by Edouard Leurent on 20/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "Path.h"

@interface Creep : NSObject
@property (strong, nonatomic) Map *map;
@property (strong, nonatomic)  Path *currentPath;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) float abscissa;
@property (assign, nonatomic) int hp;
@property (assign, nonatomic) float size;
@property (assign, nonatomic) float speed;
@property (assign, nonatomic) int price;
@property (assign, nonatomic) BOOL freeze;
@property (assign, nonatomic) BOOL poison;
@property (assign, nonatomic) int freezeDuration;
@property (assign, nonatomic) int poisonDuration;

- (id) initWithMap:(Map*)map hp:(int)hp speed:(float)speed size:(float)size color:(UIColor*)color price:(int)price;
- (id) initWithMap:(Map*)map andCreep:(Creep*)creep;
- (id) initSmallCreepInMap:(Map*)map;
- (id) initBigCreepInMap:(Map*)map;
- (id) initFastCreepInMap:(Map*)map;
- (void) move;
- (CGPoint) getCoordinates;
- (CGPoint) getCoordinatesWithOffsetX:(int)x Y:(int)y andZoom:(float)zoom;
- (float) getSizeWithZoom:(float)zoom;
- (void) hitByDamages:(int)damages inMap:(Map*)map;
@end
