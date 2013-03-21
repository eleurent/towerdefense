//
//  tdViewGame.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Map.h"
#import "Tower.h"

@interface tdViewGame : UIView
@property (nonatomic, strong) Map *map;
@property (nonatomic, assign) float zoom;
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign) CGFloat xOffset;
@property (strong, nonatomic) Tower* selected;

- (void) moveViewByX:(CGFloat)deltaX Y:(CGFloat)deltaY;
- (void) zoomBy:(CGFloat)deltaDistance Around:(CGPoint)point;
- (void) selectTowerIn:(CGPoint)point;

@end

