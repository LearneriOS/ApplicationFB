//
//  POOPhoneBookModel.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 19.01.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <Contacts/Contacts.h>

@interface POOPhoneBookContact : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *secondName;
@property(nonatomic, strong) NSMutableDictionary *phones;
@property(nonatomic, strong) NSArray *emails;

- (POOPhoneBookContact *) initWithContact:(CNContact *)contact;

@end
