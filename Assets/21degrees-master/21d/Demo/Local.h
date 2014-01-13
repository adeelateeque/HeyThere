//
//  Local.h
//
//  Created by Will Russell on 24/11/12.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONKit.h"
#import "SVProgressHUD.h"

@interface Local : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

{
    //scroll outlets
 //   UIScrollView * scrollView;
 //   UIView * contentView;
    
    //accordion
    NSMutableArray *data;
    NSInteger expandedRowIndex;
    
 //   UIImageView * wavy;
    
    //get user location
    CLLocationManager *locationManager;
    
}


@property (nonatomic)IBOutlet UILabel *localtemptoday;
@property (nonatomic)IBOutlet UILabel *locationlabel;
@property (nonatomic)IBOutlet UILabel *precistoday;
@property (nonatomic)IBOutlet UILabel *feelslikelabel;
@property (nonatomic)IBOutlet UIImageView *weathericon;
@property (nonatomic) NSDictionary *deserializedData;
@property (nonatomic)IBOutlet UIImageView * rib;
@property (nonatomic)IBOutlet UIButton * northButton;


@property (nonatomic)IBOutlet UITableView *tableview;

//scroll view properties
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UIView * contentView;

@property (assign) IBOutlet UIImageView * wavy;

@property (nonatomic) NSTimer * timer;

- (IBAction)showMenu:(id)sender;
- (void)pullLocal;
- (void)newDataObserver;


@end
