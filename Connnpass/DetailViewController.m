//
//  DetailViewController.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2012/10/10.
//  Copyright (c) 2012年 cutmail. All rights reserved.
//

#import "DetailViewController.h"
#import "GAI.h"
#import "DetailTitleCell.h"
#import "DetailCell.h"
#import "EventInfoCell.h"
#import "MapCell.h"
#import "TUSafariActivity.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    UITableView *_tableView;
}

#pragma mark - Managing the detail item

- (void)loadView {
//    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f)];
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = contentView;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
    web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    web.delegate = self;
    web.scalesPageToFit = YES;
//    [contentView addSubview:web];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 44, self.view.frame.size.width, 44.0f)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:toolbar];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack.png"] style:UIBarButtonItemStylePlain target:web action:@selector(goBack)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavForward.png"] style:UIBarButtonItemStylePlain target:web action:@selector(goForward)];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:web action:@selector(reload)];
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:web action:@selector(stopLoading)];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openShareMenu)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, backButton, flexibleSpace, forwardButton, flexibleSpace, reloadButton, flexibleSpace, stopButton, flexibleSpace, actionButton, flexibleSpace, nil] animated:NO];
}

#pragma - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.event title];
    
    [[GAI sharedInstance].defaultTracker trackView:@"Detail"];

    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.event eventUrl]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -

//- (void)action:(id)sender {
//    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
//                          destructiveButtonTitle:nil
//                               otherButtonTitles: @"Safariで開く", nil];
//    [sheet showInView:self.view];
//}

- (void)openShareMenu {
    NSURL *url = [NSURL URLWithString:[self.event eventUrl]];
    TUSafariActivity *safariActivity = [[TUSafariActivity alloc] init];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url]applicationActivities:@[safariActivity]];
    
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

//#pragma mark - ActionSeet
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
////        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.event eventUrl]]];
//        [self openShareMenu];
//    }
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    sheet = nil;
//}

#pragma mark -
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 90;
        } else if (indexPath.row == 1) {
            return 250;
        } else if (indexPath.row == 5) {
            return 60;
        } else if (indexPath.row == 6) {
            return 180;
        } else {
            return 44;
        }
    } else {
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 5;
    return 8;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"基本情報";
//    }
//    
//    return @"";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titlteCellIdentifier = @"TitleCell";
    static NSString *infoCellIdentifier = @"InfoCell";
    static NSString *startTimeCellIdentifier = @"StartTimeCell";
    static NSString *endTimeCellIdentifier = @"EndTimeCell";
    static NSString *placeCellIdentifier = @"PlaceCell";
    static NSString *addressCellIdentifier = @"AddressCell";
    static NSString *mapCellIdentifier = @"MapCell";
    static NSString *ownerCellIdentifier = @"OwnerCell";
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DetailTitleCell *cell = (DetailTitleCell *)[tableView dequeueReusableCellWithIdentifier:titlteCellIdentifier];
            if (cell == nil) {
                cell = [[DetailTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titlteCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setEvent:_event];
            
            return cell;
        } else if (indexPath.row == 1) {
            EventInfoCell *cell = (EventInfoCell *)[tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
            if (cell == nil) {
                cell = [[EventInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setInfo:[_event infoHtml]];
            
            return cell;
        } else if (indexPath.row == 2) {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:startTimeCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:startTimeCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"開始";
            cell.detailTextLabel.text = [_event startedAtString];
            
            return cell;
        } else if (indexPath.row == 3) {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:endTimeCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:endTimeCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"終了";
            cell.detailTextLabel.text = [_event endedAtString];
            
            return cell;
        } else if (indexPath.row == 4) {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:placeCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:placeCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"会場";
            cell.detailTextLabel.text = [_event place];
            
            return cell;
        } else if (indexPath.row == 5) {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            if (_event.address) {
                cell.textLabel.text = _event.address;
                cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
                cell.textLabel.numberOfLines = 2;
            }
            
            return cell;
        } else if (indexPath.row == 6) {
            MapCell *cell = (MapCell *)[tableView dequeueReusableCellWithIdentifier:mapCellIdentifier];
            if (cell == nil) {
                cell = [[MapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mapCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if ([self.event lat] && [self.event lon]) {
                    [cell setLocationCoordinateWithLatitude:[[self.event lat] doubleValue] longitude:[[self.event lon] doubleValue] placeName:[self.event place]];
                }
            }
            
            return cell;
        } else {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ownerCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ownerCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"管理者";
            
            if (_event.ownerNickname) {
                cell.detailTextLabel.text = _event.ownerNickname;
            }
            
            return cell;
        }
    }
    
    return nil;
}

@end
