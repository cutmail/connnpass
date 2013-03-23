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

#import "Event.h"

#define CONNPASS_API_SEARCH @"http://connpass.com/api/v1/event/?count=50&keyword_or=%@"
#define CONNPASS_API_RECENT @"http://connpass.com/api/v1/event/?count=50"

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

- (NSData *)getData:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSURLResponse *response;
    NSError       *error;
    NSData *result = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response error:&error];
    
    if (result == nil) {
        NSLog(@"NSURLConnecton error %@", error);
    }
    
    return result;
}

- (NSMutableArray *)fetchRecentEvents {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSString *url = CONNPASS_API_RECENT;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[self getData:url] options:kNilOptions error:&error];
    
    NSArray *eventList = [json objectForKey:@"events"];
    
    for (NSDictionary *eventDic in eventList) {
        Event* event = [[Event alloc] initWithDictionary:eventDic];
        [result addObject:event];
    }
    
    return result;
}

- (NSMutableArray *)searchEventsWithKeyword:(NSString *)keyword {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSString *url = [NSString stringWithFormat:CONNPASS_API_SEARCH, keyword];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[self getData:url] options:kNilOptions error:&error];
    
    NSArray *eventList = [json objectForKey:@"events"];
    
    for (NSDictionary *eventDic in eventList) {
        Event* event = [[Event alloc] initWithDictionary:eventDic];
        [result addObject:event];
    }
    
    return result;
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
    
    main_queue = dispatch_get_main_queue();
    timeline_queue = dispatch_queue_create("me.cutmail.connnpass.timeline", NULL);
    
    dispatch_async(timeline_queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.events = [self fetchRecentEvents];
        dispatch_async(main_queue, ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.tableView reloadData];
            [_refreshControl endRefreshing];
        });
    });
}

- (void)loadEventWithKeyword:(NSString *)keyword {
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *keywords = [keyword componentsSeparatedByString:@" "];
    keyword = [keywords componentsJoinedByString:@","];
    
    [_refreshControl beginRefreshing];
    
    main_queue = dispatch_get_main_queue();
    timeline_queue = dispatch_queue_create("me.cutmail.connnpass.timeline", NULL);
    
    dispatch_async(timeline_queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.events = [self searchEventsWithKeyword:keyword];
        dispatch_async(main_queue, ^{
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 65.0f;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    _searchBar.placeholder = @"キーワードを入力";
    
    self.tableView.tableHeaderView = _searchBar;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(beginReload) forControlEvents:UIControlEventValueChanged];
        
    self.refreshControl = _refreshControl;

    [self loadNewData];
}

- (void)beginReload
{
    NSLog(@"text: %@", _searchBar.text);
    
    if (!_searchBar.text || [_searchBar.text isEqualToString:@""]) {
        [self loadNewData];
    } else {
        [self loadEventWithKeyword:_searchBar.text];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

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
//    cell.title = @"title";
//    cell.description = @"description";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    Event *event = [events objectAtIndex:row];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.event = event;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [searchBar resignFirstResponder];
    
    [self loadEventWithKeyword:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *vc = (DetailViewController *)[segue destinationViewController];
        vc.event = [events objectAtIndex:indexPath.row];
    }
}

@end
