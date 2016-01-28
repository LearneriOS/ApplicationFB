//
//  POOLogInVKViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 14.01.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <Contacts/Contacts.h>
#import "POOLogInVKViewController.h"
#import "POOVKUserModel.h"
#import "POOTableViewCell.h"
#import "POOPhoneBookContact.h"
#import "POOVKUserModel.h"
#import "POOContactInfoViewController.h"
#import "String+Md5.h"

typedef void (^CompletionHandler)(NSDictionary *response, NSError *error);

static const NSString *USERID;
static const NSString *USER_TOKEN;

@interface POOLogInVKViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISegmentedControl *segmentController;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *groupOfContact;
@property (nonatomic, strong) NSMutableArray *phoneContact;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *namesBySection;
@property (nonatomic, strong) NSArray *sectionSource;
@property (nonatomic, strong) NSMutableArray *invates;

@end


@implementation POOLogInVKViewController

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        USERID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        USER_TOKEN = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        _groupOfContact = [[NSMutableArray alloc] init];
        _friends = [[NSMutableArray alloc] init];
        _namesBySection = [[NSMutableDictionary alloc] init];
        _sectionSource = [[NSMutableArray alloc] init];
        _phoneContact = [[NSMutableArray alloc] init];
        _invates = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"Header_black@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [self getVKFriends];
    [self creatUI];
    [self getAllContacts];
    [self getInvites];

    _sectionSource = [self getSortedArrayBySection:_phoneContact];
}

- (void)setBookContact {
    for (CNContact *contact in _groupOfContact) {
        POOPhoneBookContact *phoneContact = [[POOPhoneBookContact alloc] initWithContact:contact];
        [_phoneContact addObject:phoneContact];
    }
}

- (NSArray *)getSortedArrayBySection:(NSArray *)array {
    [_namesBySection removeAllObjects];
    NSMutableArray *sectionKey = [[NSMutableArray alloc] init];
    
    for (id object in array) {
        if ([object isKindOfClass:[POOPhoneBookContact class]]) {
            POOPhoneBookContact *contact = (POOPhoneBookContact *)object;
            NSString *sectionName = [contact.name substringToIndex:1];
            NSMutableArray *nameInSection = nil;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", sectionName];
            NSArray *foundSection = [sectionKey filteredArrayUsingPredicate:predicate];
            
            if (foundSection.count) {
                nameInSection = [_namesBySection objectForKey:sectionName];
            } else {
                nameInSection = [NSMutableArray array];
                [sectionKey addObject:sectionName];
            }
            
            [nameInSection addObject:contact];
            [_namesBySection setObject:nameInSection forKey:sectionName];
        } else {
            POOVKUserModel *user = (POOVKUserModel *)object;
            NSString *sectionName = [user.name substringToIndex:1];
            NSMutableArray *nameInSection = nil;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", sectionName];
            NSArray *foundSection = [sectionKey filteredArrayUsingPredicate:predicate];
            
            if (foundSection.count) {
                nameInSection = [_namesBySection objectForKey:sectionName];
            } else {
                nameInSection = [NSMutableArray array];
                [sectionKey addObject:sectionName];
            }
            
            [nameInSection addObject:user];
            [_namesBySection setObject:nameInSection forKey:sectionName];
        }
    }
    
    return [sectionKey sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark - Get Contacts, Friends, Invate methods
- (void)getInvites {
    NSString *md5 = [[NSString
                      stringWithFormat:@"/method/friends.getRequests?extended=1&need_mutual=1&out=1&access_token=%@%@",
                      USER_TOKEN,[[NSUserDefaults standardUserDefaults] objectForKey:@"secret"]]
                      MD5Hash];
    
    NSString *stringFriendsRequest2 = [NSString
                                       stringWithFormat:@"https://api.vk.com/method/friends.getRequests?extended=1&need_mutual=1&out=1&access_token=%@&sig=%@",
                                       USER_TOKEN, md5];
    
    [self doRequestByStringWithBlock:stringFriendsRequest2 block:^(NSDictionary *response, NSError *error) {
        for (NSDictionary *userId in response) {
            NSString *stringFriendsRequest = [NSString
                                              stringWithFormat:@"http://api.vk.com/method/users.get?user_id=%@&order=hints&fields=online,photo_100",
                                              [userId objectForKey:@"uid"]];
            
            [self doRequestByStringWithBlock:stringFriendsRequest block:^(NSDictionary *response, NSError *error) {
                for (NSDictionary *inviter in response) {
                    POOVKUserModel *vkUser = [[POOVKUserModel alloc] initWithDictionary:inviter];
                    [_invates addObject:vkUser];
                }
            }];
        }
    }];
}

- (void)getAllContacts {
    if ([CNContactStore class]) {
        CNContactStore *addresBook = [[CNContactStore alloc] init];
        
        NSArray *keysToFetch = @[CNContactEmailAddressesKey,
                                 CNContactFamilyNameKey,
                                 CNContactGivenNameKey,
                                 CNContactPhoneNumbersKey,
                                 CNContactPostalAddressesKey,
                                 CNContactMiddleNameKey,
                                 CNContactPreviousFamilyNameKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        
        [addresBook enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            [_groupOfContact addObject:contact];
        }];
        
        [self setBookContact];
    }
}

- (void)getVKFriends {
    NSString *stringFriendsRequest = [NSString
                                      stringWithFormat:@"http://api.vk.com/method/friends.get?user_id=%@&order=hints&fields=online,photo_100",
                                      USERID];
    
    [self doRequestByStringWithBlock:stringFriendsRequest block:^(NSDictionary *response, NSError *error) {
        for (NSDictionary *user in response) {
            POOVKUserModel *userModel = [[POOVKUserModel alloc] initWithDictionary:user];
            [_friends addObject:userModel];
        }
    }];
}

#pragma mark - Request
- (void)doRequestByStringWithBlock:(NSString *)stringRequest block:(void (^)(NSDictionary *response, NSError *error))completionHandler {
    NSURL *chekPhoneURL = [NSURL URLWithString:stringRequest];
    NSURLRequest *checkPhoneRequest = [NSURLRequest requestWithURL:chekPhoneURL];
    
    NSURLSessionDataTask *checkPhoneDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:checkPhoneRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            } else {
                NSError *jsonError;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if(jsonError) {
                    NSLog(@"json error : %@", [jsonError localizedDescription]);
                } else if([jsonDictionary objectForKey:@"response"]) {
                    completionHandler([jsonDictionary objectForKey:@"response"], jsonError);
                } else {
                    completionHandler([[jsonDictionary objectForKey:@"error"] objectForKey:@"error_code"], jsonError);
                }
            }
        }
    }];
    
    [checkPhoneDataTask resume];
}

#pragma mark - Table
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionSource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _namesBySection.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *currentKey = [_sectionSource objectAtIndex:section];
    NSArray *currentNames = [_namesBySection objectForKey:currentKey];
    
    return currentNames.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_sectionSource objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"identefire_name";
    
    if (_segmentController.selectedSegmentIndex == 0) {
        POOTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"POOTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSString *curentKey = [_sectionSource objectAtIndex:indexPath.section];
        NSArray * currentNames = [_namesBySection objectForKey:curentKey];
        POOPhoneBookContact *phoneContact = [currentNames objectAtIndex:indexPath.row];
        
        [cell configureWithName:phoneContact.name SecondName:phoneContact.secondName];
        
        return cell;
    }

    if (_segmentController.selectedSegmentIndex == 1 || _segmentController.selectedSegmentIndex == 2) {
        POOTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"POOTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSString *curentKey = [_sectionSource objectAtIndex:indexPath.section];
        NSArray * currentNames = [_namesBySection objectForKey:curentKey];
        POOVKUserModel *user = [currentNames objectAtIndex:indexPath.row];
        
        [cell configureWithName:user.name SecondName:user.lastName online:user.online image:user.image];
        
        return cell;
    }
    
    return NULL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_segmentController.selectedSegmentIndex == 0) {
        NSString *curentKey = [_sectionSource objectAtIndex:indexPath.section];
        NSArray * currentNames = [_namesBySection objectForKey:curentKey];
        POOPhoneBookContact *phoneContact = [currentNames objectAtIndex:indexPath.row];
        
        POOContactInfoViewController *contactInfoController = [[POOContactInfoViewController alloc] initWithName:phoneContact.name lastName:phoneContact.secondName phones:phoneContact.phones];
        
        [self.navigationController pushViewController:contactInfoController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *curentKey = [_sectionSource objectAtIndex:indexPath.section];
    NSArray * currentNames = [_namesBySection objectForKey:curentKey];
    POOVKUserModel *friend = [currentNames objectAtIndex:indexPath.row];
    
    return [POOTableViewCell heightWithPOOFriendText:friend.name subTitle:@"oline" andMaxWidth:CGRectGetWidth(_tableView.bounds)];
}

#pragma mark - Search Delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    NSMutableArray *filtreadArray = [NSMutableArray array];
    
    if (![searchString isEqualToString:@""]) {
        if (_segmentController.selectedSegmentIndex == 0) {
            for (POOPhoneBookContact *contact in _phoneContact) {
                if ([contact.name localizedCaseInsensitiveContainsString:searchString] || [contact.secondName localizedCaseInsensitiveContainsString:searchString]) {
                    [filtreadArray addObject:contact];
                }
            }
        } else {
            for (POOVKUserModel *friend in _friends) {
                if ([friend.name localizedCaseInsensitiveContainsString:searchString] || [friend.lastName localizedCaseInsensitiveContainsString:searchString]) {
                    [filtreadArray addObject:friend];
                }
            }
        }
        _sectionSource = [self getSortedArrayBySection:filtreadArray];
    } else {
        if (_segmentController.selectedSegmentIndex == 0) {
            _sectionSource = [self getSortedArrayBySection:_phoneContact];
        } else {
            _sectionSource = [self getSortedArrayBySection:_friends];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - UI
- (void)creatUI {
    [self creatSegmentController];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    
    _searchController.searchBar.delegate = self;
    
    _tableView.tableHeaderView = _searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self.view addSubview:_tableView];
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
}


- (void)creatSegmentController {
    _segmentController = [[UISegmentedControl alloc] initWithItems:@[@"Контакты", @"Друзья", @"Заявки"]];
    
    [_segmentController setWidth:(self.view.frame.size.width / 3) -10 forSegmentAtIndex:0];
    [_segmentController setWidth:(self.view.frame.size.width / 3) -10 forSegmentAtIndex:1];
    [_segmentController setWidth:(self.view.frame.size.width / 3) -10 forSegmentAtIndex:2];
    _segmentController.tintColor = [UIColor whiteColor];
    [_segmentController addTarget:self action:@selector(segmentSwithcher:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentController;
    _segmentController.selectedSegmentIndex = 0;
}

- (void)segmentSwithcher:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        _sectionSource = [self getSortedArrayBySection:_phoneContact];
        [_tableView reloadData];
    }
    
    if (segment.selectedSegmentIndex == 1) {
        _sectionSource = [self getSortedArrayBySection:_friends];
        [_tableView reloadData];
    }
    
    if (segment.selectedSegmentIndex == 2) {
        _sectionSource = [self getSortedArrayBySection:_invates];
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
