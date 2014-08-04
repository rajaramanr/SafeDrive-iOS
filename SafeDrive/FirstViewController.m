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
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGest)];
    [_swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:_swipeLeft];
    
}

-(void) swipeLeftGest {
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
}

- (void) viewDidAppear:(BOOL)animated {
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
}
-(void) doIteratively:(NSTimer *)timer {
    counter = counter+1;
    double speedLimit = 0;
    double curSpeed = [allStatus[counter] getSpeed];
    _curSpeedUnit.text = @"MPH";
    _speedLimUnit.text = @"MPH";
    
    NSString *units = [[NSUserDefaults standardUserDefaults] stringForKey:@"Units"];
    threshold = [[NSUserDefaults standardUserDefaults] doubleForKey:@"UserDefinedThreshold"];
    if(counter >= invalidateTimerCount - 1) {
        [timer invalidate];
    }
    thisRegion = [callAPI callAPI:[allStatus[counter] getLatitude] : [allStatus[counter] getLongitude]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLocationBased"] == NO ){
        speedLimit = [[NSUserDefaults standardUserDefaults] doubleForKey:@"UserDefinedSpeed"];
    } else {
        speedLimit = [thisRegion getSpeedLimit];
        if(speedLimit == 0 || speedLimit > 200) {
            speedLimit = 25.75;
        }
        //        // Do check for KMpH or MPH
        //        if([units isEqualToString:@"MPH"]) {
        //        // Converting the m/s speed to miles/hr
        //        speedLimit = speedLimit * 2.33;
        //        }
        //        else {
        //            // Converting the m/s speed to miles/hr
        //            speedLimit = speedLimit * 3.6;
        //            _curSpeedUnit.text = @"KMPH";
        //            _speedLimUnit.text = @"KMPH";
        //            curSpeed = curSpeed*1.60934;
        //        }
    }
    // Do check for KMpH or MPH
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isLocationBased"] == YES) {
        if([units isEqualToString:@"MPH"]) {
            // Converting the m/s speed to miles/hr
            speedLimit = speedLimit * 2.33;
        }
        else {
            // Converting the m/s speed to miles/hr
            speedLimit = speedLimit * 3.6;
            _curSpeedUnit.text = @"KMPH";
            _speedLimUnit.text = @"KMPH";
            curSpeed = curSpeed*1.60934;
        }
    } else {
        if([units isEqualToString:@"KMPH"]) {
            _curSpeedUnit.text = @"KMPH";
            _speedLimUnit.text = @"KMPH";
        }
    }
    
    if( curSpeed > speedLimit + threshold) {
        NSLog(@"Adding Violation");
        ViolationDAO *vio = [[ViolationDAO alloc] init];
        vio.addViolation;
    }
    [self checkThisCounty:thisRegion];
    [self reflectOnUI:curSpeed:speedLimit];
}

-(void) reflectOnUI: (double) currentSpeed : (double) speedLimit{
    self.currentSpeed.text = [NSString stringWithFormat:@"%.2f",currentSpeed];
    self.speedLimit.text = [NSString stringWithFormat:@"%.2f", speedLimit];
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
- (void)checkThisCounty:(SpeedLimit*) thisRegion {
    AccidentRegionDAO *regions = [[AccidentRegionDAO alloc] init];
    BOOL isAccidentProne = [regions getAccidents: [[thisRegion getCounty] uppercaseString] of:[thisRegion getState] region:[[thisRegion getStreet] uppercaseString]];
    if(isAccidentProne) {
        self.view.backgroundColor = [UIColor colorWithRed:(220.0/255.0) green:(70.0/255.0)blue:(70.0/255.0) alpha:1.0];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
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
