//
//  HTFlipsideViewController.m
//  HeyThere
//
//  Created by Adeel Ateeque on 1/13/14.
//  Copyright (c) 2014 HeyThere. All rights reserved.
//

#import "HTFlipsideViewController.h"

@interface HTFlipsideViewController ()

@end

@implementation HTFlipsideViewController

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
