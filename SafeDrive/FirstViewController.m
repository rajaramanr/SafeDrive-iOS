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
#import "JSON.h"
#import "PresentStatus.h"
#import "RestAPICall.h"
#import "SpeedLimit.h"

@interface FirstViewController ()

@end

NSMutableArray* allStatus;
JSON *obj;
BOOL alertFlag = false;
RestAPICall* callAPI;
SpeedLimit* thisRegion;
int invalidateTimerCount = 0;
double threshold = 0.0;

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) doIteratively:(NSTimer *)timer {
    counter = counter+1;
    double speedLimit = 0;
    threshold = [[NSUserDefaults standardUserDefaults] doubleForKey:@"UserDefinedThreshold"];
    if(counter >= invalidateTimerCount - 1) {
        [timer invalidate];
    }
    thisRegion = [callAPI callAPI:[allStatus[counter] getLatitude] : [allStatus[counter] getLongitude]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLocationBased"] == NO ){
        NSLog(@"Only user defined speed limit");
        speedLimit = [[NSUserDefaults standardUserDefaults] doubleForKey:@"UserDefinedSpeed"];
        NSLog(@"%f", speedLimit);
    } else {
        NSLog(@"Obtaining from location");
        speedLimit = [thisRegion getSpeedLimit];
    }
    if([allStatus[counter] getSpeed] > speedLimit + threshold) {
        NSLog(@"Adding Violation");
        ViolationDAO *vio = [[ViolationDAO alloc] init];
        vio.addViolation;
    }
    [self reflectOnUI:[allStatus[counter] getSpeed]:speedLimit];
}

-(void) reflectOnUI: (double) currentSpeed : (double) speedLimit{
    self.currentSpeed.text = [NSString stringWithFormat:@"%f",currentSpeed];
    self.speedLimit.text = [NSString stringWithFormat:@"%f", speedLimit];
    CFURLRef soundFileURLRef;
    UInt32 soundID;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isAlertEnabled"]) {
    if(currentSpeed > speedLimit + threshold) {
        alertFlag = true;
        CFBundleRef mainBundle = CFBundleGetMainBundle();
        soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"alert", CFSTR ("caf"),NULL);
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    else if(alertFlag){
        alertFlag = false;
        AudioServicesDisposeSystemSoundID(soundID);
    }
    }
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
    //Reading JSON
    [sender setTintColor:[UIColor blueColor]];
    obj=[JSON getInstance];
    allStatus = obj.reader.readJSON;
    invalidateTimerCount = [allStatus count];
    //Initializing call to API
    callAPI = [[RestAPICall alloc] init];

    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(doIteratively:)
                                   userInfo:nil
                                    repeats:YES];
}
@end
