//
//  PresentStatus.m
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/31/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "PresentStatus.h"

@implementation PresentStatus

-(double) getSpeed {
    return (self.speed);
}

-(double) getLatitude {
    return (self.latitude);
}

-(double) getLongitude {
    return (self.longitude);
}

-(double) getTimeStamp {
    return (self.timeStamp);
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Status: Speed=%f Lat=%f Long=%f", self.speed, self.latitude, self.longitude];
}
@end
