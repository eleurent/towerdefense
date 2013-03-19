//
//  tdViewController.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "tdViewController.h"
#import "tdViewGame.h"

@interface tdViewController ()

@end

static CGPoint touchOrigin;
static CGFloat distanceOrigin;

@implementation tdViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    switch([allTouches count]) {
        case 1: {
            // one finger
            touchOrigin = [[touches anyObject] locationInView:self.view];
        }
        break;
        case 2: {
            UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
            UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
            distanceOrigin = [self distanceBetweenTwoPoints:[touch1 locationInView:[self view]]
                                                    toPoint:[touch2 locationInView:[self view]]];
        }
        break;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    tdViewGame *view = (tdViewGame*)self.view;
    switch([allTouches count]) {
        case 1: {
            CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
            [view moveViewByX:touchPoint.x - touchOrigin.x Y:touchPoint.y - touchOrigin.y];
            touchOrigin = [[touches anyObject] locationInView:self.view];
        } break;
        case 2: {
            
        } break;
    }
    [self.view setNeedsDisplay];
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    return sqrt(x * x + y * y);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
