//
//  JSON.M
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/30/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@implementation JSON
@synthesize reader;
//@synthesize counter;
int counter;
static JSON *instance = nil;

+(JSON *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [JSON new];
        }
    }
    return instance;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        reader = [[JSONReader alloc] init];
        counter = 0;
    }
    return self;
}

@end