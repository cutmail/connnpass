//
//  SettingsViewController.m
//  Connnpass
//
//  Created by Tatsuya Arai on 2013/03/27.
//  Copyright (c) 2013年 cutmail. All rights reserved.
//

#import "SettingsViewController.h"
#import "AAMFeedbackViewController.h"
#import "LisenceViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"init");
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma - View lifecycle

- (void)loadView
{
    [super loadView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"設定";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"iConnpassについて";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *lisenceCellIdentifier = @"LisenceCell";
        cell = [tableView dequeueReusableCellWithIdentifier:lisenceCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lisenceCellIdentifier];
            cell.textLabel.text = @"ライセンス情報";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.row == 1) {
        static NSString *inquiryCellIdentifier = @"InquiryCell";
        cell = [tableView dequeueReusableCellWithIdentifier:inquiryCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inquiryCellIdentifier];
            cell.textLabel.text = @"お問い合わせ/ご要望";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        static NSString *aboutCellIdentifier = @"AboutCell";
        cell = [tableView dequeueReusableCellWithIdentifier:aboutCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:aboutCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"バージョン";
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        LisenceViewController *lisenceViewController = [[LisenceViewController alloc] init];
        [self.navigationController pushViewController:lisenceViewController animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        AAMFeedbackViewController *vc = [[AAMFeedbackViewController alloc] init];
        vc.toRecipients = [NSArray arrayWithObject:@"cutmail.app@gmail.com"];
        vc.ccRecipients = nil;
        vc.bccRecipients = nil;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
    }
}

@end
