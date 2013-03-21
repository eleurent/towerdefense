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

@implementation tdViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    switch([allTouches count]) {
        case 1: {
            // one finger
            touchOrigin = [[touches anyObject] locationInView:self.view];
            touchOriginSelection = [[touches anyObject] locationInView:self.view];
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
            [self moveView:view fromTouches:allTouches];
        } break;
        case 2: {
            [self zoomView:view fromTouches:allTouches];
        } break;
    }
    [self.view setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchEnd = [[touches anyObject] locationInView:self.view];
    if ([self distanceBetweenTwoPoints:touchOriginSelection toPoint:touchEnd] < 5) {
        tdViewGame *view = (tdViewGame*)self.view;
        [view selectTowerIn:touchOriginSelection];
    }
}

- (void) moveView:(tdViewGame*)view fromTouches:(NSSet*)allTouches {
    CGPoint touchPoint = [[allTouches anyObject] locationInView:self.view];
    [view moveViewByX:touchPoint.x - touchOrigin.x Y:touchPoint.y - touchOrigin.y];
    touchOrigin = touchPoint;
}

- (void) zoomView:(tdViewGame*)view fromTouches:(NSSet*)allTouches {
    UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
    UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
    CGPoint t1 = [touch1 locationInView:[self view]];
    CGPoint t2 = [touch2 locationInView:[self view]];
    CGFloat distance = [self distanceBetweenTwoPoints:t1
                                              toPoint:t2];
    CGPoint centre = CGPointMake((t1.x+t2.x)/2, (t1.y+t2.y)/2);
    [view zoomBy:distance/distanceOrigin Around:centre];
    distanceOrigin = distance;
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
    tdViewGame* viewGame = (tdViewGame*) self.view;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:viewGame
                                            selector:@selector(timeStep) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
