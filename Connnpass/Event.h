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
    NSString* eventUrl;
    NSString* hashTag;
    NSString* limit;
    NSString* eventType;
    NSString* accepted;
    NSString* waiting;
    NSString* updatedAt;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *infoHtml;
@property (nonatomic, strong) NSString *eventUrl;
@property (nonatomic, strong) NSDate *startedAt;
@property (nonatomic, strong) NSDate *endedAt;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString* ownerId;
@property (nonatomic, strong) NSString* ownerNickname;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)startedAtString;
- (NSString *)endedAtString;

@end
