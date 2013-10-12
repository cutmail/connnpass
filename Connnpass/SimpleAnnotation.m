//
//  SimpleAnnotation.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/09/17.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "SimpleAnnotation.h"

@implementation SimpleAnnotation

#pragma mark -
#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

- (NSString *)title
{
    return _title;
}

@end
