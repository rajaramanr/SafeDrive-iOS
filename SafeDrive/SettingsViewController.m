//
//  SettingsViewController.m
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

int SPEED_LIMIT_SECTION_STATIC_ROWS = 4;
int ALERT_SECTION_STATIC_ROWS = 1;
int NUMBER_OF_SECTIONS = 2;

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int noOfRows = 0;
    switch (section) {
        case 0:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLocationBased"] == NO ){
                noOfRows = SPEED_LIMIT_SECTION_STATIC_ROWS;
            } else {
                noOfRows = SPEED_LIMIT_SECTION_STATIC_ROWS - 1;
            }
            break;
        case 1:
            noOfRows = 2;
        default:
            break;
    }
    return noOfRows;
}

- (IBAction)isLocationBased:(id)sender {
    BOOL status = self.locationStatus.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"isLocationBased"];
    [self.settingsTable reloadData];
}

- (IBAction)isAlertEnabled:(id)sender {
    BOOL status = self.alertStatus.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"isAlertEnabled"];
}

- (IBAction)saveUserDefinedSpeed:(id)sender {
    double userDefinedSpeed = self.userDefSpeed.text.doubleValue;
    NSLog(@"%f", userDefinedSpeed);
    if(userDefinedSpeed < 10 || userDefinedSpeed > 150) {
        [[NSUserDefaults standardUserDefaults] setDouble:30 forKey:@"UserDefinedSpeed"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Abnormal Speed" message:@"Specify speed limit between 10 and 150. Currently considering 20 as user defined value." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        self.userDefSpeed.text = [NSString stringWithFormat:@"%d", 20];
        userDefinedSpeed = 20;
    }
    [[NSUserDefaults standardUserDefaults] setDouble:userDefinedSpeed forKey:@"UserDefinedSpeed"];
    [self.userDefSpeed resignFirstResponder];
}

- (IBAction)saveThreshold:(id)sender {
    [self.threshold setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    double threshold = self.threshold.text.doubleValue;
    [[NSUserDefaults standardUserDefaults] setDouble:threshold forKey:@"UserDefinedThreshold"];
    [self.threshold resignFirstResponder];

}
@end
