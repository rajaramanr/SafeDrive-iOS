//
//  SettingsViewController.h
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SettingsViewController : UITableViewController
- (IBAction)isLocationBased:(id)sender;
- (IBAction)isAlertEnabled:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *locationStatus;
@property (strong, nonatomic) IBOutlet UISwitch *alertStatus;
@property (strong, nonatomic) IBOutlet UITableView *settingsTable;
@property (strong, nonatomic) IBOutlet UITextField *userDefSpeed;
- (IBAction)saveUserDefinedSpeed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *threshold;
- (IBAction)saveThreshold:(id)sender;
@end
