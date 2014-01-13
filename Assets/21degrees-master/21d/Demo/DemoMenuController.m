//
//  DemoMenuController.m
//  Demo
//
//  Created by honcheng on 26/10/12.
//  Copyright (c) 2012 Hon Cheng Muh. All rights reserved.
//

#import "DemoMenuController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DemoMenuController ()

@end

@implementation DemoMenuController

- (id)initWithMenuWidth:(float)menuWidth numberOfFolds:(int)numberOfFolds
{
    self = [super initWithMenuWidth:menuWidth numberOfFolds:numberOfFolds];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOnlyAllowEdgeDrag:NO];
        
    UIView *tableBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [tableBgView setBackgroundColor:UIColorFromRGB(0xB5E655)];
    [self.menuTableView setBackgroundView:tableBgView];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self performSelector:@selector(reloadMenu)];
}

- (void)viewWillAppear:(BOOL)animated
{
    
     [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(handleNotification:)
             name:@"showmenu"
             object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleNotification2:)
     name:@"hidemenu"
     object:nil];
    
}

-(void)handleNotification:(NSNotification *)pNotification
    {
       NSLog(@"#1 received message = %@",(NSString*)[pNotification object]);
       [self performSelector:@selector(showMenu:animated:)];
    //   [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

-(void)handleNotification2:(NSNotification *)pNotification
{
    NSLog(@"#1 received message = %@",(NSString*)[pNotification object]);
    [self performSelector:@selector(hideMenu)];
    //   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

/**
 * Override the method to customize cells
 */
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.menuTableView)
    {
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [[cell textLabel] setTextColor:UIColorFromRGB(0x6A9D02)];
            [[cell textLabel] setHighlightedTextColor:UIColorFromRGB(0xEDF7F2)];
            [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
            
            UIImageView *bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cellBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            [cell setBackgroundView:bgView];
            UIImageView *sBgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cellBgSelected.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            [cell setSelectedBackgroundView:sBgView];
        
        }
        
        UIViewController *viewController = self.viewControllers[indexPath.row];
        [cell.textLabel setText:viewController.title];
        
        if (indexPath.row==self.selectedIndex)
        {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        return cell;
    }
    else return nil;
}


@end
