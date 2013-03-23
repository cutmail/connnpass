//
//  CTConnpassAPIClient.h
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/03/23.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTConnpassAPIClient : NSObject {
    
}

+ (CTConnpassAPIClient *)sharedInstance;

- (NSData *)getData:(NSString *)url;
- (NSMutableArray *)fetchRecentEvents;
- (NSMutableArray *)searchEventsWithKeyword:(NSString *)keyword;

@end
