//
//  SearchViewController.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/03/23.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "SearchViewController.h"
#import "CTConnpassAPIClient.h"
#import "DetailViewController.h"

#import "EventCell.h"
#import "Event.h"

@interface SearchViewController ()

@end

@implementation SearchViewController {
    UIRefreshControl *_refreshControl;
    UISearchBar *_searchBar;
}

@synthesize events;

- (NSMutableArray *)searchEventsWithKeyword:(NSString *)keyword {
    CTConnpassAPIClient *client = [CTConnpassAPIClient sharedInstance];
    return [client searchEventsWithKeyword:keyword];
}

- (void)loadEventWithKeyword:(NSString *)keyword {
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *keywords = [keyword componentsSeparatedByString:@" "];
    keyword = [keywords componentsJoinedByString:@","];
    
    [_refreshControl beginRefreshing];
    
    main_queue = dispatch_get_main_queue();
    timeline_queue = dispatch_queue_create("me.cutmail.connnpass.search", NULL);
    
    dispatch_async(timeline_queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.events = [self searchEventsWithKeyword:keyword];
        dispatch_async(main_queue, ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.tableView reloadData];
        });
    });
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

    self.title = @"イベント検索";
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"SearchEvent"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.tableView.rowHeight = 65.0f;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    _searchBar.placeholder = @"キーワードを入力";
    
    self.tableView.tableHeaderView = _searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    Event *event = [events objectAtIndex:row];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.event = event;
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (nil == searchText || [searchText isEqualToString:@""]) {
        [events removeAllObjects];
        [self.tableView reloadData];
    }
}

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

@end
