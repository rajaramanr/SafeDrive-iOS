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
#import "PresentStatus.h"

@interface FirstViewController ()

@end
NSMutableArray* allStatus;
double currentSpeed = 0;
int currentIndex = 0;

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the current speed and location from JSON file provided
    allStatus = [[NSMutableArray alloc] init];
    JSONReader *reader = [[JSONReader alloc] init];
    allStatus = reader.readJSON;
    
    
    [self reflectOnUI:[allStatus[currentIndex] getSpeed]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(doIteratively:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void) doIteratively:(NSTimer *)timer {
    currentIndex++;
    [self reflectOnUI:[allStatus[currentIndex] getSpeed]];
}

-(void) reflectOnUI: (double) currentSpeed{
    self.currentSpeed.text = [NSString stringWithFormat:@"%f",currentSpeed];
    // self.speedLimit.text = [NSString stringWithFormat:@"%f", speedLimit];
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
    reader.readJSON;
}
@end
