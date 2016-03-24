//
//  POOChat.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 21.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POOChat : NSObject

@property (strong, nonatomic) NSNumber *adminId;
@property (strong, nonatomic) NSNumber *chatId;
@property (strong, nonatomic) NSArray *chatActive;
@property (strong, nonatomic) NSString *disabledUntil;
@property (strong, nonatomic) NSString *body;
@property (assign, nonatomic) BOOL out;
@property (assign, nonatomic) BOOL sound;
@property (assign, nonatomic) BOOL *readState;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSDate *date;

- (POOChat *)initWithDictionary:(NSDictionary *)dictionary;

@end
