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
#import "RestAPICall.h"
#import "SpeedLimit.h"

@interface FirstViewController ()

@end

NSMutableArray* allStatus;
int currentIndex = 0;
RestAPICall* callAPI;
SpeedLimit* thisRegion;
int invalidateTimerCount = 0;

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    allStatus = [[NSMutableArray alloc] init];
    callAPI = [[RestAPICall alloc] init];
    
    JSONReader *reader = [[JSONReader alloc] init];
    allStatus = reader.readJSON;
    invalidateTimerCount = [allStatus count];
    thisRegion = [callAPI callAPI:[allStatus[currentIndex] getLatitude] : [allStatus[currentIndex] getLongitude]];
    [self reflectOnUI:[allStatus[currentIndex] getSpeed]:thisRegion];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(doIteratively:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void) doIteratively:(NSTimer *)timer {
    currentIndex++;
    NSLog(@"Current counter = %d size = %d", currentIndex, invalidateTimerCount);
    if(currentIndex >= invalidateTimerCount - 1) {
        [timer invalidate];
    }
    thisRegion = [callAPI callAPI:[allStatus[currentIndex] getLatitude] : [allStatus[currentIndex] getLongitude]];
    if([allStatus[currentIndex] getSpeed] > [thisRegion getSpeedLimit]) {
        NSLog(@"Adding Violation");
        ViolationDAO *vio = [[ViolationDAO alloc] init];
        vio.addViolation;
    }
    [self reflectOnUI:[allStatus[currentIndex] getSpeed]:thisRegion];
}

-(void) reflectOnUI: (double) currentSpeed : (SpeedLimit*) thisRegion{
    self.currentSpeed.text = [NSString stringWithFormat:@"%f",currentSpeed];
    self.speedLimit.text = [NSString stringWithFormat:@"%f", thisRegion.getSpeedLimit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
