//
//  MapCell.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/09/02.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "MapCell.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SimpleAnnotation.h"

@implementation MapCell
{
    MKMapView *_mapView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.layer.cornerRadius = 5;
        
        [self addSubview:_mapView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mapView.frame = UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(0, 2, 0, 2));
}

- (void)setLocationCoordinateWithLatitude:(double)latitude longitude:(double)longitude placeName:(NSString *)placeName
{
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude = latitude;
//    coordinate.longitude = longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    SimpleAnnotation *annotation = [[SimpleAnnotation alloc] init];
    annotation.location = location;
    annotation.title = placeName;
    [_mapView addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    CLLocationCoordinate2D centerCoordinate = location.coordinate;
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(centerCoordinate, span);
    
    [_mapView setRegion:coordinateRegion animated:YES];
}

@end
