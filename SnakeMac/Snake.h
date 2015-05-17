//
//  Snake.h
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
#import "SnakeStateProtocol.h"

enum {
    goLeft = 0,
    goRight = 1,
    goDown = 2,
    goUp = 3
};
typedef NSUInteger SnakeDirection;
typedef CGRect SnakeBody;

@interface Snake : NSObject {
    int randomN;
    int randomItera;
}

/*
    - use property and synthesize to automatically generate accesor methods
    - default: atomic, strong/retain, assign, readwrite
*/

@property (nonatomic) id<SnakeStateProtocol> delegate;  // required function snakeDidDie
@property (nonatomic) int bodyLength;   // body number
@property (nonatomic) bool hasEaten;    // has eaten food
@property (nonatomic) bool isDrunk;    // the snake is drunk
@property (nonatomic) bool moveOrDie;   // move = 0 | die = 1
@property (nonatomic) CGPoint head;     // head of the snake (x,y)
@property (nonatomic) int puntuation;   // actual puntuation

@property (nonatomic) bool checkedDrunk;   // can the snake get drunk?

@property (nonatomic) SnakeDirection direction;     // next direction
@property (nonatomic) NSMutableArray *body;         // position of each body part
@property (nonatomic) Food *food;                   // next food


- (id)initSnake;
- (void)initFood;
- (void)moveSnake;
- (void)updateScreenSize;
- (void)detectState;
- (void)didMoveToDirection:(SnakeDirection)sdirection;


@end

