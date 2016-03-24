//
//  POORequstManager.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 20.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^compliteHendler)(NSArray *response, NSError *error);
typedef void (^CompletionHandlerWithDictionary)(NSUInteger code, NSDictionary *response, NSError *error);

@interface POORequstManager : NSObject

+ (void)getDialogs:(NSInteger)count offset:(NSInteger)offset block:(compliteHendler)block;
- (void) getDialogsCountWithNoVkSdk:(NSInteger)cout accesToken:(NSString *)accesToken block:(compliteHendler)block;

+ (void)getUserInfoWithIds:(NSArray *)friends block:(compliteHendler)block;

+ (void)getFriendsInfoWithId:(NSString *)userId order:(NSString *)order block:(compliteHendler)block;
- (void)getFriendsWithIdNoVkSdk:(NSString *)id block:(compliteHendler) block;

+ (void)getInvitesWith:(BOOL)extended needMutual:(BOOL)needmMtual out:(BOOL)out block:(compliteHendler)block;
- (void)getInvitesWithExtendedNoVkSdk:(BOOL)extended needMutual:(BOOL)needMutual out:(BOOL)out userToken:(NSString *)userToken block:(compliteHendler)block;

@end
