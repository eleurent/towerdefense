//
//  Map.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Map.h"
#import "Tower.h"



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
    }
    return self;
}

@end
