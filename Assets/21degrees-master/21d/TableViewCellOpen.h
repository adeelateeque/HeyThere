//
//  TableViewCellOpen.h
//  Demo
//
//  Created by Will Russell on 26/11/12.
//  Copyright (c) 2012 Hon Cheng Muh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellOpen : UITableViewCell


@property(nonatomic)IBOutlet UILabel *name;
@property(nonatomic)IBOutlet UIImageView *icon;
@property(nonatomic)IBOutlet UILabel *tempmax;
@property(nonatomic)IBOutlet UILabel *tempmin;
@property(nonatomic)IBOutlet UILabel *precis;

@property(nonatomic)IBOutlet UILabel *feelsliketemp;


@end
