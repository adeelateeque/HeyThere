//
//  AboutViewController.m
//  d21
//
//  Created by Will Russell on 1/12/12.
//  Copyright (c) 2012 willsr. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create scrollviews
    [_scrollView addSubview:_contentView];
    _scrollView.contentSize = _contentView.bounds.size;
    _scrollView.backgroundColor = [UIColor clearColor];


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
