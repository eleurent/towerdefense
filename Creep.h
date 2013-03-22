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

#define DELAY_POISON 90
#define DAMAGES_POISON 1

@interface Creep : NSObject
@property (strong, nonatomic) Map *map;
@property (strong, nonatomic)  Path *currentPath;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) float abscissa;
@property (assign, nonatomic) int hp;
@property (assign, nonatomic) float size;
@property (assign, nonatomic) float speed;
@property (assign, nonatomic) int price;
@property (assign, nonatomic) BOOL isFrozen;
@property (assign, nonatomic) BOOL isPoisonned;
@property (assign, nonatomic) int freezeDuration;
@property (assign, nonatomic) int poisonDuration;

- (id) initWithMap:(Map*)map hp:(int)hp speed:(float)speed size:(float)size color:(UIColor*)color price:(int)price;
- (id) initWithMap:(Map*)map andCreep:(Creep*)creep;
- (id) initSmallCreepInMap:(Map*)map;
- (id) initBigCreepInMap:(Map*)map;
- (id) initFastCreepInMap:(Map*)map;
- (id) initToughCreepInMap:(Map*)map;
- (id) initToughFastCreepInMap:(Map*)map;

- (void) moveInMap:(Map*)map;
- (CGPoint) getCoordinates;
- (CGPoint) getCoordinatesWithOffsetX:(int)x Y:(int)y andZoom:(float)zoom;
- (float) getSizeWithZoom:(float)zoom;
- (void) timeoutEffects;
- (void) hitByDamages:(int)damages inMap:(Map*)map;
+ (void) destroyCreepsInMap:(Map*)map;
- (void) undergoPoisonInMap:(Map*)map;

@end
