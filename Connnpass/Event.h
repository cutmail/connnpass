//
//  Event.h
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Event : NSObject {
    NSString* eventId;
    NSString* title;
    NSString* detail;
    NSString* infoHtml;
    NSString* eventUrl;
    NSString* hashTag;
    NSString* startedAt;
    NSString* endedAt;
    NSString* limit;
    NSString* eventType;
    NSString* address;
    NSString* place;
    NSString* lat;
    NSString* lon;
    NSString* ownerId;
    NSString* ownerNickname;
    NSString* accepted;
    NSString* waiting;
    NSString* updatedAt;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *eventUrl;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
