//
//  SettingsViewController.h
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (copy,nonatomic) NSArray *dates;
@end
