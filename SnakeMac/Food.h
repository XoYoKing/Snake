//
//  Food.h
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 16/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

    // food rectangle
@property CGRect foodRect;

    // initialize food at given position (x,y)
- (id)initWithX:(int)x andY:(int)y;

@end
