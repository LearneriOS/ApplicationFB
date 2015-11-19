//
//  POFacebookData.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 09.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "AppDelegate.h"
#import "POOFacebookData.h"
#import "POOTESTFriend.h"
#import "POOFacebookFeed.h"


@interface POOFacebookData ()

@property (nonatomic, strong) NSArray *friends;

@end

@implementation POOFacebookData

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatLoginButtotAndAddToSubView];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
#pragma mark - Button cliked
-(void)loginButtonClicked
{
    [self getListOfFriends];
    [self getFeed];
}
#pragma mark - Get feed
- (void) getFeed {
    FBSDKGraphRequest *feedRequest = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me/posts?fields=attachments,message,created_time" parameters:nil];
    
    [feedRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        NSArray *feedArray = [result objectForKey:@"data"];
        NSMutableArray *feeds = [[NSMutableArray alloc] initWithCapacity:feedArray.count];
        
        for (NSDictionary *feed in feedArray) {
            POOFacebookFeed *POOfeed = [[POOFacebookFeed alloc]initWithDictionary:feed];
            [feeds addObject:POOfeed];
        }
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.feedViewController initWithArray:feeds];
    }];
}
#pragma mark - Get friends
- (void) getListOfFriends {
    
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logInWithReadPermissions:@[@"public_profile", @"user_friends",@"user_posts",@"user_about_me"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {

    
            if ([FBSDKAccessToken currentAccessToken]) {
                FBSDKGraphRequest *friendsRequest =
                [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/taggable_friends"
                                                  parameters:nil];
                
                FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
                
    
                [connection addRequest:friendsRequest
                     completionHandler:^(FBSDKGraphRequestConnection* innerConnection, id result, NSError *error) {
                         
                         NSArray *friendList = [result objectForKey:@"data"];
                         
                         NSMutableArray *friends = [NSMutableArray arrayWithCapacity:friendList.count];
                         
                         for (NSDictionary *friendDict in friendList) {
                             POOTESTFriend *friend = [[POOTESTFriend alloc] initWithDictionary:friendDict];
                             [friends addObject:friend];
                         }
                         AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                         [appDelegate.friendListViewController initWithFriends:friends];
                         [appDelegate.friendPhotoViewController initByArray:friends];
                         [appDelegate.window setRootViewController:appDelegate.tabBarController];

                     }];
                [connection start];
            }
        }];
}

#pragma mark - button creat
- (void) creatLoginButtotAndAddToSubView {
    UIButton *myLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor = [UIColor darkGrayColor];
    myLoginButton.frame = CGRectMake(0,0,180,40);
    myLoginButton.center = self.view.center;
    [myLoginButton setTitle: @"Facebook login" forState: UIControlStateNormal];
    
    [myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myLoginButton];
}

@end
