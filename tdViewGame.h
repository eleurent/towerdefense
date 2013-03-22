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
@property (strong, nonatomic) Tower* selectedTower;
@property (strong, nonatomic) Tower* createdTower;
@property (strong, nonatomic) NSMutableArray* menuTowers;

- (BOOL) menuCellTouchedIn:(CGPoint)point;
- (void) moveViewByX:(CGFloat)deltaX Y:(CGFloat)deltaY;
- (void) zoomBy:(CGFloat)deltaDistance Around:(CGPoint)point;
- (void) selectTowerIn:(CGPoint)point;
- (void) moveCreatedTowerToPosition:(CGPoint)point;
- (void) sellTowerIn:(CGPoint)point;
- (void) createTower;

@end

