//
//  JSONReader.h
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 7/30/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONReader : NSObject

@property NSMutableArray* jsonObject;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;

-(void) getCurrentStatus;

@end
