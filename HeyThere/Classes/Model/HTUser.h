//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTUser : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDate *dob;
@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSURL *avatarUrl;
@end