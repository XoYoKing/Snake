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
    snake.checkedDrunk = self.drunk.state; // can the snake get drunk?
    
    // auto call gamePlay function every 0.09 seconds
    [self performSelectorOnMainThread:@selector(gamePlay) withObject:nil waitUntilDone:YES];
    
}

-(void)gamePlay {
    
    if(self.snake.isDrunk)
        self.drunkLabel.hidden = NO;
    else
        self.drunkLabel.hidden = YES;
    
    [self.puntuation setStringValue:[NSString stringWithFormat:@"%d", self.snake.puntuation]];
    [self.snake updateScreenSize];  // update screen size
    [self.snake moveSnake];         // move snake
    [self setNeedsDisplay:YES];     // refresh view
}

// init function
- (void)awakeFromNib {
    NSLog(@"startGame");
    
    self.puntuation.hidden = YES;
    self.drunkLabel.hidden = YES;
    
    [self.recordP setStringValue:[NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"record"]]];
    
    [self setWantsLayer:YES];
    self.layer.backgroundColor = [[NSColor colorWithRed:0.698 green:0.859 blue:0.749 alpha:1] CGColor]; /*#247ba0*/
    
}

- (IBAction)startGameButton:(id)pId {
    
    self.title.hidden = YES;
    self.buttonStart.hidden = YES;
    self.difficulty.hidden = YES;
    self.slider.hidden = YES;
    self.recordLabel.hidden = YES;
    self.puntuation.hidden = NO;
    self.recordP.hidden = YES;
    self.drunk.hidden = YES;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:((97-[self.slider intValue])%97)*0.01 target:self selector:@selector(gamePlay) userInfo:nil repeats:YES];
    
    [self initGame];
    
}

-(void)gameOver {
    //NSLog(@"gameOver");
    if(timer) {
        [timer invalidate];     // set timer to 0
        timer = nil;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int prev = (int)[prefs integerForKey:@"record"];
    
    if(prev < self.snake.puntuation) {
        [prefs setInteger:self.snake.puntuation forKey:@"record"];
        [self.recordP setStringValue:[NSString stringWithFormat:@"%d", self.snake.puntuation]];
    }
    
    if(![prefs objectForKey:@"record"])
        [prefs setInteger:0 forKey:@"record"];
    
    [prefs synchronize];
    
    self.snake.food.foodRect = CGRectMake(0, 0, 0, 0);
    [self.snake.body removeAllObjects];
    
    self.title.hidden = NO;
    self.buttonStart.hidden = NO;
    self.difficulty.hidden = NO;
    self.slider.hidden = NO;
    self.recordLabel.hidden = NO;
    self.recordP.hidden = NO;
    self.drunk.hidden = NO;
    
}

-(void)restartGame {
    NSLog(@"restartGame");
    [self gameOver];
    //[self initGame];
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

    - MOVE SNAKE  -> Arrows
    - RESTART     -> N
    -
*/
- (void)keyDown: (NSEvent *) event
{
    NSString *const character = [event charactersIgnoringModifiers];
    unichar const code = [character characterAtIndex:0];
    
    switch (code)
    {
        case NSUpArrowFunctionKey:
        {
            [self.snake didMoveToDirection:goUp];
            break;
        }
        case NSDownArrowFunctionKey:
        {
            [self.snake didMoveToDirection:goDown];
            break;
        }
        case NSLeftArrowFunctionKey:
        {
            [self.snake didMoveToDirection:goLeft];
            break;
        }
        case NSRightArrowFunctionKey:
        {
            [self.snake didMoveToDirection:goRight];
            break;
        }
    }
    if ([character isEqualToString:@"n"]) {
        [self restartGame];
    }

}

#pragma mark SnakeStateProtocol delegate
- (void)snakeDidDie{ [self gameOver]; }


@end