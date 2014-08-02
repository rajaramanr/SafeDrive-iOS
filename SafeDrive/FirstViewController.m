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

@interface FirstViewController ()

@end

NSMutableArray *allStatus;
JSON *obj;
BOOL alertFlag = false;

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) doIteratively:(NSTimer *)timer {
    counter = counter+1;
    [self reflectOnUI:[allStatus[counter] getSpeed]];
}

-(void) reflectOnUI: (double) currentSpeed{
    self.currentSpeed.text = [NSString stringWithFormat:@"%f",currentSpeed];
    //    self.speedLimit.text = [NSString stringWithFormat:@"%f", speedLimit];
    double speedLimit = 30.0;
    CFURLRef soundFileURLRef;
    UInt32 soundID;
    
    if(currentSpeed > speedLimit) {
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
    obj=[JSON getInstance];
    allStatus = obj.reader.readJSON;
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(doIteratively:)
                                   userInfo:nil
                                    repeats:YES];
}

@end
