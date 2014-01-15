//
//  HTFlipsideViewController.h
//  HeyThere
//
//  Created by Adeel Ateeque on 1/13/14.
//  Copyright (c) 2014 HeyThere. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTFlipsideViewController;

@protocol HTFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(HTFlipsideViewController *)controller;
@end

@interface HTFlipsideViewController : UIViewController

@property (weak, nonatomic) id <HTFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
