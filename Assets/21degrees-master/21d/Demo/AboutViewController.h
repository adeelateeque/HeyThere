//
//  AboutViewController.h
//  d21
//
//  Created by Will Russell on 1/12/12.
//  Copyright (c) 2012 willsr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController



//scroll view properties
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UIView * contentView;
@property (nonatomic)IBOutlet UIButton * northButton;


- (IBAction)showMenu:(id)sender;

@end
