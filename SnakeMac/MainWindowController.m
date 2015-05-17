//
//  MainWindowController.m
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import "MainWindowController.h"

@implementation MainWindowController

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initGame];
    }
    return self;
}

-(void)initGame {
    Snake *snake = [[Snake alloc] initSnake];
    snake.delegate = self;
    self.snake = snake;
    
    [snake initFood];
    
    [self performSelectorOnMainThread:@selector(gamePlay) withObject:nil waitUntilDone:YES];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(gamePlay) userInfo:nil repeats:YES];
}

-(void)gamePlay {
    [self.snake moveSnake];
    [self setNeedsDisplay:YES];
}

-(void)gameOver {
    if(timer) {
        [timer invalidate];
        timer = nil;
    }
}


- (void)drawRect:(NSRect)dirtyRect
{
    // set body color of the snake to darkGrayColor
    [[NSColor darkGrayColor] set];
    
    //get every body of the snake, and draw using NSRectFill
    for (int i = 0; i < [self.snake.body count]; i++) {
        SnakeBody body = [[self.snake.body objectAtIndex:i] rectValue];
        NSRectFill(body);
    }
    
    [[NSColor blackColor] set];
    NSRectFill(self.snake.food.foodRect);
    
}

- (BOOL)isFlipped {return YES;} // let coordinates start on the upper-left
- (BOOL)acceptsFirstResponder {return YES;} // allow view to accept key input events

- (void)keyDown: (NSEvent *) event
{
    // the key ADWS for change the direction of the snake
    NSString *chars = [event characters];
    
    if ([chars isEqualToString:@"s"]) {
        [self.snake didMoveToDirection:goDown];
    }
    if ([chars isEqualToString:@"w"]) {
        [self.snake didMoveToDirection:goUp];
    }
    if ([chars isEqualToString:@"a"]) {
        [self.snake didMoveToDirection:goLeft];
    }
    if ([chars isEqualToString:@"d"]) {
        [self.snake didMoveToDirection:goRight];
    }
}

#pragma mark SnakeStateProtocol delegate
- (void)snakeDidDie{ [self gameOver]; }


@end