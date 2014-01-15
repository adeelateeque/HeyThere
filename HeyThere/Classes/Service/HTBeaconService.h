//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HTDetectorRangeUnknown = 0,
    HTDetectorRangeFar,
    HTDetectorRangeNear,
    HTDetectorRangeImmediate,
} HTDetectorRange;

#define SINGLETON_IDENTIFIER @"CB284D88-5317-4FB4-9621-C5A3A49E6155"

@class HTBeaconService;
@protocol HTBeaconServiceDelegate <NSObject>
@optional
- (void)service:(HTBeaconService *)service foundDeviceUUID:(NSString *)uuid withRange:(HTDetectorRange)range;
- (void)service:(HTBeaconService *)service bluetoothAvailable:(BOOL)enabled;
@end

@interface HTBeaconService : NSObject

- (id)initWithIdentifier:(NSString *)theIdentifier;

- (void)addDelegate:(id<HTBeaconServiceDelegate>)delegate;
- (void)removeDelegate:(id<HTBeaconServiceDelegate>)delegate;

+ (HTBeaconService *)singleton;

@property (nonatomic, readonly) BOOL isDetecting;
@property (nonatomic, readonly) BOOL isBroadcasting;

- (void)startDetecting;
- (void)stopDetecting;

- (void)startBroadcasting;
- (void)stopBroadcasting;

- (BOOL)hasBluetooth;
@end
