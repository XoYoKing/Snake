//
//  Food.m
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import "Food.h"

static int const BODY_SIZE = 10; // size of the snake's body

@implementation Food

- (id)initWithX:(int)x andY:(int)y
{
    if (self = [super init]) {
        _foodRect = CGRectMake(x, y, BODY_SIZE, BODY_SIZE);   // square of 10x10
    }
    return self;
}

@end
