//
//  Wave.m
//  Tower Defense
//
//  Created by Edouard Leurent on 20/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Wave.h"

@implementation Wave
- (id) initWith:(int)number creeps:(Creep*)creep inDelay:(int)delay andDuration:(int)duration inMap:(Map*)map {
    self = [[Wave alloc] init];
    [self fillCreepsWith:number creeps:creep inMap:map];
    [self fillTimesWithDelay:delay andDuration:duration];
    return self;
}

- (void) fillCreepsWith:(int)number creeps:(Creep*)creep inMap:(Map*)map {
    for (int i=0; i<number;i++){
        [self.creeps addObject:[[Creep alloc] initSmallCreepInMap:map]];
    }
}

- (void) fillTimesWithDelay:(int)delay andDuration:(int)duration {
    [self.times removeAllObjects];
    for (int i=0; i<[self.creeps count];i++){
        [self.times addObject:[[NSNumber alloc] initWithInt:duration+delay*i]];
    }
}
@end
