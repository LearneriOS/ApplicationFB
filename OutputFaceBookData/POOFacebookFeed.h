//
//  POOFacebookFeed.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 02.11.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface POOFacebookFeed : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSURL *image;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *timeCreat;

- (POOFacebookFeed *) initWithDictionary:(NSDictionary *) feed;

@end
