//
//  SecondViewController.m
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "SecondViewController.h"
#define METERS_PER_MILE 1609.344
@interface SecondViewController ()
{
    NSMutableArray *location;
    int count;
    NSMutableArray *annotation;
}
@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    annotation = [NSMutableArray array];
    
    //self.mapView.delegate = (id)self;
    
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        //Just to reset map view to update user location again on button tap
        self.mapView.showsUserLocation = NO;
        self.mapView.showsUserLocation = YES;
    }
    else
    {
        UIAlertView *noLocationAccessAlert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"The application needs to access your location, kindly authorize it from Settings -> Privacy." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [noLocationAccessAlert show];
    }
    
    [self readJSONFile];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)readJSONFile
{
    NSError *error;
    
    location = [NSMutableArray array];
    
    NSArray *readJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"driving" ofType:@"json"]] options:NSJSONReadingMutableContainers error:&error];
    
    for (NSDictionary *dict in readJSON)
    {
        if ([[dict valueForKeyPath:@"name"] isEqualToString: @"latitude"] || [[dict valueForKeyPath:@"name"] isEqualToString: @"longitude"])
        {
            [location addObject:[dict valueForKeyPath:@"value"]];
        }
    }
    
    //NSLog(@"Location %@",location);
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES]; //Timer is set for once in 5 seconds. Array elements will be accessed once in every 5 seconds.
}

-(void)updateLocation
{

    //Zoom to the user location
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake([[location objectAtIndex:count] doubleValue], [[location objectAtIndex:count+1] doubleValue]);
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [self.mapView setRegion:mapRegion animated: YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([[location objectAtIndex:count] doubleValue], [[location objectAtIndex:count+1] doubleValue]);
    
    [annotation addObject:point];
    
    [self.mapView addAnnotations:annotation];
    
    NSLog(@"Location %@",[location objectAtIndex:count]);
    
    NSLog(@"Location %d %d",[location count], count);
    
    NSLog(@"Location %f %f",[[location objectAtIndex:count] doubleValue], [[location objectAtIndex:count+1] doubleValue]);
    
    count+=2;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //Zoom to the user location
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;// get the latitude longitude data and set it here //Make a class that reads the file and it should push 
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [mapView setRegion:mapRegion animated: YES];
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.291508;
    zoomLocation.longitude= -83.23764;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    //[_mapView setRegion:viewRegion animated:YES];
}

@end
