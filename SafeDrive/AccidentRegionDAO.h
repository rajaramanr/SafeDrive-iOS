//
//  AccidentRegionDAO.h
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/30/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

extern NSString *countyName;
extern NSString *stateName;
@interface AccidenRegionDAO : NSObject {
    sqlite3 *db;
}

- (NSMutableArray *) getAccidents:(NSString*)county of:(NSString*) state;

@end