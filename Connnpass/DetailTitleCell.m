//
//  DetailTitleCell.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/08/19.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "DetailTitleCell.h"

@implementation DetailTitleCell
{
    UILabel *_titleLabel;
    UILabel *_detailLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor = [UIColor darkGrayColor];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.numberOfLines = 2;
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEvent:(Event *)event
{
    _titleLabel.text = [event title];
    _detailLabel.text = [event detail];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleLabel sizeToFit];
    [_detailLabel sizeToFit];
    
    CGRect rect;
//    _titleLabel.frame = UIEdgeInsetsInsetRect(CGRectMake(0.0f, 0.0f, self.contentView.frame.size.width - 10, self.contentView.frame.size.height), UIEdgeInsetsMake(0, 5, 5, 5));
    _titleLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 10, 40);
    rect = _titleLabel.frame;
    rect.origin.y += rect.size.height;
    rect.size.width = rect.size.width - 10;
    _detailLabel.frame = rect;
}

@end
