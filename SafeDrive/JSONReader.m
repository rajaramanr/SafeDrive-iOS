//
//  JSONReader.m
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/30/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "JSONReader.h"
#import "PresentStatus.h"

@implementation JSONReader


-(void) readFromFile {
    
}

-(NSMutableArray*) readJSON{
    NSMutableArray *statuses = [[NSMutableArray alloc] init];
    NSLog(@"Reading JSON");
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"DrivingCleaned" ofType:@"json"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    // maybe for debugging...
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    double timestamp = 0;
    double lat = 0;
    double longt = 0;
    PresentStatus *status;
    for(NSString* str in listArray) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        double timestampFromFile = [[dict valueForKey:@"timestamp"] doubleValue];
        if(timestampFromFile != timestamp) {
            if (status != NULL) {
                if(status.latitude == 0) {
                    status.latitude = lat;
                }
                if (status.longitude == 0) {
                    status.longitude = longt;
                }
                [statuses addObject:status];
            }
            status = [[PresentStatus alloc] init];
            status.timeStamp = timestampFromFile;
            timestamp = timestampFromFile;
        }
        NSString *name = [dict valueForKey:@"name"];
        if([name isEqualToString:@"vehicle_speed"]) {
            status.speed = [[dict valueForKey:@"value"] doubleValue];
        } else if([name isEqualToString:@"latitude"]) {
            status.latitude = [[dict valueForKey:@"value"] doubleValue];
            lat = status.latitude;
        } else if([name isEqualToString:@"longitude"]) {
            status.longitude = [[dict valueForKey:@"value"] doubleValue];
            longt = status.longitude;
        }
    }
    NSLog(@"%@", statuses);
    return statuses;
}

@end
