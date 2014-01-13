//
//  AppDelegate.h
//  Demo
//
//  Created by honcheng on 26/10/12.
//  Copyright (c) 2012 Hon Cheng Muh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoMenuController.h"
#import "Mixpanel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PaperFoldMenuControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DemoMenuController *menuController;
@end
