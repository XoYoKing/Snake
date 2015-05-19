//
//  Snake.m
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import "Snake.h"

static int const MAX_SIZE = 80;     // max size of the body
static int const RANDOM_DRUNK = 70; // how often is the snake drunk?
static int const INITIAL_BODY_LENGTH = 5;   // initial size of the body
static int const BODY_SIZE = 10;    // size of the rectangle of each body part

@implementation Snake {
    NSWindow *mainWindow;
    int screenH, screenW;
}

-(id) initSnake {
    
    self = [super init];
    if(self) {
        self.direction = goDown;
        self.hasEaten = NO;
        self.bodyLength = INITIAL_BODY_LENGTH;
        self.puntuation = 0;
        self.isDrunk = NO;
        self.haveWalls = NO;
        randomItera = -1;
        randomN = arc4random_uniform(RANDOM_DRUNK);
        
        self.body = [NSMutableArray arrayWithCapacity:MAX_SIZE];
        
        for(int i = 0; i < self.bodyLength; i++) {
            SnakeBody b = CGRectMake(10, 50-i*10, BODY_SIZE, BODY_SIZE);
            [self.body addObject:[NSValue valueWithRect:b]];
        }
        mainWindow = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
    }
    return self;
}

-(void) initFood {
    int x = arc4random_uniform((screenW-BODY_SIZE)/10)*10;
    int y = arc4random_uniform((screenH-BODY_SIZE)/10)*10;
    
    if(x == 0)
        x = 10;
    if(y == 0)
        y = 10;
    if(x > 340 && y < 40) {
        x = 50;
        y = 50;
    }
    
    self.food = [[Food alloc] initWithX:x andY:y];
}

// if user resizes window
-(void)updateScreenSize {
    screenH = mainWindow.frame.size.height-22;  // 22 is the size of the menu bar
    screenW = mainWindow.frame.size.width;
}

-(void) moveSnake {
    
    SnakeBody hb = [[self.body objectAtIndex:0] rectValue];
    CGPoint hp = hb.origin;
    CGPoint p;
    int newY, newX;
    
    if(!self.hasEaten || [self.body count] > MAX_SIZE)
        [self.body removeLastObject];
    else
        self.hasEaten = NO;
    
    // add a new snake head
    // height = 380px
    switch (self.direction) {
        case goUp:
            if(hp.y <= 0 && !self.haveWalls)
                newY = screenH - BODY_SIZE;
            else
                newY = hp.y - BODY_SIZE;
            
            p = CGPointMake(hp.x , newY);
            break;
        case goDown:
            if(hp.y >= screenH-BODY_SIZE && !self.haveWalls)
                newY = 0;
            else
                newY = hp.y + BODY_SIZE;

            p = CGPointMake(hp.x , newY);
            break;
        case goLeft:
            if(hp.x <= 0 && !self.haveWalls)
                newX = screenW - BODY_SIZE;
            else
                newX = hp.x - BODY_SIZE;
            
            p = CGPointMake(newX , hp.y);
            break;
        case goRight:
            if(hp.x >= screenW-BODY_SIZE && !self.haveWalls)
                newX = 0;
            else
                newX = hp.x + BODY_SIZE;
            
            p = CGPointMake(newX , hp.y);
            break;
        default:
            break;
    }
    
    SnakeBody b = CGRectMake(p.x, p.y, BODY_SIZE, BODY_SIZE);
    [self.body insertObject:[NSValue valueWithRect:b] atIndex:0];
    
    [self detectState];
    
    if(randomItera == randomN && self.checkedDrunk)
        self.isDrunk = YES;
    
}

-(void) detectState {
    
    SnakeBody hb = [[self.body objectAtIndex:0] rectValue];
    // handle touch itself, touch wall, eat food
    
    // check if head touch body
    for(int i = 1; i < [self.body count]; i++) {
        SnakeBody b = [[self.body objectAtIndex:i] rectValue];
        if(CGRectEqualToRect(hb, b)) {
            [self.delegate snakeDidDie];
        }
    }
    
    // check if snake is eating
    if(CGRectEqualToRect(hb, self.food.foodRect)) {
        self.hasEaten = YES;
        self.puntuation++;
        [self initFood];
    }
    
    // check if head if out of screen bounds only if haveWalls checked
    if(self.haveWalls)
        if(hb.origin.x < BODY_SIZE || hb.origin.x > screenW-2*BODY_SIZE || hb.origin.y < BODY_SIZE || hb.origin.y > screenH-2*BODY_SIZE)
            [self.delegate snakeDidDie];
    
}

- (void)didMoveToDirection:(SnakeDirection)sdirection
{
    // snake will be drunk only if drinks 15 beers of more
    if(self.puntuation > 15 && self.checkedDrunk) {
        randomItera++;
    }
    
    if(self.isDrunk) {
        randomN = arc4random_uniform(RANDOM_DRUNK);
        randomItera = -1;
        
        if(self.direction == goDown || self.direction == goUp) {
            if(sdirection == goLeft)
                sdirection = goRight;
            else
                sdirection = goLeft;
        }
        else if(self.direction == goLeft || self.direction == goRight) {
            if(sdirection == goUp)
                sdirection = goDown;
            else
                sdirection = goUp;
        }
        
    }

    //change the move direction
    switch (sdirection) {
        case goUp:
            if (self.direction != goDown){       //when snake go down,ignore the key "W"
                self.direction = goUp;
                self.isDrunk = NO;
            }
            break;
        case goDown:
            if (self.direction != goUp) {
                self.direction = goDown;
                self.isDrunk = NO;
            }
            break;
        case goLeft:
            if (self.direction != goRight) {
                self.direction = goLeft;
                self.isDrunk = NO;
            }
            break;
        case goRight:
            if (self.direction != goLeft) {
                self.direction = goRight;
                self.isDrunk = NO;
            }
            break;
        default:
            break;
    }
}



@end