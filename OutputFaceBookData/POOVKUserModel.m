//
//  POOVKUserModel.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 14.01.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "POOVKUserModel.h"

@implementation POOVKUserModel

- (POOVKUserModel *) initWithDictionary:(NSDictionary *)dictionary {
    _name = [dictionary objectForKey:@"first_name"];
    _lastName = [dictionary objectForKey:@"last_name"];
    _online = [[dictionary objectForKey:@"online"] integerValue];
    _image = [dictionary objectForKey:@"photo_100"];
    return self;
}

@end
