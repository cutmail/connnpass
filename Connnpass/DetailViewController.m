//
//  DetailViewController.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f)];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = contentView;
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
    web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    web.delegate = self;
    web.scalesPageToFit = YES;
    [contentView addSubview:web];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.f, 44.0f)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:toolbar];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack.png"] style:UIBarButtonItemStylePlain target:web action:@selector(goBack)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavForward.png"] style:UIBarButtonItemStylePlain target:web action:@selector(goForward)];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:web action:@selector(reload)];
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:web action:@selector(stopLoading)];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, backButton, flexibleSpace, forwardButton, flexibleSpace, reloadButton, flexibleSpace, stopButton, flexibleSpace, actionButton, flexibleSpace, nil] animated:NO];

}

#pragma - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.event title];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Detail"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.event eventUrl]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -

- (void)action:(id)sender {
    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles: @"Safariで開く", nil];
    [sheet showInView:self.view];
}

#pragma mark - ActionSeet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.event eventUrl]]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    sheet = nil;
}

@end
