//
//  MainWindowController.m
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import "MainWindowController.h"

static int const BODY_SIZE = 10;    // size of each snake part

@implementation MainWindowController {
    NSWindow *mainWindow;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"startGame");
        mainWindow = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
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
    snake.haveWalls = self.walls.state; // does the snake die when crash a wall?
    moveDone = NO;  // check if snake has moved
    
    [self performSelectorOnMainThread:@selector(gamePlay) withObject:nil waitUntilDone:YES];
    
}

-(void)gamePlay {
    
    if(self.snake.isDrunk)
        self.drunkLabel.hidden = NO;
    else
        self.drunkLabel.hidden = YES;
    
    [self.puntuation setStringValue:[NSString stringWithFormat:@"%d", self.snake.puntuation]];

    // I changed my mind -> I won't allow the user to resize the screen
    //[self.snake updateScreenSize];  // update screen size
    
    [self.snake moveSnake];         // move snake
    moveDone = YES;
    [self setNeedsDisplay:YES];     // refresh view
}

// init function
- (void)awakeFromNib {
    NSLog(@"startGame");
    
    //self.puntuation.hidden = YES;
    self.drunkLabel.hidden = YES;
    self.gameOverLabel.hidden = YES;
    
    [self.recordP setStringValue:[NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"record"]]];
    
    [self setWantsLayer:YES];
    self.layer.backgroundColor = [[NSColor colorWithRed:0.698 green:0.859 blue:0.749 alpha:1] CGColor]; /*#247ba0*/
    self.header.layer.backgroundColor = [[NSColor colorWithRed:0.463f green:0.482f blue:0.569f alpha:1.00f] CGColor];
    
}

- (IBAction)startGameButton:(id)sender {
    
    self.title.hidden = YES;
    self.buttonStart.hidden = YES;
    self.difficulty.hidden = YES;
    self.slider.hidden = YES;
    self.drunk.hidden = YES;
    self.gameOverLabel.hidden = YES;
    self.walls.hidden = YES;
    
    // slider minum = 40, maximum = 100
    // I know it's a difficult calculation, but it's make to vary between 0.96s and 0.01s
    timer = [NSTimer scheduledTimerWithTimeInterval:((97-[self.slider intValue])%97)*0.01 target:self selector:@selector(gamePlay) userInfo:nil repeats:YES];
    
    [self initGame];
    
}

-(IBAction)info:(id)sender {
    
}

-(void)gameOver: (NSTimer *) t{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int prev = (int)[prefs integerForKey:@"record"];
    
    if(prev < self.snake.puntuation) {
        [prefs setInteger:self.snake.puntuation forKey:@"record"];
        [self.recordP setStringValue:[NSString stringWithFormat:@"%d", self.snake.puntuation]];
    }
    
    if(![prefs objectForKey:@"record"])
        [prefs setInteger:0 forKey:@"record"];
    
    [prefs synchronize];
    
    self.title.hidden = NO;
    self.buttonStart.hidden = NO;
    self.difficulty.hidden = NO;
    self.slider.hidden = NO;
    self.drunk.hidden = NO;
    self.walls.hidden = NO;
    self.gameOverLabel.hidden = YES;
    
}

-(void) showGameOver {
    self.gameOverLabel.hidden = NO;
    
    if(timer) {
        [timer invalidate];     // set timer to 0
        timer = nil;
    }
    
    self.snake.food.foodRect = CGRectMake(0, 0, 0, 0);  // remove food from screen
    [self.snake.body removeAllObjects]; // remove snake from screen
    
    // show game over title for 5s
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(gameOver:) userInfo:nil repeats:NO];
    
}

-(void)restartGame {
    NSLog(@"restartGame");
    [self showGameOver];
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
    
    // draw the wall
    NSImage *imageWall = [NSImage imageNamed: @"bricks.png"];
    CGRect rect;
    //630, 380
    
    if(imageWall){
        if(self.walls.state) {
            for(int i = 0; i < 630; i = i+BODY_SIZE) {
                rect = CGRectMake(i, 30, BODY_SIZE, BODY_SIZE);
                [imageWall drawInRect:rect];
                rect = CGRectMake(i, 370, BODY_SIZE, BODY_SIZE);
                [imageWall drawInRect:rect];
            }
            for(int i = 0; i < 370; i = i+BODY_SIZE) {
                rect = CGRectMake(620, i, BODY_SIZE, BODY_SIZE);
                [imageWall drawInRect:rect];
                rect = CGRectMake(0, i, BODY_SIZE, BODY_SIZE);
                [imageWall drawInRect:rect];

            }
        }
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
 
 
    Problem: if user press up and left when snake is going right then die
    snake direction is assigned to up so it's allowed to turn left but head of snake is still
    on the same space it was when user press up
 
    Solution: 
        - Use timer to wait until next move is done
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
            if(moveDone) {
                [self.snake didMoveToDirection:goUp];
                moveDone = NO;
            }
            break;
        }
        case NSDownArrowFunctionKey:
        {
            if(moveDone) {
                [self.snake didMoveToDirection:goDown];
                moveDone = NO;
            }
            break;
        }
        case NSLeftArrowFunctionKey:
        {
            if(moveDone) {
                [self.snake didMoveToDirection:goLeft];
                moveDone = NO;
            }
            break;
        }
        case NSRightArrowFunctionKey:
        {
            if(moveDone) {
                [self.snake didMoveToDirection:goRight];
                moveDone = NO;
            }
            break;
        }
    }
    if ([character isEqualToString:@"n"] || [character isEqualToString:@"N"]) {
        [self restartGame];
    }

}

#pragma mark SnakeStateProtocol delegate
- (void)snakeDidDie{ [self showGameOver]; }


@end