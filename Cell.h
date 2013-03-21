//
//  Cell.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Map.h"

@class tdViewGame;

@interface Cell : NSObject
@property (assign, nonatomic) int x;
@property (assign, nonatomic) int y;

- (id) initWithPositionX:(int)x Y:(int)y;
+ (int)cellSize;
- (BOOL) isInX:(int)x Y:(int)y;
- (BOOL) isVisibleInView:(tdViewGame*)view;
- (CGPoint) getCoordinatesWithOffsetX:(int)x Y:(int)y andZoom:(float)zoom;
- (float) getSizeWithZoom:(float)zoom;
@end
