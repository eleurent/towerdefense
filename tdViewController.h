//
//  tdViewController.h
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tdViewController : UIViewController {
    CGPoint touchOrigin;
    CGPoint touchOriginSelection;
    CGFloat distanceOrigin;
    BOOL isCreatingTower;
}
@property (strong, nonatomic) NSTimer* timer;
- (IBAction)pause:(id)sender;
- (IBAction)restart:(id)sender;
- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
@end
