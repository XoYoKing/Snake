//
//  SnakeStateProtocol.h
//  SnakeMac
//
//  Created by Alberto Quesada Aranda on 17/05/15.
//  Copyright (c) 2015 Alberto Quesada Aranda. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SnakeStateProtocol <NSObject>

@required
-(void)snakeDidDie; // keep control of the snake state

@end
