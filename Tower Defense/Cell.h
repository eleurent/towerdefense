//
//  Cell.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject
@property (assign, nonatomic) int x;
@property (assign, nonatomic) int y;

- (BOOL)estDedansX:(int)x Y:(int)y;
@end
