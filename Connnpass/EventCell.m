//
//  EventCell.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/20.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import "EventCell.h"

static UIColor *blueColor;
static UIColor *grayColor;
static UIColor *darkGrayColor;

static UIFont *titleFont;
static UIFont *descriptionFont;

@interface EventCellContentView : UIView {
    EventCell *cell;
    BOOL highlighted;
}

@end

@implementation EventCellContentView

+ (void)initialize {
    blueColor = [UIColor colorWithRed:0.0f green:0.2f blue:1.0f alpha:1.0f];
    grayColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
    darkGrayColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
    
    titleFont = [UIFont boldSystemFontOfSize:14.0f];
    descriptionFont = [UIFont systemFontOfSize:13.0f];
}

- (id)initWithFrame:(CGRect)frame cell:(EventCell *)tableCell {
    self = [super initWithFrame:frame];
    if (self) {
        cell = tableCell;
        self.opaque = YES;
        self.backgroundColor = cell.backgroundColor;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    highlighted ? [[UIColor whiteColor] set] : [darkGrayColor set];
    [cell.title drawInRect:CGRectMake(14.0f, 4.0f, cell.frame.size.width - 44.0f, 36.0f) withFont:titleFont lineBreakMode:NSLineBreakByTruncatingTail];
    
    highlighted ? [[UIColor whiteColor] set] : [grayColor set];
    [cell.description drawInRect:CGRectMake(14.0f, 42.0f, cell.frame.size.width - 44.0f, 20.0f) withFont:descriptionFont lineBreakMode:NSLineBreakByTruncatingTail];
}

- (void)setHighlighted:(BOOL)b {
    highlighted = b;
    [self setNeedsDisplay];
}

- (BOOL)isHighlighted {
    return highlighted;
}

@end

@implementation EventCell

@synthesize title;
@synthesize link;
@synthesize description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellContentView = [[EventCellContentView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0f, 1.0f) cell:self       ];
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:cellContentView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [UIView setAnimationsEnabled:NO];
    CGSize contentSize = cellContentView.bounds.size;
    cellContentView.contentStretch = CGRectMake(225.0f / contentSize.width, 0.0f, (contentSize.width - 260.0f) / contentSize.width, 1.0f);
    [UIView setAnimationsEnabled:YES];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    cellContentView.backgroundColor = backgroundColor;
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [cellContentView setNeedsDisplay];
}

@end
