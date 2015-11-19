//
//  POTESTFriend.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 09.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POOTESTFriend : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* thumpnailUrl;

- (POOTESTFriend *) initWithDictionary:(NSDictionary*) dictionary;
- (POOTESTFriend *) initWtithName:(NSString*) name andUrl:(NSString*) thumpnailUrl;

@end
