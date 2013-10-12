//
//  Event.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize title;
@synthesize detail;
@synthesize eventUrl;

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        eventId       = [dict objectForKey:@"event_id"];
        title         = [dict objectForKey:@"title"];
        detail        = [dict objectForKey:@"catch"];
        _infoHtml      = [dict objectForKey:@"description"];
        eventUrl      = [dict objectForKey:@"event_url"];
        hashTag       = [dict objectForKey:@"hash_tag"];
//        startedAt     = [dict objectForKey:@"started_at"];
//        endedAt       = [dict objectForKey:@"ended_at"];
        limit         = [dict objectForKey:@"limit"];
        eventType     = [dict objectForKey:@"event_type"];
        _address       = [dict objectForKey:@"address"];

        if ([dict objectForKey:@"place"] && [dict objectForKey:@"place"] != [NSNull null]) {
            _place = [dict objectForKey:@"place"];
        } else {
            _place = @"";
        }
        
        _lat           = [dict objectForKey:@"lat"];
        _lon           = [dict objectForKey:@"lon"];
        _ownerId       = [dict objectForKey:@"owner_id"];
        _ownerNickname = [dict objectForKey:@"owner_nickname"];
        accepted      = [dict objectForKey:@"accepted"];
        waiting       = [dict objectForKey:@"waiting"];
        updatedAt     = [dict objectForKey:@"updated_at"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        
        if ([dict objectForKey:@"started_at"] && [dict objectForKey:@"started_at"] != [NSNull null]) {
            NSString *startString = [dict objectForKey:@"started_at"];
            startString = [startString stringByReplacingOccurrencesOfString:@":"
                                                                 withString:@""
                                                                    options:0
                                                                      range:NSMakeRange(22, 1)];
            _startedAt = [formatter dateFromString:startString];
        }
        
        if ([dict objectForKey:@"ended_at"] && [dict objectForKey:@"ended_at"] != [NSNull null]) {
            NSString *endString = [dict objectForKey:@"ended_at"];
            endString = [endString stringByReplacingOccurrencesOfString:@":"
                                                                 withString:@""
                                                                    options:0
                                                                      range:NSMakeRange(22, 1)];
            _endedAt = [formatter dateFromString:endString];
        }
    }
    
    return self;
}

- (NSString *)startedAtString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    return [formatter stringFromDate:_startedAt];
}

- (NSString *)endedAtString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    return [formatter stringFromDate:_endedAt];
}


@end
