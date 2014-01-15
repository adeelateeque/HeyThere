//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//
// Tiny Wrapper around Reachability 2.2 that makes it easy to see if we have internet.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@protocol ReachabilityServiceDelegate <NSObject>
- (void)reachabilityChanged;
@end

@interface ReachabilityService : NSObject 

+ (ReachabilityService *)defaultService;

- (void)addDelegate:(id<ReachabilityServiceDelegate>)aDelegate;
- (void)removeDelegate:(id<ReachabilityServiceDelegate>)aDelegate;

@property (nonatomic, readonly) BOOL canReachHost;
@property (nonatomic, readonly) BOOL hasInternetConnection;
@property (nonatomic, readonly) BOOL hasLocalWiFiConnection;

- (void)reportToDelegates;

@property (nonatomic, assign) BOOL testModeEnabled;
@end
