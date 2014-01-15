//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INWeightedAverage : NSObject

- (void)addValue:(NSInteger)value;

@property (nonatomic, readonly) NSInteger weightedAverage;

@end
