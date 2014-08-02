//
//  SpeedLimit.m
//  RestAPI
//
//  Created by Rajaraman Raghunathan on 8/1/14.
//  Copyright (c) 2014 Rajaramanr. All rights reserved.
//

#import "SpeedLimit.h"

@implementation SpeedLimit

- (double) getSpeedLimit {
    return self.speedLimit;
}

- (NSString*) getCity {
    return self.city;
}

- (NSString*) getStreet{
    return self.street;
}

- (NSString*) getCounty{
    return self.county;
}

- (NSString*) getState{
    return self.state;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"SpeedLimit=%f City=%@ Street=%@ County=%@ State=%@", self.speedLimit, self.city, self.street, self.county, self.state];
}
@end
