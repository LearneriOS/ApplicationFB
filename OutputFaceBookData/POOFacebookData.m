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
#import "POOLogInVKViewController.h"
#import "vkSdk.h"
#import "StringLocalizer.h"

static NSArray *SCOPE = nil;

@interface POOFacebookData () <VKSdkDelegate, VKSdkUIDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextField *phoneNumber;
@property (nonatomic, strong) UITextField *password;

@property (nonatomic, assign) BOOL authorized;


@end

@implementation POOFacebookData

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    [self creatLoginButtotAndAddToSubView];
    //[VKSdk forceLogout];
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [[VKSdk initializeWithAppId:@"5187957"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
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
    UIButton *facebookLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookLoginButton.backgroundColor = [UIColor darkGrayColor];
    [facebookLoginButton setTitle: [@"facebookLoginButtonText" localized] forState: UIControlStateNormal];
    [facebookLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *vkLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vkLoginButton setBackgroundImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateNormal];
    [vkLoginButton setTitle: [@"vkLoginButtonText" localized] forState: UIControlStateNormal];
    [vkLoginButton addTarget:self action:@selector(vkLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *vkRegistration = [[UIButton alloc] init];
    [vkRegistration setTitle:[@"vkRegistrationText" localized] forState:UIControlStateNormal];
    [vkRegistration setBackgroundImage:[UIImage imageNamed:@"RegButton"] forState:UIControlStateNormal];
    [vkRegistration addTarget:self action:@selector(vkRegistration) forControlEvents:UIControlEventTouchDown];
    
    self.phoneNumber = [[UITextField alloc] init];
    [self.phoneNumber setBorderStyle:UITextBorderStyleRoundedRect];
    [self.phoneNumber setPlaceholder:[@"phoneNumberText" localized]];
    
    self.password = [[UITextField alloc] init];
    [self.password setBorderStyle:UITextBorderStyleRoundedRect];
    [self.password setPlaceholder:[@"passwordText" localized]];
    
    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Header"]];
    header.contentMode = UIViewContentModeScaleToFill;
    UILabel *helloLable = [[UILabel alloc] init];
    helloLable.textColor = [UIColor whiteColor];
    helloLable.text = [@"headerText" localized];
    
    [self.view addSubview:self.phoneNumber];
    [self.view addSubview:self.password];
    [self.view addSubview:facebookLoginButton];
    [self.view addSubview:vkLoginButton];
    [self.view addSubview:vkRegistration];
    [self.view addSubview:header];
    [self.view addSubview:helloLable];
    
    [self creatConstraints:self.phoneNumber password:self.password facebookButton:facebookLoginButton vkButton:vkLoginButton header:header helloLable:helloLable vkRegistration:vkRegistration];
}
#pragma mark - VK buttons
- (void) vkRegistration {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    POORegistrationViewController *registrationViewController = [[POORegistrationViewController alloc] init];
    appDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:registrationViewController];
}

- (void) vkLoginButtonClicked   {
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            POOLogInVKViewController *loginViewController = [[POOLogInVKViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navController animated:YES completion:NULL];
        } else if (error) {
            NSLog(@"Error:%@", error);
        } else {
            self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
            self.webView.delegate = self;
            NSString *stringUrl = [NSString stringWithFormat:@"http://oauth.vk.com/authorize?client_id=5187957&scope=%@&redirect_uri=oauth.vk.com/blank.html&display=touch&response_type=token", [SCOPE componentsJoinedByString:@","]];
            NSURL *url = [NSURL URLWithString:stringUrl];
            //[self.view addSubview:self.webView];
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            [VKSdk authorize:SCOPE];
        }
    }];
}
-(void) webViewDidFinishLoad:(UIWebView *)webView {
    NSString *currentURL = self.webView.request.URL.absoluteString;
    NSLog(@"%@",currentURL);
    NSRange textRange =[[currentURL lowercaseString] rangeOfString:[@"access_token" lowercaseString]];
    if(textRange.location != NSNotFound) {
        NSArray* data = [currentURL componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:[data objectAtIndex:1] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:[data objectAtIndex:3] forKey:@"expires_in"];
        [[NSUserDefaults standardUserDefaults] setObject:[data objectAtIndex:5] forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[data objectAtIndex:7] forKey:@"secret"];
    }
    
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            POOLogInVKViewController *loginViewController = [[POOLogInVKViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navController animated:YES completion:NULL];
        } else if (error) {
            NSLog(@"Error:%@", error);
        }
    }];
}

#pragma mark - Constraints
- (void) creatConstraints:(UITextField *)phoneNumber password:(UITextField *)password facebookButton:(UIButton *)facebookButton vkButton:(UIButton *)vkButton header:(UIImageView *)header helloLable:(UILabel *) lable vkRegistration:(UIButton *)vkRegistration   {
    
    if (self.view.constraints.count == 0) {
        facebookButton.translatesAutoresizingMaskIntoConstraints = NO;
        phoneNumber.translatesAutoresizingMaskIntoConstraints = NO;
        password.translatesAutoresizingMaskIntoConstraints = NO;
        vkButton.translatesAutoresizingMaskIntoConstraints = NO;
        header.translatesAutoresizingMaskIntoConstraints = NO;
        lable.translatesAutoresizingMaskIntoConstraints = NO;
        vkRegistration.translatesAutoresizingMaskIntoConstraints = NO;
        //phoneNumber
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phoneNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:100]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phoneNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:50]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:phoneNumber attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50]];
        //password
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phoneNumber attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:password attribute:NSLayoutAttributeTop multiplier:1.0f constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:password attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:50]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:password attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50]];
        //VK Button
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vkButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:password attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vkButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:50]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:vkButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50]];
        
        //Facebook button
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:facebookButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:vkButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:5]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:facebookButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:50]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:facebookButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50]];
        
        //VK registration Button
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vkRegistration attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:facebookButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vkRegistration attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:50]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:vkRegistration attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50]];
        //header
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:20]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
         //lable
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lable attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lable attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    }
}

- (void) vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self dismissViewControllerAnimated:NO completion:NULL];
        [self.view addSubview:_webView];
    }
     if (result.error) {
        NSLog(@"Error:%@",result.error);
    }
}

- (void)vkSdkUserAuthorizationFailed {
    NSLog(@"vkSdkUserAuthorizationFailed");
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
      NSLog(@"vkSdkNeedCaptchaEnter");
}
@end
