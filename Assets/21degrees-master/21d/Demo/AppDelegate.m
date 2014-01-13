//
//  AppDelegate.m
//  Demo
//
//  Created by honcheng on 26/10/12.
//  Copyright (c) 2012 Hon Cheng Muh. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoMenuController.h"
#import "DemoRootViewController.h"
#import "Regional.h"
#import "Local.h"
#import "National.h"
#import "AboutViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _menuController = [[DemoMenuController alloc] initWithMenuWidth:150.0 numberOfFolds:2];
    [_menuController setDelegate:self];
    [self.window setRootViewController:_menuController];
    
    // Add registration for remote notifications
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge)];
    
    // Clear application badge when app launches
    application.applicationIconBadgeNumber = 0;

    
    NSMutableArray *viewControllers = [NSMutableArray array];
    
        Local *localViewController = [[Local alloc] init];
        [localViewController setTitle:[NSString stringWithFormat:@"Local"]];
        [viewControllers addObject:localViewController];
    
        Regional *regionalViewController = [[Regional alloc] init];
        [regionalViewController setTitle:[NSString stringWithFormat:@"Regional"]];
        [viewControllers addObject:regionalViewController];

        National *nationalViewController = [[National alloc] init];
        [nationalViewController setTitle:[NSString stringWithFormat:@"National"]];
        [viewControllers addObject:nationalViewController];
    
        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
        [aboutViewController setTitle:[NSString stringWithFormat:@"About 21˚"]];
        [viewControllers addObject:aboutViewController];
    
    [_menuController setViewControllers:viewControllers];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window setBackgroundColor:[UIColor colorWithRed:0.170 green:0.166 blue:0.175 alpha:1.000]];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)paperFoldMenuController:(PaperFoldMenuController *)paperFoldMenuController didSelectViewController:(UIViewController *)viewController
{

}


//APN Code

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSLog(@"My token is: %@", devToken);
    
    // Prepare the Device Token for Registration (remove spaces and < >)
	NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[NSUserDefaults standardUserDefaults]
     setObject:deviceToken forKey:@"deviceToken"];
    
    NSString *locationString =
    [NSString stringWithFormat:@"http://21.com.au/d21-backend/subscriber.php?token=%@", deviceToken];
        
    // Prepare URL request to download statuses from Twitter
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
    
    // Perform request and get JSON back as a NSData object
   [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSLog(@"subscription complete");
}

/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
#if !TARGET_IPHONE_SIMULATOR
    
	NSLog(@"Error in registration. Error: %@", error);
    
#endif
}

/**
 * Remote Notification Received while application was open.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
#if !TARGET_IPHONE_SIMULATOR
    
	NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
    
	NSString *badge = [apsInfo objectForKey:@"badge"];
	NSLog(@"Received Push Badge: %@", badge);
	application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
#endif
}

/*
 * ------------------------------------------------------------------------------------------
 *  END APNS CODE
 * ------------------------------------------------------------------------------------------
 */


@end
