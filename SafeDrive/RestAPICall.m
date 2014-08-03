//
//  RestAPICall.m
//  SafeDrive
//
//  Created by Rajaraman Raghunathan on 8/2/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "RestAPICall.h"
#import "SpeedLimit.h"
#define APP_ID @"PBdVjN6jd3Q54PcHqBvQ"
#define APP_CODE @"tWTo4JvU225hezjvCPBiog"

@implementation RestAPICall
- (SpeedLimit*)callAPI:(double) lat : (double) longi {
    NSString *urlAsString = [NSString stringWithFormat:@"http://route.st.nlp.nokia.com/routing/6.2/getlinkinfo.json?waypoint=%f,%f&app_id=%@&app_code=%@", lat, longi, APP_ID, APP_CODE];
    NSString *resp = [self makeRestAPICall: urlAsString];
    return [self parseJSONResult:resp];
}

-(NSString*) makeRestAPICall : (NSString*) reqURLStr
{
    NSURLRequest *Request = [NSURLRequest requestWithURL:[NSURL URLWithString: reqURLStr]];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: Request returningResponse: &resp error: &error];
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    return responseString;
}

-(SpeedLimit*) parseJSONResult:(NSString*) response{
    NSError *error;
    SpeedLimit* limit = [[SpeedLimit alloc] init];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    NSArray* address = [[[dict valueForKey:@"Response"] valueForKey:@"Link"] valueForKey:@"Address"];
    NSArray* speed = [[[dict valueForKey:@"Response"] valueForKey:@"Link"] valueForKeyPath:@"SpeedLimit"];
    for (NSDictionary *now in speed) {
        limit.speedLimit = [NSString stringWithFormat:@"%@", now].doubleValue;
    }
    for (NSDictionary *group in address) {
        for (NSString* str in group) {
            if([str isEqual:@"Street"])
                limit.street = [group valueForKeyPath:str];
            if([str isEqual:@"City"])
                limit.city = [group valueForKeyPath:str];
            if([str isEqual:@"County"])
                limit.county = [group valueForKeyPath:str];
            if([str isEqual:@"State"])
                limit.state = [group valueForKeyPath:str];
        }
    }
    return limit;
}
@end
