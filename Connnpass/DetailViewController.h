//
//  DetailViewController.h
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface DetailViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    UIWebView *web;
    UIActionSheet *sheet;
}

@property (strong, nonatomic) Event *event;

@end
