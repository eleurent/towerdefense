//
//  Cell.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "Cell.h"

static int taille=10;

@implementation Cell

+ (int)taille {
    return taille;
}

- (BOOL)estDedansX:(int)x Y:(int)y {
    return x >= self.x && x < self.x + taille && y >= self.y && y < self.y + taille;
}
@end



