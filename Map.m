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



@implementation Map

- (id)initWithWidth:(int)width andHeight:(int)height{
    if (self = [super init]) {
        self.width = width;
        self.height = height;
        self.towers = [[NSMutableArray alloc] init];
        self.paths = [[NSMutableArray alloc] init];
        self.creeps = [[NSMutableArray alloc] init];
        
        for (int i=0; i<40;i++) {
            Tower *tower = [[Tower alloc] initStandardWithPositionX:rand()%width Y:rand()%height];
            [self.towers addObject:tower];
        }
        
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

@end
