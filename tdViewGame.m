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
    self.map = [[Map alloc] initWithWidth:25 andHeight:18];
    self.menuTowers = [[NSMutableArray alloc] initWithObjects:[[Tower alloc] initStandardWithPositionX:0 Y:0],
                                                              [[Tower alloc] initHeavyWithPositionX:0 Y:0],
                                                              nil];

}

- (BOOL) menuCellTouchedIn:(CGPoint)point {
    float radius = self.bounds.size.width / 30;
    float y = self.bounds.size.height -self.bounds.size.height/12;
    for (int i=0; i< [self.menuTowers count]; i++) {
        Tower *t = [self.menuTowers objectAtIndex:i];
        CGRect rectTower = CGRectMake((i+1)*2.5*radius-radius, y-radius , 2*radius, 2*radius);
        if ((self.map.money >= t.price) && CGRectContainsPoint(rectTower, point)) {
            CGPoint position = [self positionFromCoordinates:point];
            self.createdTower = [[Tower alloc] initFromTower:t withPositionX:position.x Y:position.y];
            self.selectedTower = self.createdTower;
            return YES;
        }
    }
    return NO;
}

- (void) drawMoneyInContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSelectFont(context, "Helvetica", 20.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 1.2);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    char money[8];
    sprintf(money, "%d$", self.map.money);
    CGContextShowTextAtPoint(context, self.bounds.size.width-5-12*strlen(money), self.bounds.size.height-20, money, strlen(money));
    CGContextRestoreGState(context);

}

- (void) drawMenuInContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.9 green:0.9 blue:0.5 alpha:1] CGColor]);
    CGContextFillRect(context, CGRectMake(0, self.bounds.size.height-self.bounds.size.height/6, self.bounds.size.width, self.bounds.size.height/6));
    float radius = self.bounds.size.width / 30;
    float y = self.bounds.size.height -self.bounds.size.height/12;
    for (int i=0; i< [self.menuTowers count]; i++) {
        Tower *t = [self.menuTowers objectAtIndex:i];
        if (self.map.money < t.price)
            CGContextSetFillColorWithColor(context, [[t.color colorWithAlphaComponent:0.5] CGColor]);
        else
            CGContextSetFillColorWithColor(context, [t.color CGColor]);
        CGRect rectTower = CGRectMake((i+1)*2.5*radius-radius, y-radius , 2*radius, 2*radius);
        CGContextFillEllipseInRect(context, rectTower);
    }

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
    if (self.selectedTower)
        [self drawTower:self.selectedTower inContext:context];
    for (Bullet *b in self.map.bullets) {
        [self drawBullet:b inContext:context];
    }
    [self drawMoneyInContext:context];
    [self drawMenuInContext:context];
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
    if (self.selectedTower == t) {
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
    CGPoint position = [self positionFromCoordinates:point];
    self.selectedTower = nil;
    for (Tower* t in self.map.towers) {
        if (t.x == position.x && t.y == position.y) {
            self.selectedTower = t;
            break;
        }
    }
}

- (void) moveCreatedTowerToPosition:(CGPoint)point {
    CGPoint position = [self positionFromCoordinates:point];
    self.createdTower.x = position.x;
    self.createdTower.y = position.y;
}

- (void) createTower {
    if ([self.map isEmpty:self.createdTower]) {
        [self.map.towers addObject:self.createdTower];
        self.map.money -= self.createdTower.price;
    }
    else
        self.selectedTower = nil;
    self.createdTower = nil;
}

- (CGPoint) positionFromCoordinates:(CGPoint)point {
    return CGPointMake((int)((point.x-self.xOffset)/(self.zoom*[Cell cellSize])), (int)((point.y-self.yOffset)/(self.zoom*[Cell cellSize])));
}

-(void) timeStep {
    [self.map timeStep];
    [self setNeedsDisplay];
}
@end