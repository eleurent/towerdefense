//
//  Wave.h
//  Tower Defense
//
//  Created by Edouard Leurent on 20/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "Creep.h"


@interface Wave : NSObject
@property (strong, nonatomic) NSMutableArray *creeps;
@property (strong, nonatomic) NSMutableArray *times;

- (id) initWith:(int)number creeps:(Creep*)creep inDelay:(int)delay andDuration:(int)duration inMap:(Map*)map;
- (void) add:(int)number creeps:(Creep*)creep inMap:(Map*)map;
- (void) fillTimesWithDelay:(int)delay andDuration:(int)duration;

- (Creep*) spawnCreep;
@end
