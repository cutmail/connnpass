//
//  DetailCell.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/09/01.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell
{
    UILabel *_detailLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.numberOfLines = 3;
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textColor = [UIColor darkGrayColor];
        
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetail:(NSString *)detail
{
    _detailLabel.text = detail;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _detailLabel.frame = UIEdgeInsetsInsetRect(CGRectMake(0, 0, self.contentView.frame.size.width - 10, self.contentView.frame.size.height), UIEdgeInsetsMake(5, 5, 5, 5));
}

@end
