//
//  AccidentRegionDAO.m
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/30/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//
#import "AccidentRegionDAO.h"
#import "AccidentRegion.h"

@implementation AccidentRegionDAO

// This function provides
- (NSMutableArray *) getAccidents:(NSString*)county of:(NSString*) state {
    NSMutableArray *accidentAtThatRegion = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"AccidentDB.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success) {
            NSLog(@"Cannot locate database at '%@'", dbPath);
        }
        NSLog(@"Found DB file");
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        char *sql = "select * from accidentInfo where stateId = (select id from stateInfo where state = ?) and countyId = (select id from countyInfo where county = ?)";
        sqlite3_stmt *sqlStmt;
        if(sqlite3_prepare(db, sql, -1, &sqlStmt, NULL) != SQLITE_OK) {
            NSLog(@"Problem with prepare statement");
        } else {
            NSLog(@"COming to prepare our thala");
            sqlite3_bind_text(sqlStmt, 1, [state UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlStmt, 2, [county UTF8String], -1, SQLITE_TRANSIENT);
        }
        while(sqlite3_step(sqlStmt) == SQLITE_ROW) {
            AccidentRegion *region = [[AccidentRegion alloc] init];
            region.regionId = sqlite3_column_int(sqlStmt, 0);
            region.regionName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStmt, 1)];
            region.stateName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStmt, 3)];
            region.countyName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStmt, 2)];
            NSLog(region.regionName);
            [accidentAtThatRegion addObject:region];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception occured due to %@", [exception reason]);
    }
    @finally {
        return accidentAtThatRegion;
    }
}

@end

