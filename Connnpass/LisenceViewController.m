//
//  LisenceViewController.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/04/02.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "LisenceViewController.h"

@interface LisenceViewController ()

@end

@implementation LisenceViewController

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    
    lisenceView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    lisenceView.backgroundColor = [UIColor clearColor];
    lisenceView.opaque = NO;
    [contentView addSubview:lisenceView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"ライセンス";
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"License"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"copying.html" ofType:nil];
    
    [lisenceView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
