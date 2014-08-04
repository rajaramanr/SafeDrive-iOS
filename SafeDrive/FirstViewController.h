//
//  FirstViewController.h
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface FirstViewController : UIViewController
- (IBAction)readJson:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *currentSpeed;
@property (weak, nonatomic) IBOutlet UILabel *speedLimit;
@property (weak, nonatomic) IBOutlet UILabel *curSpeedUnit;
@property (weak, nonatomic) IBOutlet UILabel *speedLimUnit;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeft;

@end
