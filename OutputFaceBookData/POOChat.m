//
//  POOChat.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 21.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "POOChat.h"

@implementation POOChat

- (POOChat *)initWithDictionary:(NSDictionary *)dictionary {
    
    self.adminId = [dictionary objectForKey:@"admin_id"];
    self.body = [dictionary objectForKey:@"body"];
    self.chatActive = [dictionary objectForKey:@"chat_active"];
    self.chatId = [dictionary objectForKey:@"chat_id"];
    self.out = [dictionary objectForKey:@"out"];
    self.title = [dictionary objectForKey:@"title"];
    self.date = [dictionary objectForKey:@"date"];
    self.sound = [[dictionary objectForKey:@"sound"] objectForKey:@"push_settings"];
    self.disabledUntil = [[dictionary objectForKey:@"disabled_until"] objectForKey:@"push_settings"];
    
    return self;
}

@end
