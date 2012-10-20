//
//  Event.h
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject {
    NSString* _eventId;
    NSString* _title;
    NSString* _catch;
    NSString* _infoHtml;
    NSString* _eventUrl;
    NSString* _hashTag;
    NSString* _startedAt;
    NSString* _endedAt;
    NSString* _limit;
    NSString* _eventType;
    NSString* _address;
    NSString* _place;
    NSString* _lat;
    NSString* _lon;
    NSString* _ownerId;
    NSString* _ownerNickname;
    NSString* _accepted;
    NSString* _waiting;
    NSString* _updatedAt;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *catch;
@property (nonatomic, retain) NSString *eventUrl;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
