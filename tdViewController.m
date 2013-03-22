//
//  tdViewController.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "tdViewController.h"
#import "tdViewGame.h"
#import <QuartzCore/QuartzCore.h>

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
            
            tdViewGame* viewGame = (tdViewGame*) self.view;
            if ([viewGame menuCellTouchedIn:touchOrigin]) {
                isCreatingTower = YES;
            }
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
    if (isCreatingTower) {
        [view moveCreatedTowerToPosition:[[touches anyObject] locationInView:self.view]];
    }
    else {
        switch([allTouches count]) {
            case 1: {
                [self moveView:view fromTouches:allTouches];
            } break;
            case 2: {
                [self zoomView:view fromTouches:allTouches];
            } break;
        }
    }
    [self.view setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    tdViewGame *view = (tdViewGame*)self.view;
    if (isCreatingTower) {
        [view createTower];
        isCreatingTower = NO;
    }
    else {
        CGPoint touchEnd = [[touches anyObject] locationInView:self.view];
        if ([self distanceBetweenTwoPoints:touchOriginSelection toPoint:touchEnd] < 5) {
            [view sellTowerIn:touchOriginSelection];
            [view selectTowerIn:touchOriginSelection];
        }
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

- (IBAction)pause:(id)sender {
    UIButton *btn = (UIButton *)sender;
    tdViewGame* viewGame = (tdViewGame*) self.view;
    if( [[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"pause.png"]])
    {
        [btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    viewGame.map.isPaused = !viewGame.map.isPaused;
}

- (IBAction)restart:(id)sender {
    tdViewGame* viewGame = (tdViewGame*) self.view;
    viewGame.selectedTower = nil;
    [viewGame.map restart];
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    return sqrt(x * x + y * y);
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    isCreatingTower = false;
    tdViewGame* viewGame = (tdViewGame*) self.view;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:viewGame
                                            selector:@selector(timeStep) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
