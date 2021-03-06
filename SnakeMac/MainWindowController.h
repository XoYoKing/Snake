//
//  MainWindowController.h
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "SnakeStateProtocol.h"
#import "Snake.h"

@interface MainWindowController : NSView <SnakeStateProtocol> {

    NSTimer *timer; // speed of the snake --> difficulty of the game
    bool moveDone;  // did snake already move?
    
}

@property (nonatomic) Snake *snake; // snake object

-(void)initGame; // start the game
-(void)gameOver: (NSTimer *) t; // finish the game

@property (assign) IBOutlet NSTextField *title;
@property (assign) IBOutlet NSTextField *gameOverLabel;
@property (assign) IBOutlet NSTextField *difficulty;
@property (assign) IBOutlet NSButton *buttonStart;
@property (assign) IBOutlet NSSlider *slider;
@property (assign) IBOutlet NSTextField *puntuation;
@property (assign) IBOutlet NSTextField *recordLabel;
@property (assign) IBOutlet NSTextField *recordP;
@property (assign) IBOutlet NSTextField *drunkLabel;
@property (assign) IBOutlet NSButton *drunk;
@property (assign) IBOutlet NSButton *walls;

@property (assign) IBOutlet NSView *header;

@end