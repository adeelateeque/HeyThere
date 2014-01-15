//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 Allows easing from start to end values.

 The more times you call update the closer the output value will become to the input value.
 
 Tutorial:
 1) set the `value` property to desired value.
 2) call `update` method repeatedly
 3) read `value` property back to get the eased value
 
*/

@interface EasedValue : NSObject

@property (nonatomic, assign) CGFloat value;

/**
 Causes the output of `value` to ease towards it's original input
 */
- (void)update;

/**
 Causes the output of `value` to be equal to it's original input
 */
- (void)reset;
@end
