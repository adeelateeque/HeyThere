//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//

#import "HTCard.h"
#import "HTUser.h"


@implementation HTCard {

}
- (instancetype)initWithUser:(HTUser *)user {
    self = [super init];
    if (self) {
        _user = user;
    }

    return self;
}

@end