//
//  MasterViewController.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "EventCell.h"
#import "Reachability.h"
#import "CTConnpassAPIClient.h"

#import "Event.h"

@interface MasterViewController () {
}
@end

@implementation MasterViewController {
    UIRefreshControl *_refreshControl;
    UISearchBar *_searchBar;
}

@synthesize events;

#pragma mark -
#pragma mark Connpass

- (NSMutableArray *)fetchRecentEvents {
    CTConnpassAPIClient *client = [CTConnpassAPIClient sharedInstance];
    return [client fetchRecentEventsWithOffset:offset];
}

- (NSMutableArray *)searchEventsWithKeyword:(NSString *)keyword {
    CTConnpassAPIClient *client = [CTConnpassAPIClient sharedInstance];
    return [client searchEventsWithKeyword:keyword];
}

- (void)loadNewData {
    if ([self isConnectNetwork] == NO) {
        [_refreshControl endRefreshing];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                        message:@"ネットワークに接続できません。"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [_refreshControl beginRefreshing];
    
    dotImageView.hidden = YES;
    [activityIndicator startAnimating];
    
    loading = YES;
    
    main_queue = dispatch_get_main_queue();
    timeline_queue = dispatch_queue_create("me.cutmail.connnpass.timeline", NULL);
    
    dispatch_async(timeline_queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        if (offset == 1) {
            [events removeAllObjects];
            [self.tableView reloadData];
        }
        
        [events addObjectsFromArray:[self fetchRecentEvents]];
        
        dispatch_async(main_queue, ^{
            
            if ([self.events count] < 50) {
                hasMoreData = NO;
                dotImageView.hidden = NO;
                [activityIndicator stopAnimating];
            }
            
            loading = NO;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.tableView reloadData];
            [_refreshControl endRefreshing];
        });
    });
}

- (BOOL)isConnectNetwork {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    return reach.isReachable;
}

#pragma mark -
#pragma mark View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 416.0f);
    
    UIView *autoPagarizeView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    autoPagarizeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.tableFooterView = autoPagarizeView;
    
    dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot.png"]];
    dotImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    dotImageView.hidden = YES;
    dotImageView.frame = CGRectMake((autoPagarizeView.frame.size.width - dotImageView.frame.size.width) / 2, (autoPagarizeView.frame.size.height - dotImageView.frame.size.height) / 2, dotImageView.frame.size.width, dotImageView.frame.size.height);
    [autoPagarizeView addSubview:dotImageView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.frame = CGRectMake((autoPagarizeView.frame.size.width - activityIndicator.frame.size.width) / 2, (autoPagarizeView.frame.size.height - activityIndicator.frame.size.height) / 2, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
    [autoPagarizeView addSubview:activityIndicator];
    
//    blockView = [[UIView alloc] initWithFrame:self.view.frame];
//    blockView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    blockView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
//    blockView.alpha = 0.0f;
//    [self.view addSubview:blockView];
//    
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
//    indicator.hidesWhenStopped = YES;
//    indicator.frame = CGRectMake((blockView.frame.size.width - indicator.frame.size.width) / 2, (blockView.frame.size.height - indicator.frame.size.height + 20.0f) / 2, indicator.frame.size.width, indicator.frame.size.height);
//    [blockView addSubview:indicator];
//    
//    [indicator startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新着イベント";
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"RecentEvent"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    events = [[NSMutableArray alloc] initWithCapacity:50];
    
    self.tableView.rowHeight = 65.0f;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(beginReload) forControlEvents:UIControlEventValueChanged];
        
    self.refreshControl = _refreshControl;
    
    offset = 1;
    hasMoreData = YES;

    [self loadNewData];
}


- (void)beginReload
{
    offset = 1;
    [self loadNewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *identifier = @"Cell";
    
    EventCell *cell = (EventCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSUInteger row = indexPath.row;

    Event *event = [events objectAtIndex:row];
    cell.title = event.title;
    cell.description = event.detail;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!hasMoreData || loading) {
        return;
    }
    
    NSUInteger row = indexPath.row;
    if (row == [self.events count] -1) {
        offset += 50;
        [self loadNewData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    Event *event = [events objectAtIndex:row];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.event = event;
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
