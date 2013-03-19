//
//  Map.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Map : NSObject
@property (strong, nonatomic) NSMutableArray *paths;
@property (strong, nonatomic) NSMutableArray *towers;
@property (strong, nonatomic) NSMutableArray *creeps;
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;

- (id)initWithWidth:(int)width andHeight:(int)height;
@end
