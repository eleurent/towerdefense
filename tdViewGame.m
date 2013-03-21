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
#import "Bullet.h"

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

- (void)drawMenu

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
    for (Bullet *b in self.map.bullets) {
        [self drawBullet:b inContext:context];
    }
}

- (void) drawGrassInContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.6 green:1 blue:0.3 alpha:1] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
}

- (void) drawPath:(Path*)p inContext:(CGContextRef)context {
    if ([p isVisibleInView:self]) {
        CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.65 alpha:1]  CGColor]);
        CGPoint position = [p getCoordinatesWithOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
        float size = [p getSizeWithZoom:self.zoom];
        CGRect rectPath = CGRectMake(position.x - size/2, position.y - size/2, size, size);
        CGContextFillRect(context, rectPath);
    }
}

- (void) drawTower:(Tower*)t inContext:(CGContextRef)context {
    CGPoint position = [t getCoordinatesWithOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
    
    //FOV
    if (self.selected == t) {
        CGContextSetFillColorWithColor(context, [[t.color colorWithAlphaComponent:0.2] CGColor]);
        float fov = [t getFOVWithZoom:self.zoom];
        CGRect rectTower = CGRectMake(position.x - fov, position.y - fov, 2*fov, 2*fov);
        CGContextFillEllipseInRect(context, rectTower);
    }
    //Tower
    if ([t isVisibleInView:self]) {
        CGContextSetFillColorWithColor(context, [t.color CGColor]);
        float radius = [t getRadiusWithZoom:self.zoom];
        CGRect rectTower = CGRectMake(position.x - radius, position.y - radius, 2*radius, 2*radius);
        CGContextFillEllipseInRect(context, rectTower);
    }
}

- (void) drawCreep:(Creep*)c inContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [c.color CGColor]);
    CGPoint position = [c getCoordinatesWithOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
    float size = [c getSizeWithZoom:self.zoom];
    CGRect rectCreep = CGRectMake(position.x - size/2, position.y - size/2, size, size);
    CGContextFillEllipseInRect(context, rectCreep);
}

- (void) drawBullet:(Bullet*)b inContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [b.color CGColor]);
    CGPoint position = [b getCoordinatesWithOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
    float angle = atan2f([b direction].y, [b direction].x);
    float length = [b getLengthWithZoom:self.zoom];
    float width = [b getWidthWithZoom:self.zoom];
    
    //Transfo
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, position.x, position.y);
    CGContextRotateCTM(context, angle);
    CGRect rectCreep = CGRectMake(-length/2, -width/2, length, width);
    CGContextFillRect(context, rectCreep);
    CGContextRestoreGState(context);
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

- (void) selectTowerIn:(CGPoint)point {
    int x = (int)(point.x/(self.zoom*[Cell cellSize]));
    int y = (int)(point.y/(self.zoom*[Cell cellSize]));
    self.selected = nil;
    for (Tower* t in self.map.towers) {
        if (t.x == x && t.y == y) {
            self.selected = t;
            break;
        }
    }
}

-(void) timeStep {
    [self.map timeStep];
    [self setNeedsDisplay];
}
@end