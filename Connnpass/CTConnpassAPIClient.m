//
//  CTConnpassAPIClient.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/03/23.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "CTConnpassAPIClient.h"
#import "ASIHttpRequest.h"
#import "Event.h"

#define XXSerialQueueName "me.cutmail.connnpass.SerialQueue"

#define CONNPASS_API_SEARCH @"http://connpass.com/api/v1/event/?count=50&keyword_or=%@"
#define CONNPASS_API_RECENT @"http://connpass.com/api/v1/event/?count=50"

@implementation CTConnpassAPIClient

static CTConnpassAPIClient* _sharedInstance = nil;
static dispatch_queue_t serialQueue;

+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create(XXSerialQueueName, NULL);
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
        }
    });
    return _sharedInstance;
}

- (id)init {
    id __block obj;
    dispatch_sync(serialQueue, ^{
        obj = [super init];
        if (obj) {
            
        }
    });
    self = obj;
    return self;
}

+ (CTConnpassAPIClient *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CTConnpassAPIClient alloc] init];
    });
    return _sharedInstance;
}

- (NSData *)getData:(NSString *)url {
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
//                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
//    NSURLResponse *response;
//    NSError       *error;
//    NSData *result = [NSURLConnection sendSynchronousRequest:request
//                                           returningResponse:&response error:&error];
//    
//    if (result == nil) {
//        NSLog(@"NSURLConnecton error %@", error);
//    }
//    
//    return result;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    return [request responseData];
}

- (NSMutableArray *)fetchRecentEvents {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSString *url = CONNPASS_API_RECENT;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[self getData:url] options:kNilOptions error:&error];
    
    NSArray *eventList = [json objectForKey:@"events"];
    
    for (NSDictionary *eventDic in eventList) {
        Event* event = [[Event alloc] initWithDictionary:eventDic];
        [result addObject:event];
    }
    
    return result;
}

- (NSMutableArray *)searchEventsWithKeyword:(NSString *)keyword {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSString *url = [NSString stringWithFormat:CONNPASS_API_SEARCH, keyword];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[self getData:url] options:kNilOptions error:&error];
    
    NSArray *eventList = [json objectForKey:@"events"];
    
    for (NSDictionary *eventDic in eventList) {
        Event* event = [[Event alloc] initWithDictionary:eventDic];
        [result addObject:event];
    }
    
    return result;
}

@end
