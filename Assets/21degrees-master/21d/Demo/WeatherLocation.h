//
//  WeatherLocation.h
//
//  Created by Will Russell on 24/11/12.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WeatherLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name description:(NSString*)description coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
