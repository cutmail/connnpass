//
//  EventCell.h
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/20.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;

@interface EventCell : UITableViewCell {
    UIView *cellContentView;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *description;

@end
