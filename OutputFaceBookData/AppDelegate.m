//
//  AppDelegate.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 09.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.friendListViewController = [[POFriendsListViewController alloc]init];
    UINavigationController *friendListNavigationConrloller = [[UINavigationController alloc] initWithRootViewController:self.friendListViewController];
    friendListNavigationConrloller.tabBarItem.title = @"Friend list Tab";
    
    self.friendPhotoViewController = [[POOFriendPhotoViewController alloc] init];
    UINavigationController *friedPhotoNavigationController = [[UINavigationController alloc] initWithRootViewController: self.friendPhotoViewController];
    friedPhotoNavigationController.tabBarItem.title = @"Photo collection tab";
    
//    self.webViewController = [[POOWebController alloc] init];
//    UINavigationController *webNavigationController = [[UINavigationController alloc] initWithRootViewController:self.webViewController];
//    webNavigationController.tabBarItem.title = @"Web Controller";
    
    self.feedViewController = [[POOFeedViewController alloc] init];
    UINavigationController *feedNavigattionController = [[UINavigationController alloc] initWithRootViewController:self.feedViewController];
    feedNavigattionController.tabBarItem.title = @"Feed";
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[friendListNavigationConrloller,friedPhotoNavigationController,feedNavigattionController];
    
    self.registrationViewController = [[POORegistrationViewController alloc] init];
    UINavigationController *registrationNavigationController = [[UINavigationController alloc] initWithRootViewController:self.registrationViewController];
    
    POOFacebookData *facebookDateViewController = [[POOFacebookData alloc] init];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:facebookDateViewController];
    [self.window makeKeyAndVisible];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                      didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
