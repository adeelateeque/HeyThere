//
// Created by Adeel on 15/1/14.
// Copyright (c) 2014 HeyThere. All rights reserved.
//

#import "HTBeaconService.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CBPeripheralManager+Ext.h"
#import "CBCentralManager+Ext.h"
#import "CBUUID+Ext.h"

#import "GCDSingleton.h"
#import "EasedValue.h"

#define DEBUG_CENTRAL NO
#define DEBUG_PERIPHERAL NO
#define DEBUG_PROXIMITY NO

#define UPDATE_INTERVAL 1.0f

@interface HTBeaconService() <CBPeripheralManagerDelegate, CBCentralManagerDelegate>
@end

@implementation HTBeaconService
{
    CBUUID *identifier;
    HTDetectorRange identifierRange;

    CBCentralManager *centralManager;
    CBPeripheralManager *peripheralManager;

    NSMutableSet *delegates;

    EasedValue *easedProximity;

    NSTimer *detectorTimer;

    BOOL bluetoothIsEnabledAndAuthorized;
    NSTimer *authorizationTimer;
}

#pragma mark Singleton
+ (HTBeaconService *)singleton
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initWithIdentifier:SINGLETON_IDENTIFIER];
    });
}
#pragma mark -


- (id)initWithIdentifier:(NSString *)theIdentifier
{
    if ((self = [super init])) {
        identifier = [CBUUID UUIDWithString:theIdentifier];

        delegates = [[NSMutableSet alloc] init];

        easedProximity = [[EasedValue alloc] init];

        // use to track changes to this value
        bluetoothIsEnabledAndAuthorized = [self hasBluetooth];
        [self startAuthorizationTimer];
    }
    return self;
}

- (void)addDelegate:(id<HTBeaconServiceDelegate>)delegate
{
    [delegates addObject:delegate];
}

- (void)removeDelegate:(id<HTBeaconServiceDelegate>)delegate
{
    [delegates removeObject:delegate];
}

- (void)performBlockOnDelegates:(void(^)(id<HTBeaconServiceDelegate> delegate))block
{
    [self performBlockOnDelegates:block complete:nil];
}

- (void)performBlockOnDelegates:(void(^)(id<HTBeaconServiceDelegate> delegate))block complete:( void(^)(void))complete
{
    for (id<HTBeaconServiceDelegate>delegate in delegates) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(delegate);
        });
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (complete)
            complete();
    });

}

- (void)startDetecting
{
    if (![self canMonitorBeacons])
        return;

    [self startDetectingBeacons];
}

- (void)startScanning
{

    NSDictionary *scanOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)};


    [centralManager scanForPeripheralsWithServices:@[identifier] options:scanOptions];
    _isDetecting = YES;
}

- (void)stopDetecting
{
    _isDetecting = NO;

    [centralManager stopScan];
    centralManager = nil;

    [detectorTimer invalidate];
    detectorTimer = nil;
}

- (void)startBroadcasting
{
    if (![self canBroadcast])
        return;

    [self startBluetoothBroadcast];

}

- (void)stopBroadcasting
{
    _isBroadcasting = NO;

    // stop advertising beacon data.
    [peripheralManager stopAdvertising];
    peripheralManager = nil;
}

- (void)startDetectingBeacons
{
    if (!centralManager)
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    detectorTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self
                                                   selector:@selector(reportRangesToDelegates:) userInfo:nil repeats:YES];
}

- (void)startBluetoothBroadcast
{
    // start broadcasting if it's stopped
    if (!peripheralManager) {
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
}

- (void)startAdvertising
{

    NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey:@"vicinity-peripheral",
            CBAdvertisementDataServiceUUIDsKey:@[identifier]};

    // Start advertising over BLE
    [peripheralManager startAdvertising:advertisingData];

    _isBroadcasting = YES;
}

- (BOOL)canBroadcast
{
    // iOS6 can't detect peripheral authorization so just assume it works.
    // ARC complains if we use @selector because `authorizationStatus` is ambiguous
    SEL selector = NSSelectorFromString(@"authorizationStatus");
    if (![[CBPeripheralManager class] respondsToSelector:selector])
        return YES;

    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];

    BOOL enabled = (status == CBPeripheralManagerAuthorizationStatusAuthorized ||
            status == CBPeripheralManagerAuthorizationStatusNotDetermined);

    if (!enabled)
        NSLog(@"bluetooth not authorized");

    return enabled;
}

- (BOOL)canMonitorBeacons
{
    return YES;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (DEBUG_PERIPHERAL) {
        NSLog(@"did discover peripheral: %@, data: %@, %1.2f", [peripheral.identifier UUIDString], advertisementData, [RSSI floatValue]);

        CBUUID *uuid = [advertisementData[CBAdvertisementDataServiceUUIDsKey] firstObject];
        NSLog(@"service uuid: %@", [uuid representativeString]);
    }

    identifierRange = [self convertRSSItoHTProximity:[RSSI floatValue]];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (DEBUG_CENTRAL)
        NSLog(@"-- central state changed: %@", centralManager.stateString);

    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startScanning];
    }

}
#pragma mark -

- (void)reportRangesToDelegates:(NSTimer *)timer
{
    [self performBlockOnDelegates:^(id<HTBeaconServiceDelegate>delegate) {

        [delegate service:self foundDeviceUUID:[identifier representativeString] withRange:identifierRange];

    } complete:^{
        // timeout the beacon to unknown position
        // it it's still active it will be updated by central delegate "didDiscoverPeripheral"
        identifierRange = HTDetectorRangeUnknown;
    }];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (DEBUG_PERIPHERAL)
        NSLog(@"-- peripheral state changed: %@", peripheral.stateString);

    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self startAdvertising];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (DEBUG_PERIPHERAL) {
        if (error)
            NSLog(@"error starting advertising: %@", [error localizedDescription]);
        else
            NSLog(@"did start advertising");
    }
}
#pragma mark -

- (HTDetectorRange)convertRSSItoHTProximity:(NSInteger)proximity
{
    // eased value doesn't support negative values
    easedProximity.value = fabsf(proximity);
    [easedProximity update];
    proximity = easedProximity.value * -1.0f;

    if (DEBUG_PROXIMITY)
        NSLog(@"proximity: %d", proximity);


    if (proximity < -70)
        return HTDetectorRangeFar;
    if (proximity < -55)
        return HTDetectorRangeNear;
    if (proximity < 0)
        return HTDetectorRangeImmediate;

    return HTDetectorRangeUnknown;
}

- (BOOL)hasBluetooth
{
    return [self canBroadcast] && peripheralManager.state == CBPeripheralManagerStatePoweredOn;
}

- (void)startAuthorizationTimer
{
    authorizationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                                        selector:@selector(checkBluetoothAuth:)
                                                        userInfo:nil repeats:YES];
}

- (void)checkBluetoothAuth:(NSTimer *)timer
{
    if (bluetoothIsEnabledAndAuthorized != [self hasBluetooth]) {

        bluetoothIsEnabledAndAuthorized = [self hasBluetooth];
        [self performBlockOnDelegates:^(id<HTBeaconServiceDelegate>delegate) {
            if ([delegate respondsToSelector:@selector(service:bluetoothAvailable:)])
                [delegate service:self bluetoothAvailable:bluetoothIsEnabledAndAuthorized];
        }];
    }
}
@end
