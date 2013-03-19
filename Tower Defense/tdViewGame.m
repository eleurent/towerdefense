//
//  tdViewGame.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "tdViewGame.h"
#import "Tower.h"

@implementation tdViewGame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.zoom = 1.0;
    self.map = [[Map alloc] initWithWidth:40 andHeight:30];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawGrassInContext:context];
    
    for (Tower *t in self.map.towers) {
        [self drawTower:t inContext:context];
    }
}

- (void) drawGrassInContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
}

- (void) drawTower:(Tower*) t inContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGPoint position = [t getCoordinatesinMap:self.map withOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
    float radius = [t getRadiusWithZoom:self.zoom];
    CGRect rectTower = CGRectMake(position.x - radius/2, position.y - radius/2, radius, radius);
    CGContextFillEllipseInRect(context, rectTower);
}

- (void) moveViewByX:(CGFloat)deltaX Y:(CGFloat)deltaY {
    self.xOffset += deltaX;
    self.yOffset += deltaY;
}
@end