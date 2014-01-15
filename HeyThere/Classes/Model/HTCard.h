//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTUser;


@interface HTCard : NSObject
@property (nonatomic, strong, readonly) HTUser *user;

- (instancetype)initWithUser:(HTUser *)user;

@end