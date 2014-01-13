//
//  Regional.m
//
//  Created by Will Russell on 24/11/12.
//

#import "Regional.h"
#import "WeatherLocation.h"
#import "StyledTableViewCell.h"
#import "Reachability.h"
#import "SVStatusHUD.h"
#import "SVHTTPRequest.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Regional ()

@end

@implementation Regional

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //update location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [locationManager startUpdatingLocation];
        
        [self.tableview setRowHeight:60.0];
        [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableview setSeparatorColor:[UIColor colorWithWhite:0.7 alpha:1]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //update location

    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pullRegional:)
     name:@"getregional" object:nil];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [locationManager startUpdatingLocation];
    
    [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(newDataObserver)
                                   userInfo:nil
                                    repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"21.com.au"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //    blockLabel.text = @"Block Says Reachable";
            
            
         //   [_tableview reloadData];
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //    blockLabel.text = @"Block Says Unreachable";
            
            [SVStatusHUD showWithImage:[UIImage imageNamed:@"storm.png"] status:@"No Internet Connection"];
            
        });
    };
    
    [reach startNotifier];

    
    // create scrollviews
    [_scrollView addSubview:_contentView];
    _scrollView.contentSize = _contentView.bounds.size;
    _scrollView.backgroundColor = [UIColor clearColor];
}


- (void)newDataObserver {
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pullRegional:)
     name:@"getregional" object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [locationManager startUpdatingLocation];
    
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        [_tableview reloadData];
        
    }
    else
    {
        //   notificationLabel.text = @"Notification Says Unreachable";
        [SVStatusHUD showWithImage:[UIImage imageNamed:@"storm.png"] status:@"No Connection" duration:10];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger locationsAvailable = [[_deserializedData objectForKey:@"locationsavailable"] intValue];
    
    return locationsAvailable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StyledTableViewCell *cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"data"];
    
    [tableView dequeueReusableCellWithIdentifier:@"data"];
    if (!cell)
        cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"data"];
    [cell.textLabel setTextColor:UIColorFromRGB(0x4BB5C1)];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
    [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleCyan];
    [cell setDashWidth:5 dashGap:3 dashStroke:1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:[NSString stringWithFormat:@"name%d", [indexPath row]]]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ C", [_deserializedData objectForKey:[NSString stringWithFormat:@"current_air_temp%d", [indexPath row]]]];
    
    NSLog(@"%d", [indexPath row]);
    
    
    //    cell.name.text = dataObject;
    //   cell.tempmax.text = [NSString stringWithFormat:@"%@ C", [_deserializedData objectForKey:[NSString /stringWithFormat:@"air_temp_max%d", [indexPath row] + 1]]];
    //   cell.tempmin.text = [NSString stringWithFormat:@"%@ C", [_deserializedData objectForKey:[NSString stringWithFormat:@"air_temp_min%d", [indexPath row] + 1]]];
    //   cell.precis.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:[NSString stringWithFormat:@"precis%d", [indexPath row] + 1]]];
    
    NSString * icon = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:[NSString stringWithFormat:@"current_icon%d", [indexPath row]]]];
    
    if ([icon isEqualToString:@""]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"clear.png"]];
        
    }
    
    if ([icon isEqualToString:@"1"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"sunny.png"]];
        
    }
    
    if ([icon isEqualToString:@"2"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"clear.png"]];
        
    }
    
    
    if ([icon isEqualToString:@"3"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"partlycloudy.png"]];
        
    }
    
    if ([icon isEqualToString:@"4"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"cloudy.png"]];
        
    }
    
    
    if ([icon isEqualToString:@"6"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"dusty-hazy.png"]];
        
    }
    
    
    if ([icon isEqualToString:@"8"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"lightrain.png"]];
        
    }
    
    if ([icon isEqualToString:@"9"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"windy.png"]];
        
    }
    if ([icon isEqualToString:@"10"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"fog.png"]];
        
    }
    
    if ([icon isEqualToString:@"11"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"shower.png"]];
        
    }
    
    if ([icon isEqualToString:@"12"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"rain.png"]];
        
    }
    
    if ([icon isEqualToString:@"13"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"dusty-hazy.png"]];
        
    }
    
    if ([icon isEqualToString:@"14"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"frost.png"]];
        
    }
    
    if ([icon isEqualToString:@"15"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"snow.png"]];
        
    }
    
    if ([icon isEqualToString:@"16"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"storm.png"]];
        
    }
    
    if ([icon isEqualToString:@"17"]){
        
        [cell.imageView setImage:[UIImage imageNamed:@"lightshower.png"]];
        
    }
    
    return cell;
}


// do update data functions
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:0];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    NSString *locationString =
    [NSString stringWithFormat:@"http://21.com.au/d21-backend/regional-weather.php?latinput=%f&longinput=%f", location.coordinate.latitude, location.coordinate.longitude];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:locationString forKey:@"index"];
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"getregional"
     object:self
     userInfo:dict];


    
}

- (void)pullRegional:(NSNotification *)notification {
    
    // do temp data requests
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getregional" object:nil];
    
    NSString * locationString = [[notification userInfo] valueForKey:@"index"];
    
    [SVHTTPRequest GET:locationString
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                // Get JSON as a NSString from NSData response
                NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                
                
                //jsonString is your downloaded string JSON Feed
                _deserializedData = [json_string objectFromJSONString];

                
                NSString *tempstring = [_deserializedData objectForKey:@"current_air_temp0"];
                NSLog(@"%@", tempstring);
                
                _localtemptoday.text = [NSString stringWithFormat:@"%@ C", tempstring];
                _locationlabel.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:@"name0"]];
                _precistoday.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:@"current_precis0"]];
                _feelslikelabel.text = [NSString stringWithFormat:@"Feels like %@ C", [_deserializedData objectForKey:@"current_apparent_temp0"]];
                
                //  [_weathericon setImage:[UIImage imageNamed:@"sunny.png"]];
                
                NSString * icon = [NSString stringWithFormat:@"%@",[_deserializedData objectForKey:@"current_icon0"]];
                NSLog(@"%@", icon);
                
                if ([icon isEqualToString:@""]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"clear.png"]];
                    
                }
                
                if ([icon isEqualToString:@"1"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"sunny.png"]];
                    
                }
                
                if ([icon isEqualToString:@"2"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"clear.png"]];
                    
                }
                
                
                if ([icon isEqualToString:@"3"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"partlycloudy.png"]];
                    
                }
                
                if ([icon isEqualToString:@"4"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"cloudy.png"]];
                    
                }
                
                
                if ([icon isEqualToString:@"6"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"dusty-hazy.png"]];
                    
                }
                
                
                if ([icon isEqualToString:@"8"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"lightrain.png"]];
                    
                }
                
                if ([icon isEqualToString:@"9"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"windy.png"]];
                    
                }
                if ([icon isEqualToString:@"10"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"fog.png"]];
                    
                }
                
                if ([icon isEqualToString:@"11"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"shower.png"]];
                    
                }
                
                if ([icon isEqualToString:@"12"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"rain.png"]];
                    
                }
                
                if ([icon isEqualToString:@"13"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"dusty-hazy.png"]];
                    
                }
                
                if ([icon isEqualToString:@"14"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"frost.png"]];
                    
                }
                
                if ([icon isEqualToString:@"15"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"snow.png"]];
                    
                }
                
                if ([icon isEqualToString:@"16"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"storm.png"]];
                    
                }
                
                if ([icon isEqualToString:@"17"]){
                    
                    [_weathericon setImage:[UIImage imageNamed:@"lightshower.png"]];
                    
                }
                
                [_tableview reloadData];
                
            }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _locationlabel.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:[NSString stringWithFormat:@"name%d", [indexPath row]]]];
    _localtemptoday.text = [NSString stringWithFormat:@"%@ C", [_deserializedData objectForKey:[NSString stringWithFormat:@"current_air_temp%d", [indexPath row]]]];
    
    _precistoday.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:[NSString stringWithFormat:@"current_precis%d", [indexPath row]]]];
    _feelslikelabel.text = [NSString stringWithFormat:@"Feels like %@ C", [_deserializedData objectForKey:[NSString stringWithFormat:@"current_apparent_temp%d", [indexPath row]]]];
    
    //  [_weathericon setImage:[UIImage imageNamed:@"sunny.png"]];
    
    NSString * icon = [NSString stringWithFormat:@"%@",[_deserializedData objectForKey:[NSString stringWithFormat:@"current_icon%d", [indexPath row]]]];
    
    NSLog(@"%@", icon);
    
    if ([icon isEqualToString:@""]){
        
        [_weathericon setImage:[UIImage imageNamed:@"clear.png"]];
        
    }
    
    if ([icon isEqualToString:@"1"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"sunny.png"]];
        
    }
    
    if ([icon isEqualToString:@"2"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"clear.png"]];
        
    }
    
    
    if ([icon isEqualToString:@"3"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"partlycloudy.png"]];
        
    }
    
    if ([icon isEqualToString:@"4"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"cloudy.png"]];
        
    }
    
    
    if ([icon isEqualToString:@"6"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"dusty-hazy.png"]];
        
    }
    
    
    if ([icon isEqualToString:@"8"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"lightrain.png"]];
        
    }
    
    if ([icon isEqualToString:@"9"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"windy.png"]];
        
    }
    if ([icon isEqualToString:@"10"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"fog.png"]];
        
    }
    
    if ([icon isEqualToString:@"11"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"shower.png"]];
        
    }
    
    if ([icon isEqualToString:@"12"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"rain.png"]];
        
    }
    
    if ([icon isEqualToString:@"13"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"dusty-hazy.png"]];
        
    }
    
    if ([icon isEqualToString:@"14"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"frost.png"]];
        
    }
    
    if ([icon isEqualToString:@"15"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"snow.png"]];
        
    }
    
    if ([icon isEqualToString:@"16"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"storm.png"]];
        
    }
    
    if ([icon isEqualToString:@"17"]){
        
        [_weathericon setImage:[UIImage imageNamed:@"lightshower.png"]];
        
    }
    
    
    CGPoint topOffset = CGPointMake(0, 0);
    [self.scrollView setContentOffset:topOffset animated:YES];
    
    
    
}

- (IBAction)showMenu:(id)sender
{
    BOOL showmenu = 0;
    
    if (showmenu == NO) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"showmenu"
         object:self];
        
        [UIView beginAnimations:@"myAnimation" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        _northButton.transform = CGAffineTransformRotate( _northButton.transform, M_PI);
        [UIView commitAnimations];
        
        showmenu = YES;
        
    } else {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"hidemenu"
         object:self];
        
        [UIView beginAnimations:@"myAnimation" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        _northButton.transform = CGAffineTransformRotate( _northButton.transform, M_PI);
        [UIView commitAnimations];
        
        showmenu = NO;
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
