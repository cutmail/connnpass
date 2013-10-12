//
//  SimpleAnnotation.h
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/09/17.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SimpleAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) CLLocation *location;
@property (nonatomic, strong) NSString *title;

@end
