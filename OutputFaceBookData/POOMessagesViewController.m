//
//  POOMessagesViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 15.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "POOMessagesViewController.h"
#import "Consts.h"
#import "String+Md5.m"
#import "POOUserDialog.h"
#import "POOVKUserModel.h"
#import "POOVkMessageTableViewCell.h"
#import "POORequstManager.h"

static NSString *MessagesIdent = @"MessagesIdent";

@interface POOMessagesViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dialogs;
@property (strong, nonatomic) NSMutableArray *friends;

@end

@implementation POOMessagesViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([POOMessagesViewController class]) bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([POOMessagesViewController class])];
        
        self.dialogs = [NSMutableArray array];
        self.friends = [NSMutableArray array];
        
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([POOVkMessageTableViewCell class])  bundle:nil] forCellReuseIdentifier:MessagesIdent];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getDialogs:50 offset:0];
}

- (void)getDialogs:(NSInteger)count offset:(NSInteger)offset {
    [POORequstManager getDialogs:count offset:offset block:^(NSArray *response, NSError *error) {
        [self.dialogs addObjectsFromArray:response];
        
        [POORequstManager getUserInfoWithIds:[self getUserIds] block:^(NSArray *response, NSError *error) {
            [self.friends removeAllObjects];
            
            [self.friends addObjectsFromArray:response];
            [self.tableView reloadData];
        }];
    }];
}

- (NSArray *)getUserIds {
    NSMutableArray *userdIs = [NSMutableArray arrayWithCapacity:[self.dialogs count]];
    
    for (POOUserDialog *userDialog in self.dialogs) {
        if (!userDialog.chat) {
            [userdIs addObject:[NSNumber numberWithInteger:userDialog.userId]];
        } else {
            [userdIs addObject:userDialog.chat.chatId];
        }
    }

    return userdIs;
}

#pragma mark - TableView delegat and datasourse
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dialogs.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    POOVkMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessagesIdent];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([POOVkMessageTableViewCell class]) owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    POOUserDialog *userDialog = self.dialogs[indexPath.row];
    POOVKUserModel *user = self.friends[indexPath.row];
    
    [cell initWithInterlocutorImage:user.image interlocutorNameAndSecondname:[NSString stringWithFormat:@"%@ %@",user.name, user.lastName] message:userDialog.body online:user.online outbox:userDialog.outbox readFlag:userDialog.readFlag];
    
    if (indexPath.row == self.dialogs.count - 1) {
        [self getDialogs:20 offset:self.dialogs.count];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory worning");
}

//- (void)friendWithId:(NSArray *)usersId {
//    NSString *ids = [usersId componentsJoinedByString:@","];
//    NSString *stringFriendsRequest = [NSString
//                                      stringWithFormat:@"http://api.vk.com/method/users.get?user_ids=%@&fields=online,photo_100",
//                                      ids];
//
//    [self doRequestWithString:stringFriendsRequest block:^(NSArray *response, NSError *error) {
//        if (response) {
//            for (NSDictionary *dictionary in response) {
//                POOVKUserModel *userModel = [[POOVKUserModel alloc] initWithDictionary:dictionary];
//
//                if (userModel) {
//                    [self.friends addObject:userModel];
//                }
//            }
//        } else {
//            //TODO:make some code
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    }];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
