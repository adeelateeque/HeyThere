//
//  HTMainViewController.m
//  HeyThere
//
//  Created by Adeel Ateeque on 1/13/14.
//  Copyright (c) 2014 HeyThere. All rights reserved.
//

#import "HTMainViewController.h"
#import "BeaconCircleView.h"
#import "EasyLayout.h"
#import "HTBeaconService.h"
#import "ButtonMaker.h"

@interface HTMainViewController () <HTBeaconServiceDelegate>
{
    UILabel *statusLabel;
    UILabel *distanceLabel;
    
    BeaconCircleView *baseCircle;
    BeaconCircleView *targetCircle;
    
    UIButton *modeButton;
}
@end

@implementation HTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.88f alpha:1.0f];
    
    UIView *bottomToolbar = [[UIView alloc] init];
    bottomToolbar.backgroundColor = [UIColor colorWithWhite:0.11f alpha:1.0f];
    bottomToolbar.extSize = CGSizeMake(self.view.extSize.width, 82.0f);
    [EasyLayout bottomCenterView:bottomToolbar inParentView:self.view offset:CGSizeZero];
    
    [self.view addSubview:bottomToolbar];
    
    
    statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28.0f];
    statusLabel.text = @"Searching...";
    [EasyLayout sizeLabel:statusLabel mode:ELLineModeSingle maxWidth:self.view.extSize.width];
    [EasyLayout centerView:statusLabel inParentView:bottomToolbar offset:CGSizeZero];
    
    [bottomToolbar addSubview:statusLabel];
    
    
    baseCircle = [[BeaconCircleView alloc] init];
    [EasyLayout positionView:baseCircle aboveView:bottomToolbar horizontallyCenterWithView:self.view offset:CGSizeMake(0.0f, -50.0f)];
    
    [self.view addSubview:baseCircle];
    
    targetCircle = [[BeaconCircleView alloc] init];
    [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
    
    [self.view addSubview:targetCircle];
    
    distanceLabel = [[UILabel alloc] init];
    distanceLabel.textColor = [UIColor blackColor];
    distanceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    distanceLabel.text = @"Unknown";
    [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
    [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
    [self.view addSubview:distanceLabel];
    
    
    modeButton = [ButtonMaker plainButtonWithNormalImageName:@"mode_button_detecting.png" selectedImageName:@"mode_button_broadcasting.png"];
    [modeButton addTarget:self action:@selector(didToggleMode:) forControlEvents:UIControlEventTouchUpInside];
    [EasyLayout positionView:modeButton aboveView:bottomToolbar offset:CGSizeMake(10.0f, -10.0f)];
    [self.view addSubview:modeButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[HTBeaconService singleton] addDelegate:self];
    [[HTBeaconService singleton] startDetecting];
    
    [self changeInterfaceToDetectMode];
}

#pragma mark - HTBeaconServiceDelegate
- (void)service:(HTBeaconService *)service foundDeviceUUID:(NSString *)uuid withRange:(HTDetectorRange)range
{
    
    [UIView animateWithDuration:0.3f animations:^{
        switch (range) {
            case HTDetectorRangeFar:
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
                targetCircle.alpha = 1.0f;
                
                distanceLabel.text = @"Within 60ft";
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
                break;
                
            case HTDetectorRangeNear:
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 150.0f)];
                targetCircle.alpha = 1.0f;
                
                distanceLabel.text = @"Within 5ft";
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
                break;
                
            case HTDetectorRangeImmediate:
                [EasyLayout positionView:targetCircle aboveView:baseCircle
              horizontallyCenterWithView:self.view offset:CGSizeMake(0.0f, 10.0f)];
                targetCircle.alpha = 1.0f;
                
                distanceLabel.text = @"Within 1 foot";
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
                break;
                
            case HTDetectorRangeUnknown:
                [EasyLayout topCenterView:targetCircle inParentView:self.view offset:CGSizeMake(0.0f, 50.0f)];
                targetCircle.alpha = 0.5f;
                
                distanceLabel.text = @"Out of range";
                [EasyLayout sizeLabel:distanceLabel mode:ELLineModeMulti maxWidth:100.0f];
                [EasyLayout positionView:distanceLabel toRightAndVerticalCenterOfView:targetCircle offset:CGSizeMake(15.0f, 0.0f)];
                break;
        }
    }];
}
#pragma mark -

- (void)didToggleMode:(UIButton *)button
{
    if ([HTBeaconService singleton].isDetecting) {
        modeButton.selected = YES;
        [[HTBeaconService singleton] stopDetecting];
        [[HTBeaconService singleton] startBroadcasting];
        [self changeInterfaceToBroadcastMode];
    } else if ([HTBeaconService singleton].isBroadcasting) {
        modeButton.selected = NO;
        [[HTBeaconService singleton] stopBroadcasting];
        [[HTBeaconService singleton] startDetecting];
        [self changeInterfaceToDetectMode];
    }
    
}

- (void)changeInterfaceToBroadcastMode
{
    statusLabel.text = @"Broadcasting...";
    [EasyLayout sizeLabel:statusLabel mode:ELLineModeSingle maxWidth:self.view.extSize.width];
    
    [targetCircle stopAnimation];
    targetCircle.hidden = YES;
    distanceLabel.hidden = YES;
    [baseCircle startAnimationWithDirection:BeaconDirectionUp];
}

- (void)changeInterfaceToDetectMode
{
    statusLabel.text = @"Detecting...";
    [EasyLayout sizeLabel:statusLabel mode:ELLineModeSingle maxWidth:self.view.extSize.width];
    
    targetCircle.hidden = NO;
    distanceLabel.hidden = NO;
    [targetCircle startAnimationWithDirection:BeaconDirectionDown];
    [baseCircle stopAnimation];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(HTFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
