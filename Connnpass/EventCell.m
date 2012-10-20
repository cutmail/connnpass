//
//  EventCell.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/20.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell {
    UILabel *title;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 20)];
        [title setFont:[UIFont systemFontOfSize:18.]];
        [self addSubview:title];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
