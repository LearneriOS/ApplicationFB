//
//  POOUserDialog.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 16.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POOChat.h"

@interface POOUserDialog : NSObject

@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) NSInteger mid;
@property (assign, nonatomic) BOOL readFlag;
@property (assign, nonatomic) BOOL outbox;
@property (assign, nonatomic) NSInteger userId;
@property (strong, nonatomic) POOChat *chat;

- (POOUserDialog *)initWithDictionary:(NSDictionary *)dictionary;

@end
