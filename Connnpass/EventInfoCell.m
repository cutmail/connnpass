//
//  EventInfoCell.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/09/01.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "EventInfoCell.h"

@implementation EventInfoCell
{
    UIWebView *_webView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _webView = [[UIWebView alloc] init];
        [self.contentView addSubview:_webView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(NSString *)info
{
    [_webView loadHTMLString:info baseURL:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _webView.frame = UIEdgeInsetsInsetRect(CGRectMake(5, 0, self.contentView.frame.size.width - 10, self.contentView.frame.size.height), UIEdgeInsetsMake(5, 5, 5, 5));
}


@end
