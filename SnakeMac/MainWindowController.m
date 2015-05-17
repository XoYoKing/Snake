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
        NSLog(@"startGame");
        [self initGame];
    }
    return self;
}

-(void)initGame {
    Snake *snake = [[Snake alloc] initSnake];
    snake.delegate = self;
    self.snake = snake;
    
    [snake updateScreenSize];   // update screen size
    [snake initFood];           // set first food
    
    // auto call gamePlay function every 0.09 seconds
    [self performSelectorOnMainThread:@selector(gamePlay) withObject:nil waitUntilDone:YES];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.09 target:self selector:@selector(gamePlay) userInfo:nil repeats:YES];
}

-(void)gamePlay {
    [self.snake updateScreenSize];  // update screen size
    [self.snake moveSnake];         // move snake
    [self setNeedsDisplay:YES];     // refresh view
}

// init function
- (void)awakeFromNib {
    NSLog(@"startGame");
    [self initGame];
}

-(void)gameOver {
    //NSLog(@"gameOver");
    if(timer) {
        [timer invalidate];     // set timer to 0
        timer = nil;
    }
}

-(void)restartGame {
    NSLog(@"restartGame");
    [self gameOver];
    [self initGame];
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
    
    // set the image of the food
    NSImage *image = [NSImage imageNamed: @"beer.png"];
    if(image)
        [image drawInRect:self.snake.food.foodRect];
}

- (BOOL)isFlipped {return YES;} // let coordinates start on the upper-left
- (BOOL)acceptsFirstResponder {return YES;} // allow view to accept key input events

/*
    ** GAME CONTOL **

    - MOVE SNAKE  -> AWSD
    - RESTART     -> N
    -
*/
- (void)keyDown: (NSEvent *) event
{
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
    if ([chars isEqualToString:@"n"]) {
        [self restartGame];
    }
}

#pragma mark SnakeStateProtocol delegate
- (void)snakeDidDie{ [self gameOver]; }


@end