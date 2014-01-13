//
//  Local.m
//  Demo
//
//  Created by Will Russell on 24/11/12.
//

#import "Local.h"
#import "StyledTableViewCell.h"
#import "TableViewCellOpen.h"
#import "Reachability.h"
#import "SVStatusHUD.h"
#import "SVHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Local ()

-(void)reachabilityChanged:(NSNotification*)note;

@end

@implementation Local

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [SVProgressHUD showWithStatus:@"Locating.."];

        //update location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [locationManager startUpdatingLocation];
        
        
        [self.tableview setRowHeight:60.0];
        [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableview setSeparatorColor:[UIColor colorWithWhite:0.7 alpha:1]];
        
        expandedRowIndex = -1;
        data = [NSMutableArray new];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSDate *now = [NSDate date];
        
        for (int i = 1; i < 7; i++)
        {
            NSDate *date = [NSDate dateWithTimeInterval:+(i * (60 * 60 * 24)) sinceDate:now];
            [data addObject:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date] ]];
        }
    
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [locationManager startUpdatingLocation];
    
}

// UITableView expansion

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count] + (expandedRowIndex != -1 ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger dataIndex = [self dataIndexForRowIndex:row];
    NSString *dataObject = [data objectAtIndex:dataIndex];
    
    BOOL expandedCell = expandedRowIndex != -1 && expandedRowIndex + 1 == row;
    
    if (!expandedCell)
    {
           StyledTableViewCell *cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"data"];
        
        [tableView dequeueReusableCellWithIdentifier:@"data"];
        if (!cell)
            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"data"];
        [cell.textLabel setTextColor:UIColorFromRGB(0x4BB5C1)];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
        [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleCyan];
        [cell setDashWidth:5 dashGap:3 dashStroke:1];

        cell.textLabel.text = dataObject;
        
        return cell;
    }
    else
    {
        
        TableViewCellOpen *cell = (TableViewCellOpen*)[tableView dequeueReusableCellWithIdentifier:@"expanded"];
       if (!cell)
            cell = [[TableViewCellOpen alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expanded"];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TableViewCellOpen" owner:self options:nil];

        cell = [topLevelObjects objectAtIndex:0];
        
    //    NSString *celltemp = [_deserializedData objectForKey:@"air_temp_max2"];
    //    NSLog(@"%@ %d", celltemp, [indexPath row]);
        
        cell.name.text = dataObject;
        cell.tempmax.text = [NSString stringWithFormat:@"%@ C", [_deserializedData objectForKey:[NSString stringWithFormat:@"air_temp_max%d", [indexPath row] + 1]]];
        cell.tempmin.text = [NSString stringWithFormat:@"%@ C", [_deserializedData objectForKey:[NSString stringWithFormat:@"air_temp_min%d", [indexPath row] + 1]]];
        cell.precis.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:[NSString stringWithFormat:@"precis%d", [indexPath row] + 1]]];
        
        NSString * icon = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:[NSString stringWithFormat:@"icon%d", [indexPath row] + 1]]];
        
        if ([icon isEqualToString:@""]){
            
            [cell.icon setImage:[UIImage imageNamed:@"clear.png"]];
            
        }
        
        if ([icon isEqualToString:@"1"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"sunny.png"]];
            
        }
        
        if ([icon isEqualToString:@"2"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"clear.png"]];
            
        }
        
        
        if ([icon isEqualToString:@"3"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"partlycloudy.png"]];
            
        }
        
        if ([icon isEqualToString:@"4"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"cloudy.png"]];
            
        }
        
        
        if ([icon isEqualToString:@"6"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"dusty-hazy.png"]];
            
        }
        
        
        if ([icon isEqualToString:@"8"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"lightrain.png"]];
            
        }
        
        if ([icon isEqualToString:@"9"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"windy.png"]];
            
        }
        if ([icon isEqualToString:@"10"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"fog.png"]];
            
        }
        
        if ([icon isEqualToString:@"11"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"shower.png"]];
            
        }
        
        if ([icon isEqualToString:@"12"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"rain.png"]];
            
        }
        
        if ([icon isEqualToString:@"13"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"dusty-hazy.png"]];
            
        }
        
        if ([icon isEqualToString:@"14"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"frost.png"]];
            
        }
        
        if ([icon isEqualToString:@"15"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"snow.png"]];
            
        }
        
        if ([icon isEqualToString:@"16"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"storm.png"]];
            
        }
        
        if ([icon isEqualToString:@"17"]){
            
            [cell.icon setImage:[UIImage imageNamed:@"lightshower.png"]];
            
        }


        return cell;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    BOOL preventReopen = NO;
    
    if (row == expandedRowIndex + 1 && expandedRowIndex != -1)
        return nil;
    
    [tableView beginUpdates];
    
    if (expandedRowIndex != -1)
    {
        NSInteger rowToRemove = expandedRowIndex + 1;
        
        preventReopen = row == expandedRowIndex;
        if (row > expandedRowIndex)
            row--;
        expandedRowIndex = -1;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    NSInteger rowToAdd = -1;
    if (!preventReopen)
    {
        rowToAdd = row + 1;
        expandedRowIndex = row;
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToAdd inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        
    }
    [tableView endUpdates];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (expandedRowIndex != -1 && row == expandedRowIndex + 1)
        return 80;
    return 40;
}

- (NSInteger)dataIndexForRowIndex:(NSInteger)row
{
    if (expandedRowIndex != -1 && expandedRowIndex <= row)
    {
        if (expandedRowIndex == row)
            return row;
        else
            return row - 1;
    }
    else
        return row;
}



// do update data functions
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:0];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    NSString *locationString =
    [NSString stringWithFormat:@"http://21.com.au/d21-backend/local-weather.php?latinput=%f&longinput=%f", location.coordinate.latitude, location.coordinate.longitude];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:locationString forKey:@"index"];
   
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"getlocal"
     object:self
     userInfo:dict];
       
}

- (void)pullLocal:(NSNotification *)notification {
    
    // do temp data requests
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getlocal" object:nil];
    
    NSString * locationString = [[notification userInfo] valueForKey:@"index"];
    
    [SVHTTPRequest GET:locationString
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                
                // Get JSON as a NSString from NSData response
                NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                
                
                //jsonString is your downloaded string JSON Feed
                _deserializedData = [json_string objectFromJSONString];
                
                
                [SVProgressHUD dismiss];
                
                //set push sub
                NSString *deviceToken = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"deviceToken"];
                
                NSString *pushsubString =
                [NSString stringWithFormat:@"http://21.com.au/d21-backend/subscriber.php?token=%@&location=%@", deviceToken, [_deserializedData objectForKey:@"name"]];
                
                [SVHTTPRequest GET:pushsubString
                        parameters:nil
                        completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                            
                            NSLog(@"push location renewal complete");
                            
                        }];
                
                
                NSString *tempstring = [_deserializedData objectForKey:@"current_air_temp"];
                NSLog(@"%@", tempstring);
                
                _localtemptoday.text = [NSString stringWithFormat:@"%@ C", tempstring];
                _locationlabel.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:@"name"]];
                _precistoday.text = [NSString stringWithFormat:@"%@", [_deserializedData objectForKey:@"current_precis"]];
                _feelslikelabel.text = [NSString stringWithFormat:@"Feels like %@ C", [_deserializedData objectForKey:@"current_apparent_temp"]];
                
                
                
                NSString * icon = [NSString stringWithFormat:@"%@",[_deserializedData objectForKey:@"current_icon"]];
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


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
    //    [_tableview reloadData];
        
    }
    else
    {
     //   notificationLabel.text = @"Notification Says Unreachable";
        [SVStatusHUD showWithImage:[UIImage imageNamed:@"storm.png"] status:@"No Connection" duration:10];

    }
}

- (void)newDataObserver {
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pullLocal:)
     name:@"getlocal" object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pullLocal:)
     name:@"getlocal" object:nil];
    
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
            
            
        //    [_tableview reloadData];
            
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
    
    //do initial anim
    NSLog(@" begin anim");
    [UIView beginAnimations:@"myAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    // [UIView setAnimationRepeatCount:-1];
    
    //    [UIView setAnimationDidStopSelector:@selector(callSomeThingElse)];
    
    _localtemptoday.frame = CGRectMake(_localtemptoday.frame.origin.x + 50,
                            _localtemptoday.frame.origin.y,
                            _localtemptoday.frame.size.width,
                            _localtemptoday.frame.size.height);
    
    [UIView commitAnimations];
    


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
