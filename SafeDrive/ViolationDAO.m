//
//  ViolationDAO.m
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/31/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "ViolationDAO.h"
#import "Violation.h"
#import "AccidentRegionDAO.h"

@implementation ViolationDAO

- (NSMutableArray *)getViolations {
    NSMutableArray *violations = [[NSMutableArray alloc] init];
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
        char *sql = "select * from history";
        sqlite3_stmt *sqlStmt;
        if(sqlite3_prepare(db, sql, -1, &sqlStmt, NULL) != SQLITE_OK) {
            NSLog(@"Problem with prepare statement");
        }
        while(sqlite3_step(sqlStmt) == SQLITE_ROW) {
            NSLog(@"Got a record");
            Violation *violation = [[Violation alloc] init];
            violation.violationId = sqlite3_column_int(sqlStmt, 0);
            violation.dateOfViolation =  [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStmt, 1)];
            violation.count = sqlite3_column_int(sqlStmt, 2);
            NSLog(violation.dateOfViolation);
            NSLog([NSString stringWithFormat:@"%d", violation.count]);
            [violations addObject:violation];
            AccidentRegionDAO *dao = [[AccidentRegionDAO alloc] init];
            [dao getAccidents:@"ALLEGHENY" of:@"Pennsylvania"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception occured due to %@", [exception reason]);
    }
    @finally {
        return violations;
    }
}

- (void)addViolation {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"AccidentDB.sqlite"];
    NSLog(@"DB located");
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
    if (success)
    {
        const char *dbpath = [dbPath UTF8String];
        if (sqlite3_open(dbpath, &db) == SQLITE_OK)
        {
            const char *sql =
            "CREATE TABLE IF NOT EXISTS history (id INTEGER PRIMARY KEY AUTOINCREMENT, date DATE, count Text)";
            sqlite3_stmt *sqlStmt;
            sqlite3_prepare(db, sql, -1, &sqlStmt, NULL);
            if (sqlite3_step(sqlStmt) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            NSDate *date = [[NSDate alloc] init];
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO history (date, count) VALUES (\"%@\", \"%d\")",
                                   date , 1];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(db, insert_stmt,
                               -1, &sqlStmt, NULL);
            if (sqlite3_step(sqlStmt) == SQLITE_DONE)
            {
                NSLog(@"Added Successfully");
            } else {
                NSLog(@"Failed to add");
            }
            sqlite3_finalize(sqlStmt);
            NSLog(@"Created and closing db");
            sqlite3_close(db);
        }
    } else {
        NSLog(@"Something went wrong");
    }
}

@end
