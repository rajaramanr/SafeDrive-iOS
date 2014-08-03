//
//  AccidentRegionDAO.h
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/30/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface AccidentRegionDAO : NSObject {
    sqlite3 *db;
}

- (BOOL) getAccidents:(NSString*)county of:(NSString*) state region:(NSString*) street;

@end