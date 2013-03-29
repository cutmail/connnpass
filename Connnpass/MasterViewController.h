//
//  MasterViewController.h
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController <UISearchBarDelegate> {
    NSMutableArray *events;
    NSInteger offset;
    BOOL loading;
    BOOL hasMoreData;
    
    UIView *blockView;
    UIImageView *dotImageView;
    UIActivityIndicatorView *activityIndicator;
    
    dispatch_queue_t main_queue;
    dispatch_queue_t timeline_queue;
}

@property (nonatomic, retain) NSMutableArray *events;

@end
