//
//  AccidentRegion.h
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/30/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccidentRegion : NSObject {
    NSInteger regionId1;
    NSString *regionName1;
    NSString *countyName1;
    NSString *stateName1;
}

@property (nonatomic, retain) NSString *regionName;
@property (nonatomic, assign) NSInteger regionId;
@property (nonatomic, retain) NSString *countyName;
@property (nonatomic, retain) NSString *stateName;

@end