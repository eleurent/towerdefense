//
//  Map.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Map.h"
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
        
        for (int i=0; i<40;i++) {
            Tower *tower = [[Tower alloc] initStandardWithPositionX:rand()%width Y:rand()%height];
            [self.towers addObject:tower];
        }

        Creep* smallCreep = [[Creep alloc] initSmallCreepInMap:self];
        Wave *wave = [[Wave alloc] initWith:10 creeps:smallCreep  inDelay:20 andDuration:10 inMap:self];
        [self.waves addObject:wave];
        
        [self buildFirstPath];
    }
    return self;
}

- (void) buildFirstPath {
    Path *start = [[Path alloc] initWithPositionX:2 Y:0 andDirection:SOUTH];
    [Path addPath:start toMap:self];
    [Path addSouthToMap:self];
    [Path addSouthToMap:self];
    [Path addSouthToMap:self];
    [Path addSouthToMap:self];
    [Path addSouthToMap:self];
    [Path addSouthToMap:self];
    [Path addSouthToMap:self];
    [Path addSouthToMap:self];
    [Path addSouthToMap:self];
    [Path addEastToMap:self];
    [Path addEastToMap:self];
    [Path addEastToMap:self];
    [Path addNorthToMap:self];
    [Path addNorthToMap:self];
    [Path addEastToMap:self];
    [Path addEastToMap:self];
    [Path addEastToMap:self];
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

@end
