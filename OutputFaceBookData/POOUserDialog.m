//
//  POOUserDialog.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 16.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "POOUserDialog.h"

@interface POOUserDialog ()

@end

@implementation POOUserDialog

- (POOUserDialog *)initWithDictionary:(NSDictionary *)dictionary {
    
    if (![dictionary isKindOfClass:[NSNull class]]) {
        
        if ([dictionary objectForKey:@"admin_id"]) {
            self.chat = [[POOChat alloc] initWithDictionary:dictionary];
        }
        
        self.body = [dictionary objectForKey:@"body"];
        self.date = [dictionary objectForKey:@"date"];
        self.outbox = ((NSNumber *)[dictionary objectForKey:@"out"]).boolValue;
        self.readFlag = ((NSNumber *)[dictionary objectForKey:@"read_state"]).boolValue;
        
        id userId = [dictionary objectForKey:@"user_id"];
        
        if ([userId isKindOfClass:[NSNumber class]]) {
            self.userId = ((NSNumber*)userId).intValue;
        } else {
            self.userId = 0;
        }
        
        return self;
    }
    
    return nil;
}

@end
