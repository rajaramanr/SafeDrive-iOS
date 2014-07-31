//
//  ViolationDAO.h
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/31/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <sqlite3.h>

@interface ViolationDAO : NSObject {
    sqlite3 *db;
}

- (NSMutableArray *) getViolations;
- (void) addViolation;

@end
