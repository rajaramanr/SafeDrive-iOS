//
//  SpeedLimit.h
//  RestAPI
//
//  Created by Rajaraman Raghunathan on 8/1/14.
//  Copyright (c) 2014 Rajaramanr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeedLimit : NSObject
@property double speedLimit;
@property NSString* city;
@property NSString* street;
@property NSString* county;
@property NSString* state;

- (double) getSpeedLimit;
- (NSString*) getCity;
- (NSString*) getStreet;
- (NSString*) getCounty;
- (NSString*) getState;
@end
