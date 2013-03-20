//
//  tdViewGame.m
//  Tower Defense
//
//  Created by Edouard Leurent on 19/03/13.
//  Copyright (c) 2013 Edouard Leurent. All rights reserved.
//

#import "tdViewGame.h"
#import "Tower.h"
#import "Path.h"
#import "Creep.h"

#define ZOOM_MAX 2.5
#define ZOOM_MIN 1.0

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
    for (Path *p in self.map.paths) {
        [self drawPath:p inContext:context];
    }
    for (Creep *c in self.map.creeps) {
        [self drawCreep:c inContext:context];
    }
    for (Tower *t in self.map.towers) {
        [self drawTower:t inContext:context];
    }
}

- (void) drawGrassInContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.6 green:1 blue:0.3 alpha:1] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
}

- (void) drawPath:(Path*)p inContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.65 alpha:1]  CGColor]);
    CGPoint position = [p getCoordinatesinMap:self.map withOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
    float size = [p getSizeWithZoom:self.zoom];
    CGRect rectPath = CGRectMake(position.x - size/2, position.y - size/2, size, size);
    CGContextFillRect(context, rectPath);
}

- (void) drawTower:(Tower*)t inContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [t.color CGColor]);
    CGPoint position = [t getCoordinatesinMap:self.map withOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
    float radius = [t getRadiusWithZoom:self.zoom];
    CGRect rectTower = CGRectMake(position.x - radius/2, position.y - radius/2, radius, radius);
    CGContextFillEllipseInRect(context, rectTower);
}

- (void) drawCreep:(Creep*)c inContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [c.color CGColor]);
    CGPoint position = [c getCoordinatesinMap:self.map withOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
    float size = [c getSizeWithZoom:self.zoom];
    CGRect rectCreep = CGRectMake(position.x - size/2, position.y - size/2, size, size);
    CGContextFillEllipseInRect(context, rectCreep);
}

- (void) allowedMoves {
    if (self.xOffset > 0)
        self.xOffset = 0;
    else if (self.xOffset < self.bounds.size.width - self.map.width*[Cell cellSize]*self.zoom)
        self.xOffset = self.bounds.size.width - self.map.width*[Cell cellSize]*self.zoom;
    if (self.yOffset > 0)
        self.yOffset = 0;
    else if (self.yOffset < self.bounds.size.height - self.map.height*[Cell cellSize]*self.zoom)
        self.yOffset = self.bounds.size.height - self.map.height*[Cell cellSize]*self.zoom;
}

- (void) moveViewByX:(CGFloat)deltaX Y:(CGFloat)deltaY {
    self.xOffset += deltaX;
    self.yOffset += deltaY;
    [self allowedMoves];
}

- (void) zoomBy:(CGFloat)deltaDistance Around:(CGPoint)point {
    CGFloat zoom1 = self.zoom;
    CGFloat zoom2 = zoom1*deltaDistance;
    if (zoom2 < ZOOM_MIN)
        zoom2 = ZOOM_MIN;
    if (zoom2 > ZOOM_MAX)
        zoom2 = ZOOM_MAX;
    self.xOffset = zoom2/zoom1*(self.xOffset-point.x) + point.x;
    self.yOffset = zoom2/zoom1*(self.yOffset-point.y) + point.y;
    self.zoom = zoom2;
    [self allowedMoves];
}
@end