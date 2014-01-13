//
//  WeatherLocation.m
//
//  Created by Will Russell on 24/11/12.
//

#import "WeatherLocation.h"
#import <AddressBook/AddressBook.h>

@interface WeatherLocation ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation WeatherLocation

- (id)initWithName:(NSString*)name description:(NSString*)description coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.description = description;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _description;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:NULL];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end