//
//  Snake.m
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import "Snake.h"

static int const MAX_SIZE = 50;

@implementation Snake {
    NSWindow *mainWindow;
    int screenH, screenW;
}

-(id) initSnake {
    
    self = [super init];
    if(self) {
        self.direction = goDown;
        self.moveOrDie = YES;
        self.hasEaten = NO;
        self.head = CGPointMake(10, 50);
        self.bodyLength = 5;
        
        self.body = [NSMutableArray arrayWithCapacity:MAX_SIZE];
        
        for(int i = 0; i < self.bodyLength; i++) {
            SnakeBody b = CGRectMake(_head.x, _head.y-i*10, 10, 10);
            [self.body addObject:[NSValue valueWithRect:b]];
        }
        mainWindow = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
    }
    return self;
}

-(void) initFood {
    int x = arc4random_uniform(screenW/10);
    int y = arc4random_uniform(screenH/10);
    
    self.food = [[Food alloc] initWithX:10*x andY:10*y];
}

-(void)updateScreenSize {
    screenH = mainWindow.frame.size.height-5;
    screenW = mainWindow.frame.size.width-5;
}

-(void) moveSnake {
    
    SnakeBody hb = [[self.body objectAtIndex:0] rectValue];
    CGPoint hp = hb.origin;
    CGPoint p;
    
    if(!self.hasEaten)
        [self.body removeLastObject];
    else
        self.hasEaten = NO;
    
    //add a new snake head
    switch (self.direction) {
        case goUp:
            p = CGPointMake(hp.x , hp.y - 10);
            break;
        case goDown:
            p = CGPointMake(hp.x , hp.y + 10);
            break;
        case goLeft:
            p = CGPointMake(hp.x - 10, hp.y);
            break;
        case goRight:
            p = CGPointMake(hp.x + 10, hp.y);
            break;
        default:
            break;
    }
    
    SnakeBody b = CGRectMake(p.x, p.y, 10, 10);
    [self.body insertObject:[NSValue valueWithRect:b] atIndex:0];
    
    [self detectState];
    
}

-(void) detectState {
    
    SnakeBody hb = [[self.body objectAtIndex:0] rectValue];
    // handle touch itself, touch wall, eat food
    
    if(CGRectEqualToRect(hb, self.food.foodRect)) {
        self.hasEaten = YES;
        [self initFood];
    }
    
    if(hb.origin.x < 0 || hb.origin.x > screenW || hb.origin.y < 0 || hb.origin.y > screenH)
      [self.delegate snakeDidDie];
    
}

- (void)didMoveToDirection:(SnakeDirection)sdirection
{
    //change the move direction
    switch (sdirection) {
        case goUp:
            if (self.direction != goDown)       //when snake go down,ignore the key "W"
                self.direction = goUp;
            break;
        case goDown:
            if (self.direction != goUp)
                self.direction = goDown;
            break;
        case goLeft:
            if (self.direction != goRight)
                self.direction = goLeft;
            break;
        case goRight:
            if (self.direction != goLeft)
                self.direction = goRight;
            break;
        default:
            break;
    }
}



@end