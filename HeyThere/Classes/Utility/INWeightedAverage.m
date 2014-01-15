//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//

#import "INWeightedAverage.h"
#define NUMBER_OF_AVERAGES 70

@implementation INWeightedAverage
{
    NSMutableArray *values;
}

- (id)init
{
    if ((self = [super init])) {
        values = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addValue:(NSInteger)value
{
    if ([values count] > NUMBER_OF_AVERAGES)
        [values removeObjectAtIndex:0];
    
    [values addObject:@(value)];
}

- (NSInteger)weightedAverage
{
    NSInteger sum = 0;
    for (NSNumber *value in values) {
        sum += [value integerValue];
    }
    return sum/(NSInteger)[values count];
}
@end
