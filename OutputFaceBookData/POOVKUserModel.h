//
//  POOVKUserModel.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 14.01.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POOVKUserModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSInteger online;

//+ (instancetype) sharesInstance;
- (POOVKUserModel *) initWithDictionary:(NSDictionary *)dictionary;


@end
