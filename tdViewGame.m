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
    self.map = [[Map alloc] initWithWidth:24 andHeight:18];
    self.menuTowers = [[NSMutableArray alloc] initWithObjects:[[Tower alloc] initStandardWithPositionX:0 Y:0],
                                                              [[Tower alloc] initFreezeWithPositionX:0 Y:0],
                                                              [[Tower alloc] initHeavyWithPositionX:0 Y:0],
                                                              [[Tower alloc] initPoisonWithPositionX:0 Y:0],
                                                              [[Tower alloc] initFastWithPositionX:0 Y:0],
                                                              [[Tower alloc] initLaserWithPositionX:0 Y:0],
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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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
    [self drawMoneyAndLivesInContext:context];
    [self drawWavesInContext:context];
    [self drawMenuInContext:context];
    [self drawSellInContext:context];
    if (([self.map.waves count] == 0) && ([self.map.creeps count] == 0)) {
        [self drawVictoryInContext:context];
    }
    if (self.map.lives <= 0) {
        [self drawGameOverInContext:context];
    }
}

- (void) drawMoneyAndLivesInContext:(CGContextRef)context {
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
    CGContextShowTextAtPoint(context, self.bounds.size.width-8-12*strlen(money), self.bounds.size.height-60, money, strlen(money));
    char lives[8];
    sprintf(lives, "%d", self.map.lives);
    CGContextShowTextAtPoint(context, self.bounds.size.width-24-12*strlen(lives), self.bounds.size.height-89, lives, strlen(lives));
    UIImage *heart = [UIImage imageNamed:@"heart.png"];
    CGRect heartRect = CGRectMake(self.bounds.size.width-23, self.bounds.size.height-90, 16, 16);
    CGContextDrawImage(context, heartRect, [heart CGImage]);
    CGContextRestoreGState(context);
}

- (void) drawWavesInContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSelectFont(context, "Helvetica", 20.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 1.2);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    char waves[8];
    sprintf(waves, "%d", [self.map.waves count]);
    CGContextShowTextAtPoint(context, 30, self.bounds.size.height-30, waves, strlen(waves));
    UIImage *creep = [UIImage imageNamed:@"creep.png"];
    CGRect creepRect = CGRectMake(30+12*strlen(waves), self.bounds.size.height-34, 20, 20);
    CGContextDrawImage(context, creepRect, [creep CGImage]);
    CGContextRestoreGState(context);
}

- (void) drawSellInContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSelectFont(context, "Helvetica", 45.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 1.2);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    CGContextShowTextAtPoint(context, self.bounds.size.width-35, 10, "$", strlen("$"));
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
            CGContextSetFillColorWithColor(context, [[t.color colorWithAlphaComponent:0.3] CGColor]);
        else
            CGContextSetFillColorWithColor(context, [t.color CGColor]);
        CGRect rectTower = CGRectMake((i+1)*2.5*radius-radius, y-radius , 2*radius, 2*radius);
        CGContextFillEllipseInRect(context, rectTower);
    }
}

- (void)drawGameOverInContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSelectFont(context, "Helvetica", 45.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 1.2);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextShowTextAtPoint(context, self.bounds.size.width/2-12*strlen("Game Over"), self.bounds.size.height/2-10, "Game Over", strlen("Game Over"));
    CGContextRestoreGState(context);
}

- (void)drawVictoryInContext:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSelectFont(context, "Helvetica", 45.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 1.2);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextShowTextAtPoint(context, self.bounds.size.width/2-11*strlen("Victory !"), self.bounds.size.height/2-10, "Victory !", strlen("Victory !"));
    CGContextRestoreGState(context);
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
        CGRect rectFOV = CGRectMake(position.x - fov, position.y - fov, 2*fov, 2*fov);
        CGContextFillEllipseInRect(context, rectFOV);
    }
    //Tower
    if ([t isVisibleInView:self]) {
        //Normal
        float radius = [t getRadiusWithZoom:self.zoom];
        CGRect rectTower = CGRectMake(position.x - radius, position.y - radius, 2*radius, 2*radius);
        CGContextSetFillColorWithColor(context, [t.color CGColor]);
        CGContextFillEllipseInRect(context, rectTower);
    }
}

- (void) drawCreep:(Creep*)c inContext:(CGContextRef)context {
    //Creep
    CGContextSetFillColorWithColor(context, [c.color CGColor]);
    CGPoint position = [c getCoordinatesWithOffsetX:self.xOffset Y:self.yOffset andZoom:self.zoom];
    float size = [c getSizeWithZoom:self.zoom];
    CGRect rectCreep = CGRectMake(position.x - size/2, position.y - size/2, size, size);
    CGContextFillEllipseInRect(context, rectCreep);
    
    //Freeze
    if (c.isFrozen) {
        CGContextSetFillColorWithColor(context, [[[UIColor cyanColor] colorWithAlphaComponent:0.6] CGColor]);
        CGContextFillEllipseInRect(context, rectCreep);
    }

    //Poison
    if (c.isPoisonned) {
        CGContextSetFillColorWithColor(context, [[[UIColor purpleColor] colorWithAlphaComponent:0.6] CGColor]);
        CGContextFillEllipseInRect(context, rectCreep);
    }


    
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

- (void) sellTowerIn:(CGPoint)point {
    if (self.selectedTower) {
        float radius = self.bounds.size.width / 30;
        float y = self.bounds.size.height -self.bounds.size.height/12;
        CGRect rectSell = CGRectMake(self.bounds.size.width-2*radius, y-radius , 2*radius, 2*radius);
        if (CGRectContainsPoint(rectSell, point)) {
            self.map.money += 0.7*self.selectedTower.price;
            [self.map.towers removeObject:self.selectedTower];
            self.selectedTower = nil;
        }
    }
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