//
//  JSON.h
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/30/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONReader.h"

extern int counter;
@interface JSON : NSObject {
    JSONReader *reader;
//NSNumber *counter;
}

@property(nonatomic,retain)JSONReader *reader;
//@property(nonatomic,retain)NSNumber *counter;

+(JSON*)getInstance;

@end
