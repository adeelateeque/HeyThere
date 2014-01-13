//
//  Regional.h
//
//  Created by Will Russell on 24/11/12.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

@interface Regional : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    //scroll outlets
  //  UIScrollView * scrollView;
  //  UIView * contentView;
    
    CLLocationManager *locationManager;
    
}

@property(nonatomic)IBOutlet UIButton * northButton;

@property (nonatomic)IBOutlet UILabel *localtemptoday;
@property (nonatomic)IBOutlet UILabel *locationlabel;
@property (nonatomic)IBOutlet UILabel *precistoday;
@property (nonatomic)IBOutlet UILabel *feelslikelabel;
@property (nonatomic)IBOutlet UIImageView *weathericon;
@property (nonatomic) NSDictionary *deserializedData;

@property (nonatomic)IBOutlet UITableView *tableview;

//scroll view properties
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UIView * contentView;

-(IBAction)showMenu:(id)sender;
- (void)pullRegional;
- (void)newDataObserver;

@end
