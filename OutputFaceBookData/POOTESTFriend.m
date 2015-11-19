//
//  POTESTFriend.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 09.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOTESTFriend.h"

@implementation POOTESTFriend

- (POOTESTFriend *) initWithDictionary:(NSDictionary*) dictionary {
    POOTESTFriend *friend = [[POOTESTFriend alloc] init];
    friend.name = [dictionary objectForKey:@"name"];
    friend.thumpnailUrl = [[[dictionary objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    return friend;
}

- (POOTESTFriend *) initWtithName:(NSString*) name andUrl:(NSString*) thumpnailUrl {
    _name = name;
    _thumpnailUrl = thumpnailUrl;
    return nil;
}

@end
