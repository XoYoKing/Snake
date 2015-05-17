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
    NSInteger record;  // top record
    
}


@property (nonatomic) Snake *snake; // snake object

-(void)initGame; // start the game
-(void)gameOver; // finish the game

@property (assign) IBOutlet NSTextField *title;
@property (assign) IBOutlet NSTextField *difficulty;
@property (assign) IBOutlet NSButton *buttonStart;
@property (assign) IBOutlet NSSlider *slider;
@property (assign) IBOutlet NSTextField *puntuation;
@property (assign) IBOutlet NSTextField *actualLabel;
@property (assign) IBOutlet NSTextField *recordLabel;



@end