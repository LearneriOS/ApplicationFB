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
#import "StringLocalizer.h"
#import "POOVKTableViewCell.h"
#import "Consts.h"
#import "POORequstManager.h"

typedef void (^CompletionHandler)(NSUInteger code, NSDictionary *response, NSError *error);

@interface POOLogInVKViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISegmentedControl *segmentController;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSMutableArray *groupOfContact;
@property (strong, nonatomic) NSMutableArray *phoneContact;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *namesBySection;
@property (strong, nonatomic) NSArray *sectionSource;
@property (strong, nonatomic)NSArray *invates;

@property (strong, nonatomic) NSString *userId;

@end


@implementation POOLogInVKViewController

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:kConstsUserIdKey];
        self.groupOfContact = [[NSMutableArray alloc] init];
        self.friends = [[NSArray alloc] init];
        self.namesBySection = [[NSMutableDictionary alloc] init];
        self.sectionSource = [[NSMutableArray alloc] init];
        self.phoneContact = [[NSMutableArray alloc] init];
        self.invates = [[NSArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"Header_black"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [self getVKFriends];
    [self creatUI];
    [self getAllContacts];
    [self getInvites];

    self.sectionSource = [self getSortedArrayBySection:_phoneContact];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setBookContact {
    for (CNContact *contact in _groupOfContact) {
        POOPhoneBookContact *phoneContact = [[POOPhoneBookContact alloc] initWithContact:contact];
        [self.phoneContact addObject:phoneContact];
    }
}

- (NSArray *)getSortedArrayBySection:(NSArray *)array {
    [self.namesBySection removeAllObjects];
    NSMutableArray *sectionsKey = [[NSMutableArray alloc] init];
    NSInteger important = 0;

    for (id object in array) {
        if ([object isKindOfClass:[POOPhoneBookContact class]]) {
            [self creatArrayPhoneBookContacts:object sectionsKey:sectionsKey];
        } else {
            [self creatArrayUsersModel:object sectionsKey:sectionsKey important:important];
            important++;
        }
    }
    
    return [self sortedKeys:sectionsKey];
}

- (NSArray *)sortedKeys:(NSMutableArray *)keys {
    [keys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isEqual: @"Important"])
            return NSOrderedSame;
        
        else if (obj1 < obj2 )
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    return [keys copy];
}

- (void)creatArrayUsersModel:(id)object sectionsKey:(NSMutableArray *)sectionsKey important:(NSInteger)important {
    POOVKUserModel *user = (POOVKUserModel *)object;
    NSString *sectionName;

    if (important > 4 || self.segmentController.selectedSegmentIndex == 2) {
        sectionName = [user.name substringToIndex:1];
    } else {
        sectionName = [@"importantKey" localized];
    }
    
    NSMutableArray *nameInSection = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", sectionName];
    NSArray *foundSection = [sectionsKey filteredArrayUsingPredicate:predicate];
    
    if (foundSection.count) {
        nameInSection = [_namesBySection objectForKey:sectionName];
    } else {
        nameInSection = [NSMutableArray array];
        [sectionsKey addObject:sectionName];
    }
    
    [nameInSection addObject:user];
    [_namesBySection setObject:nameInSection forKey:sectionName];
}

- (void)creatArrayPhoneBookContacts:(id)object sectionsKey:(NSMutableArray *)sectionsKey {
    POOPhoneBookContact *contact = (POOPhoneBookContact *)object;
    NSString *sectionName = [contact.name substringToIndex:1];
    NSMutableArray *nameInSection = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", sectionName];
    NSArray *foundSection = [sectionsKey filteredArrayUsingPredicate:predicate];
    
    if (foundSection.count) {
        nameInSection = [_namesBySection objectForKey:sectionName];
    } else {
        nameInSection = [NSMutableArray array];
        [sectionsKey addObject:sectionName];
    }
    
    [nameInSection addObject:contact];
    [_namesBySection setObject:nameInSection forKey:sectionName];
}

#pragma mark - Get Contacts, Friends, Invate methods
- (void)getInvites {
    
    [POORequstManager getInvitesWith:YES needMutual:YES out:YES block:^(NSArray *response, NSError *error) {
        self.invates = response;
    }];
}

- (void)getVKFriends {
    [POORequstManager getFriendsInfoWithId:self.userId order:@"hints" block:^(NSArray *response, NSError *error) {
        self.friends = response;
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

#pragma mark - Table
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionSource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _namesBySection.allKeys.count ;
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
        POOVKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"POOVKTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSString *curentKey = [_sectionSource objectAtIndex:indexPath.section];
        NSArray * currentNames = [_namesBySection objectForKey:curentKey];
        POOPhoneBookContact *phoneContact = [currentNames objectAtIndex:indexPath.row];
        
        [cell configureWithName:phoneContact.name SecondName:phoneContact.secondName];
        
        return cell;
    }

    if (_segmentController.selectedSegmentIndex == 1 || _segmentController.selectedSegmentIndex == 2) {
        POOVKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"POOVKTableViewCell" owner:self options:nil];
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
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = _searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self.view addSubview:_tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
}


- (void)creatSegmentController {
    self.segmentController = [[UISegmentedControl alloc] initWithItems:@[[@"segmentControllerContactText" localized],[@"segmentControllerFriendsText" localized], [@"segmentControllerInvitesText" localized]]];
    
    [self.segmentController setWidth:(self.view.frame.size.width / 3) -10 forSegmentAtIndex:0];
    [self.segmentController setWidth:(self.view.frame.size.width / 3) -10 forSegmentAtIndex:1];
    [self.segmentController setWidth:(self.view.frame.size.width / 3) -10 forSegmentAtIndex:2];
    self.segmentController.tintColor = [UIColor whiteColor];
    [self.segmentController addTarget:self action:@selector(segmentSwithcher:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentController;
    self.segmentController.selectedSegmentIndex = 0;
}

- (void)segmentSwithcher:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        
        self.sectionSource = [self getSortedArrayBySection:_phoneContact];
        [self.tableView reloadData];
    }
    
    if (segment.selectedSegmentIndex == 1) {
        
        self.sectionSource = [self getSortedArrayBySection:_friends];
        [self.tableView reloadData];
    }
    
    if (segment.selectedSegmentIndex == 2) {
        
        self.sectionSource = [self getSortedArrayBySection:_invates];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
