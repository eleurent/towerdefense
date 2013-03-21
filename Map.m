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

        Creep* smallCreep = [[Creep alloc] initSmallCreepInMap:self];
        Creep* bigCreep = [[Creep alloc] initBigCreepInMap:self];
        Creep* fastCreep = [[Creep alloc] initFastCreepInMap:self];
        Wave *wave = [[Wave alloc] initWith:10 creeps:smallCreep  inDelay:50 andDuration:20 inMap:self];
        Wave *wave2 = [[Wave alloc] initWith:10 creeps:fastCreep  inDelay:300 andDuration:20 inMap:self];
        Wave *wave3 = [[Wave alloc] initWith:10 creeps:bigCreep  inDelay:550 andDuration:20 inMap:self];
        
        [self.waves addObject:wave3];
        [self.waves addObject:wave2];
        [self.waves addObject:wave];
        
        self.money = 20;
        
        [self buildFirstPath];
    }
    return self;
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
    [Path add:11 pathsToMap:self inDirection:EAST];
}

- (void) addCreep:(Creep*)creep {
    creep.currentPath = [self.paths objectAtIndex:0];
    [self.creeps addObject:creep];
}

- (void) timeStep {
    self.clock++;
    for (Creep *c in self.creeps) {
        [c move];
    }
    for (Tower *t in self.towers) {
        [t searchAndDestroy:self];
    }
    for (Bullet *b in self.bullets) {
        [b move];
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
