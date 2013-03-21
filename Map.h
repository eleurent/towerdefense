//
//  Map.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Cell;

@interface Map : NSObject
@property (strong, nonatomic) NSMutableArray *paths;
@property (strong, nonatomic) NSMutableArray *towers;
@property (strong, nonatomic) NSMutableArray *creeps;
@property (strong, nonatomic) NSMutableArray *waves;
@property (strong, nonatomic) NSMutableArray *bullets;
@property (strong, nonatomic) NSMutableArray *toDelete;


@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;
@property (assign, nonatomic) int money;
@property (assign, nonatomic) int clock;

- (id)initWithWidth:(int)width andHeight:(int)height;
- (void) buildFirstPath;
- (void) timeStep;
- (BOOL) isEmpty:(Cell*)cell;
@end
