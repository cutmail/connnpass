//
//  MasterViewController.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "Event.h"

#define CONNPASS_API_SEARCH @"http://connpass.com/api/v1/event/?count=100&keyword_or=%@"
#define CONNPASS_API_RECENT @"http://connpass.com/api/v1/event/?count=100"

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

#pragma mark -
#pragma mark View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    if (![_searchBar.text isEqualToString:@""]) {
        [self loadEventWithKeyword:_searchBar.text];
    } else {
        [self loadNewData];
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return events ? [events count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    Event *event = [events objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = event.title;

    cell.detailTextLabel.text = event.catch;
    return cell;
}

// 表示領域の横幅と文字の長さに応じて行の高さを取得
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
	CGSize bounds = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height);
    //textLabelのサイズ
 	CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font
                                  constrainedToSize:bounds
                                      lineBreakMode:NSLineBreakByTruncatingTail];
    //detailTextLabelのサイズ
	CGSize detailSize = [cell.detailTextLabel.text sizeWithFont: cell.detailTextLabel.font
                                              constrainedToSize: bounds
                                                  lineBreakMode: NSLineBreakByTruncatingTail];
    CGFloat totalHeight = size.height + detailSize.height;
  
//    return totalHeight + 20;
    return (totalHeight < 65) ? 65 : totalHeight + 15;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
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
