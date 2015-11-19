//
//  POFriendsListViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 09.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POFriendsListViewController.h"
#import "POOTESTFriend.h"
#import "POOTableViewCell.h"

@interface POFriendsListViewController ()

@end

@interface POFriendsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *friends;

@end

@implementation POFriendsListViewController

- (void) initWithFriends:(NSArray *)friendsList {
    _friends = friendsList;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";

    POOTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"POOTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    POOTESTFriend *friend = [self.friends objectAtIndex:indexPath.row];
    [cell configureWithTitleLabel:friend.name andSubtitleLabel:friend.thumpnailUrl];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    POOTESTFriend *friend = [self.friends objectAtIndex:indexPath.row];
    return [POOTableViewCell heightWithPOOFriendText:friend andMaxWidth:CGRectGetWidth(self.tableView.bounds)];
}

@end
