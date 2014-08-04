//
//  SecondViewController.m
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "SecondViewController.h"
#import "JSON.h"
#import "PresentStatus.h"
#define METERS_PER_MILE 1609.344
@interface SecondViewController ()
{
    NSMutableArray *location;
    int count;
    NSMutableArray *annotation;
    JSON *obj;
    NSMutableArray *allStatus;
    CLGeocoder *geoCoder;
}
@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    annotation = [NSMutableArray array];
    
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        self.mapView.showsUserLocation = NO;
    }
    else
    {
        UIAlertView *noLocationAccessAlert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"The application needs to access your location, kindly authorize it from Settings -> Privacy." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [noLocationAccessAlert show];
    }
    location = [NSMutableArray array];
    obj=[JSON getInstance];
    allStatus = obj.reader.readJSON;
    geoCoder = [[CLGeocoder alloc] init];

    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES]; //Timer is set for once in 5 seconds. Array elements will be accessed once in every 5 seconds.
}

- (void) viewDidAppear:(BOOL)animated {
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateLocation
{
    [_mapView removeAnnotations:_mapView.annotations];

    NSNumber *longitude = [NSNumber numberWithDouble:[allStatus[counter] getLongitude]];
    NSNumber *latitude = [NSNumber numberWithDouble:[allStatus[counter] getLatitude]];
    [location addObject:latitude];
    [location addObject:longitude];
    
    //Zoom to the user location
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake([[location objectAtIndex:count] doubleValue], [[location objectAtIndex:count+1] doubleValue]);
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    
    [self.mapView setRegion:mapRegion animated: YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([[location objectAtIndex:count] doubleValue], [[location objectAtIndex:count+1] doubleValue]);
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[allStatus[counter] getLatitude] longitude:[allStatus[counter] getLongitude]];
    [geoCoder reverseGeocodeLocation: loc completionHandler: ^(NSArray *placemarks, NSError *error) {
        CLPlacemark *myPlace = [placemarks lastObject];
    point.title = [NSString stringWithFormat:@"%@,%@,%@",myPlace.subThoroughfare,myPlace.thoroughfare,myPlace.locality];
    point.subtitle = [NSString stringWithFormat:@"%.6f, %.6f",[allStatus[counter] getLatitude],[allStatus[counter] getLongitude]];
        [self.mapView addAnnotation:point];
    }];
    count+=2;
}

@end
