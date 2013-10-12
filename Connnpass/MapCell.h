//
//  MapCell.h
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/09/02.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCell : UITableViewCell

- (void)setLocationCoordinateWithLatitude:(double)latitude longitude:(double)longitude placeName:(NSString *)placeName;

@end
