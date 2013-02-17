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
        infoHtml      = [dict objectForKey:@"description"];
        eventUrl      = [dict objectForKey:@"event_url"];
        hashTag       = [dict objectForKey:@"hash_tag"];
        startedAt     = [dict objectForKey:@"started_at"];
        endedAt       = [dict objectForKey:@"ended_at"];
        limit         = [dict objectForKey:@"limit"];
        eventType     = [dict objectForKey:@"event_type"];
        address       = [dict objectForKey:@"address"];
        place         = [dict objectForKey:@"place"];
        lat           = [dict objectForKey:@"lat"];
        lon           = [dict objectForKey:@"lon"];
        ownerId       = [dict objectForKey:@"owner_id"];
        ownerNickname = [dict objectForKey:@"owner_nickname"];
        accepted      = [dict objectForKey:@"accepted"];
        waiting       = [dict objectForKey:@"waiting"];
        updatedAt     = [dict objectForKey:@"updated_at"];
    }
    
    return self;
}

@end
