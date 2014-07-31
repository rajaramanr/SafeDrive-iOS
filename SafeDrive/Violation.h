//
//  Violation.h
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/31/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Violation : NSObject {
    NSInteger violationId1;
    NSDate *dateOfViolation1;
    NSInteger count1;
}

@property (nonatomic, retain) NSDate *dateOfViolation;
@property (nonatomic, assign) NSInteger violationId;
@property (nonatomic, assign) NSInteger count;
@end
