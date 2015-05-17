//
//  Food.m
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import "Food.h"

@implementation Food

- (id)initWithX:(int)x andY:(int)y
{
    if (self = [super init]) {
        _foodRect = CGRectMake(x, y, 10, 10);         
    }
    return self;
}

@end
