//
//  Event.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import "Event.h"

@implementation Event

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _eventId       = [dict objectForKey:@"event_id"];
    _title         = [dict objectForKey:@"title"];
    _catch         = [dict objectForKey:@"catch"];
    _infoHtml      = [dict objectForKey:@"description"];
    _eventUrl      = [dict objectForKey:@"event_url"];
    _hashTag       = [dict objectForKey:@"hash_tag"];
    _startedAt     = [dict objectForKey:@"started_at"];
    _endedAt       = [dict objectForKey:@"ended_at"];
    _limit         = [dict objectForKey:@"limit"];
    _eventType     = [dict objectForKey:@"event_type"];
    _address       = [dict objectForKey:@"address"];
    _place         = [dict objectForKey:@"place"];
    _lat           = [dict objectForKey:@"lat"];
    _lon           = [dict objectForKey:@"lon"];
    _ownerId       = [dict objectForKey:@"owner_id"];
    _ownerNickname = [dict objectForKey:@"owner_nickname"];
    _accepted      = [dict objectForKey:@"accepted"];
    _waiting       = [dict objectForKey:@"waiting"];
    _updatedAt     = [dict objectForKey:@"updated_at"];
    
    return self;
}

@end
