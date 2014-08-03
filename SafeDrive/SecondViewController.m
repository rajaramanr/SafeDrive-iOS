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
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES]; //Timer is set for once in 5 seconds. Array elements will be accessed once in every 5 seconds.

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
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [self.mapView setRegion:mapRegion animated: YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([[location objectAtIndex:count] doubleValue], [[location objectAtIndex:count+1] doubleValue]);
    point.title = [[location objectAtIndex:count] stringValue];
    point.subtitle = [[location objectAtIndex:count+1] stringValue];
    
    [self.mapView addAnnotation:point];
    
    NSLog(@"Location %@",[location objectAtIndex:count]);
    
    NSLog(@"Location %d %d",[location count], count);
    
    NSLog(@"Location %f %f",[[location objectAtIndex:count] doubleValue], [[location objectAtIndex:count+1] doubleValue]);
    
    count+=2;
    counter = counter+1;

}
//
//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    //Zoom to the user location
//    MKCoordinateRegion mapRegion;
//    mapRegion.center = mapView.userLocation.coordinate;// get the latitude longitude data and set it here //Make a class that reads the file and it should push 
//    mapRegion.span.latitudeDelta = 0.2;
//    mapRegion.span.longitudeDelta = 0.2;
//    
//    [mapView setRegion:mapRegion animated: YES];
//}
@end
