//
//  PresentStatus.h
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/31/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentStatus : NSObject

@property double speed;
@property double latitude;
@property double longitude;
@property double timeStamp;

- (double) getSpeed;
- (double) getLongitude;
- (double) getLatitude;
- (double) getTimeStamp;

@end
