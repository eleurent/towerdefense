//
//  Map.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Map.h"

@implementation Map

- (id)initWithWidth:(int)width andHeight:(int)height{
    if (self = [super init]) {
        self.width = width;
        self.heigth = height;
        self.cells = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
