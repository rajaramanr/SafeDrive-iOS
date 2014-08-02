//
//  RestAPICall.h
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 8/2/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpeedLimit.h"

@interface RestAPICall : NSObject
- (SpeedLimit*)callAPI:(double) lat : (double) longi;
@end
