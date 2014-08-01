//
//  FirstViewController.m
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "FirstViewController.h"
#import "AccidentRegion.h"
#import "AccidentRegionDAO.h"
#import "Violation.h"
#import "ViolationDAO.h"
#import "JSONReader.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get Data from the backend here and use this data in the second view controller
    // Check the second view controller json. Its modified.
    // Will do sound alert next.
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Write for reading this data from the location got from the json.
- (IBAction)gotoThisCounty:(id)sender {
    AccidentRegionDAO *regions = [[AccidentRegionDAO alloc] init];
    [regions getAccidents: @"ALLENGENY" of:@"Pennsylvania"];
}

- (IBAction)createViolationRecord:(id)sender {
    NSLog(@"Gonna Create a violation");
    ViolationDAO *vio = [[ViolationDAO alloc] init];
    vio.addViolation;
}

- (IBAction)readJson:(id)sender {
    JSONReader *reader = [[JSONReader alloc] init];
    reader.getCurrentStatus;
}
@end
