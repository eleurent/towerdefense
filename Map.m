//
//  Map.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Map.h"
#import "Cell.h"
#import "Tower.h"
#import "Path.h"
#import "Creep.h"
#import "Wave.h"
#import "Bullet.h"


@implementation Map

- (id)initWithWidth:(int)width andHeight:(int)height{
    if (self = [super init]) {
        self.width = width;
        self.height = height;
        self.towers = [[NSMutableArray alloc] init];
        self.paths = [[NSMutableArray alloc] init];
        self.creeps = [[NSMutableArray alloc] init];
        self.waves = [[NSMutableArray alloc] init];
        self.bullets = [[NSMutableArray alloc] init];
        self.toDelete = [[NSMutableArray alloc] init];

               
        /*
        Wave *wave = [[Wave alloc] initWith:10 creeps:smallCreep  inDelay:50 andDuration:30 inMap:self];
        Wave *wave2 = [[Wave alloc] initWith:15 creeps:smallCreep  inDelay:50 andDuration:20 inMap:self];
        Wave *wave3 = [[Wave alloc] initWith:5 creeps:fastCreep  inDelay:100 andDuration:20 inMap:self];
        Wave *wave4 = [[Wave alloc] initWith:10 creeps:bigCreep  inDelay:50 andDuration:20 inMap:self];
        Wave *wave5 = [[Wave alloc] initWith:20 creeps:smallCreep  inDelay:50 andDuration:20 inMap:self];
        Wave *wave6 = [[Wave alloc] initWith:10 creeps:bigCreep  inDelay:50 andDuration:5 inMap:self];


        [self.waves addObject:wave6];
        [self.waves addObject:wave5];
        [self.waves addObject:wave4];
        [self.waves addObject:wave3];
        [self.waves addObject:wave2];
        [self.waves addObject:wave];*/
        [self buildWaves];
        
        self.money = 30;
        self.lives = 5;
        
        [self buildFirstPath];
    }
    return self;
}

- (void) buildWaves {
    Creep* smallCreep = [[Creep alloc] initSmallCreepInMap:self];
    Creep* bigCreep = [[Creep alloc] initBigCreepInMap:self];
    Creep* fastCreep = [[Creep alloc] initFastCreepInMap:self];
    srandom(time(NULL));
    Wave *wave = nil;
    Creep *creep = nil;
    
    for (int i=0; i<5; i++) {
        int ncreep = random()%10;
        if (ncreep<2)
            creep = smallCreep;
        else if (ncreep <6)
            creep = bigCreep;
        else
            creep = fastCreep;
        wave = [[Wave alloc] initWith:random()%20+25 creeps:creep  inDelay:random()%50+20 andDuration:random()%10+5 inMap:self];
        [self.waves addObject:wave];
    }
    
    for (int i=0; i<5; i++) {
        int ncreep = random()%10;
        if (ncreep<5)
            creep = smallCreep;
        else if (ncreep <8)
            creep = bigCreep;
        else
            creep = fastCreep;
        wave = [[Wave alloc] initWith:random()%10+5 creeps:creep  inDelay:random()%50+50 andDuration:random()%20+20 inMap:self];
        [self.waves addObject:wave];
    }
    wave = [[Wave alloc] initWith:random()%10+5 creeps:smallCreep  inDelay:random()%50+50 andDuration:20 inMap:self];
    [self.waves addObject:wave];
    
}

- (void) buildFirstPath {
    Path *start = [[Path alloc] initWithPositionX:2 Y:0 andDirection:SOUTH];
    [Path addPath:start toMap:self];
    [Path add:12 pathsToMap:self inDirection:SOUTH];
    [Path add:5 pathsToMap:self inDirection:EAST];
    [Path add:10 pathsToMap:self inDirection:NORTH];
    [Path add:13 pathsToMap:self inDirection:EAST];
    [Path add:5 pathsToMap:self inDirection:SOUTH];
    [Path add:8 pathsToMap:self inDirection:WEST];
    [Path add:5 pathsToMap:self inDirection:SOUTH];
    [Path add:12 pathsToMap:self inDirection:EAST];
}

- (void) addCreep:(Creep*)creep {
    creep.currentPath = [self.paths objectAtIndex:0];
    [self.creeps addObject:creep];
}

- (void) timeStep {
    self.clock++;
    for (Creep *c in self.creeps) {
        [c moveInMap:self];
        [c undergoPoisonInMap:self];
        [c timeoutEffects];

    }
    [Creep destroyCreepsInMap:self];
    for (Tower *t in self.towers) {
        [t searchAndDestroy:self];
    }
    for (Bullet *b in self.bullets) {
        [b moveInMap:self];
        [b collideInMap:self];
    }
    [Bullet destroyBulletsInMap:self];
    if ([self.waves count] >0) {
        Wave *lastWave = [self.waves lastObject];
        if ([[lastWave creeps] count] == 0 ) {
            self.clock = 0;
            [self.waves removeLastObject];
        }
        else {
            if ([[lastWave.times lastObject] integerValue] <= self.clock) {
                [self addCreep:[lastWave spawnCreep]];
            }
        }
    }
}

- (BOOL) isEmpty:(Cell*)cell {
    for (Tower* t in self.towers) {
        if (t.x == cell.x && t.y == cell.y)
            return NO;
    }
    for (Path* p in self.paths) {
        if (p.x == cell.x && p.y == cell.y)
            return NO;
    }
    return YES;
}

@end
