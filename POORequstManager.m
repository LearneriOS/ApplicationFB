//
//  POORequstManager.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 20.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "POORequstManager.h"
#import "VkSdk.h"
#import "POOUserDialog.h"
#import "POOVKUserModel.h"
#import "Consts.h"
#import "String+Md5.h"
#import "POOChat.h"

@implementation POORequstManager

#pragma mark - vkSdkRequests
+ (void)getDialogs:(NSInteger)count offset:(NSInteger)offset block:(compliteHendler)block {
    VKRequest *requst = [VKRequest requestWithMethod:@"messages.getDialogs"
                                       andParameters:@{VK_API_COUNT : [NSNumber numberWithInteger:count],
                                                       VK_API_OFFSET : [NSString stringWithFormat:@"%li", offset]}];
    
    NSMutableArray *messages = [NSMutableArray array];
    [requst executeWithResultBlock:^(VKResponse *response) {
        if ([response.json isKindOfClass:[NSDictionary class]]) {
            for (NSDictionary *message in [response.json objectForKey:@"items"]) {
                [messages addObject:[[POOUserDialog alloc]initWithDictionary:[message objectForKey:VK_API_MESSAGE]]];
            }
        }
        
        if (messages.count > 0) {
            block(messages, nil);
        }
    } errorBlock:^(NSError *error) {
        block(nil, error);
    }];
}

+ (void)getUserInfoWithIds:(NSArray *)friends block:(compliteHendler)block {
    VKRequest *request = [VKRequest requestWithMethod:@"users.get"
                                       andParameters:@{VK_API_USER_IDS : [friends componentsJoinedByString:@","],
                                                       VK_API_FIELDS : @[VK_API_ONLINE,
                                                                         VK_API_PHOTO]}];
    
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:friends.count];
    [request executeWithResultBlock:^(VKResponse *response) {
        if ([response.json isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *user in response.json) {
                [users addObject:[[POOVKUserModel alloc]initWithDictionary:user]];
            }
        }
        
        if (users.count > 0) {
            block([users copy], nil);
        }
        
    } errorBlock:^(NSError *error) {
        block(nil, error);
    }];
}

+ (void)getFriendsInfoWithId:(NSString *)userId order:(NSString *)order block:(compliteHendler)block {
    
    NSMutableArray *friends = [NSMutableArray array];
    VKRequest *request = [VKRequest requestWithMethod:@"friends.get"
                                       andParameters:@{VK_API_USER_ID : userId,
                                                       VK_API_ORDER: order,
                                                       VK_API_FIELDS : @[VK_API_ONLINE,
                                                                         VK_API_PHOTO]}];
    
    [request executeWithResultBlock:^(VKResponse *response) {
        if ([response.json isKindOfClass:[NSDictionary class]]) {
            
            for (NSDictionary *friend in [response.json objectForKey:@"items"]) {
                [friends addObject:[[POOVKUserModel alloc]initWithDictionary:friend]];
            }
        }
        
        if (friends.count > 0) {
            block([friends copy], nil);
        }
        
    } errorBlock:^(NSError *error) {
        block(nil, error);
    }];
}

+ (void)getInvitesWith:(BOOL)extended needMutual:(BOOL)needmMtual out:(BOOL)out block:(compliteHendler)block {
    VKRequest *requst = [VKRequest requestWithMethod:@"friends.getRequests"
                                       andParameters:@{VK_API_EXTENDED : [NSString stringWithFormat:@"%d", extended],
                                                       @"need_mutual" : [NSString stringWithFormat:@"%d", needmMtual],
                                                       @"out" : [NSString stringWithFormat:@"%d", out]}];
    
    [requst executeWithResultBlock:^(VKResponse *response) {
        if([response.json isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *ids = [NSMutableArray array];
            for (NSDictionary *invite in [response.json objectForKey:@"items"]) {
                [ids addObject:[invite objectForKey:@"user_id"]];
            }
            
            [[self class] getUserInfoWithIds:ids block:^(NSArray *response, NSError *error) {
                block(response, nil);
            }];
        }
    } errorBlock:^(NSError *error) {
        block(nil, error);
    }];
}

#pragma mark - No VkSdkRequest
- (void)getFriendsWithIdNoVkSdk:(NSString *)id block:(compliteHendler) block {
    NSMutableArray *friends = [NSMutableArray array];

    NSString *stringFriendsRequest = [NSString
                                      stringWithFormat:@"http://api.vk.com/method/friends.get?user_id=%@&order=hints&fields=online,photo_100",
                                      id];

    [self doRequestByStringWithBlock:stringFriendsRequest block:^(NSUInteger code, NSDictionary *response, NSError *error) {
        if (response != nil) {

            for (NSDictionary *user in response) {
                POOVKUserModel *userModel = [[POOVKUserModel alloc] initWithDictionary:user];
                [friends addObject:userModel];
            }
            
            block(friends, nil);
        } else {

            //TODO:make some code
        }
    }];
}

- (void)getDialogsCountWithNoVkSdk:(NSInteger)count accesToken:(NSString *)accesToken block:(compliteHendler)block {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *dialogs = [NSMutableArray array];
    
    NSString *md5 = [[NSString
                      stringWithFormat:@"/method/messages.getDialogs?count=%@&access_token=%@%@",
                      [NSString stringWithFormat:@"%li",count],
                      [userDefault objectForKey:kConstsTokenKey],
                      [userDefault objectForKey:kConstsVkSecretKey]]
                     MD5Hash];


    NSString *message = [NSString stringWithFormat:@"https://api.vk.com/method/messages.getDialogs?count=%@&access_token=%@&sig=%@", [NSString stringWithFormat:@"%li",count], [userDefault objectForKey:kConstsTokenKey], md5];

    [self doRequestWithString:message block:^(NSArray *response, NSError *error) {
        if (error) {
            NSLog(@"Error:%@", error);
        } else {
            for (NSDictionary *dictionary in response) {
                if (![dictionary isKindOfClass:[NSNumber class]]) {

                    POOUserDialog *userDialog = [[POOUserDialog alloc] initWithDictionary:dictionary];

                    if (userDialog) {
                        [dialogs addObject:userDialog];
                    }
                } else {
                    //TODO:make some code
                }
            }
            
            block(dialogs, nil);
        }
    }];
}

- (void)getInvitesWithExtendedNoVkSdk:(BOOL)extended needMutual:(BOOL)needMutual out:(BOOL)out userToken:(NSString *)userToken block:(compliteHendler)block {
    
    NSString *md5 = [[NSString
                      stringWithFormat:@"/method/friends.getRequests?extended=%@&need_mutual=%@&out=%@&access_token=%@%@",
                      [NSString stringWithFormat:@"%d", extended],
                      [NSString stringWithFormat:@"%d", needMutual],
                      [NSString stringWithFormat:@"%d", out],
                      userToken,
                      [[NSUserDefaults standardUserDefaults] objectForKey:kConstsVkSecretKey]]
                     MD5Hash];
    
    NSString *stringFriendsRequest2 = [NSString
                                       stringWithFormat:@"https://api.vk.com/method/friends.getRequests?extended=%@&need_mutual=%@&out=%@&access_token=%@&sig=%@",
                                       [NSString stringWithFormat:@"%d", extended],
                                       [NSString stringWithFormat:@"%d", needMutual],
                                       [NSString stringWithFormat:@"%d", out],
                                       userToken,
                                       md5];
    //TODO:fix
    [self doRequestByStringWithBlock:stringFriendsRequest2 block:^(NSUInteger code, NSDictionary *response, NSError *error) {
        if (response != nil) {
            for (NSDictionary *userId in response) {
                
                NSString *stringFriendsRequest = [NSString
                                                  stringWithFormat:@"http://api.vk.com/method/users.get?user_id=%@&order=hints&fields=online,photo_100",
                                                  [userId objectForKey:@"uid"]];
                //TODO:fix
                [self doRequestByStringWithBlock:stringFriendsRequest block:^(NSUInteger code, NSDictionary *response, NSError *error) {
                    if (response != nil) {
                        
                        NSMutableArray *invates = [NSMutableArray array];
                        for (NSDictionary *inviter in response) {
                            
                            POOVKUserModel *vkUser = [[POOVKUserModel alloc] initWithDictionary:inviter];
                            [invates addObject:vkUser];
                        }
                        
                        block(invates, nil);
                    } else {
                        
                        //TODO:make some code
                    }
                }];
            }
        }
    }];
    
}

#pragma mark - Help dataTask methods
- (void)doRequestWithString:(NSString *)string block:(compliteHendler) block {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (block) {
            if (error) {
                block(nil, error);
            } else {
                NSError *jsonError;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError) {
                    block(nil, jsonError);
                } else {
                    id response = [jsonDictionary objectForKey:@"response"];
                    if ([response isKindOfClass:[NSArray class]]) {
                        block(response, jsonError);
                    }
                }
            }
        }
    }];

    [dataTask resume];
}

- (void)doRequestByStringWithBlock:(NSString *)stringRequest block:(CompletionHandlerWithDictionary)completionHandler {
    NSURL *chekPhoneURL = [NSURL URLWithString:stringRequest];
    NSURLRequest *checkPhoneRequest = [NSURLRequest requestWithURL:chekPhoneURL];
    
    NSURLSessionDataTask *checkPhoneDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:checkPhoneRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            if (error) {
                completionHandler(0, nil, error);
            } else {
                NSError *jsonError;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if(jsonError) {
                    NSLog(@"json error : %@", [jsonError localizedDescription]);
                    id idRespons = [jsonDictionary objectForKey:@"response"];
                    if ([idRespons isKindOfClass:[NSNumber class]]) {
                        
                        completionHandler(((NSNumber *) idRespons).integerValue, nil, jsonError);
                    }
                } else if([jsonDictionary objectForKey:@"response"]) {
                    id idRespons = [jsonDictionary objectForKey:@"response"];
                    if ([idRespons isKindOfClass:[NSNumber class]]) {
                        
                        completionHandler(((NSNumber *) idRespons).integerValue, nil, nil);
                    } else {
                        completionHandler(0, [jsonDictionary objectForKey:@"response"], nil);
                    }
                } else {
                    completionHandler(0, [[jsonDictionary objectForKey:@"error"] objectForKey:@"error_code"], jsonError);
                }
            }
        }
    }];
    
    [checkPhoneDataTask resume];
}

@end
