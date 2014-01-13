//
//  HTMainViewController.h
//  HeyThere
//
//  Created by Adeel Ateeque on 1/13/14.
//  Copyright (c) 2014 HeyThere. All rights reserved.
//

#import "HTFlipsideViewController.h"

@interface HTMainViewController : UIViewController <HTFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
