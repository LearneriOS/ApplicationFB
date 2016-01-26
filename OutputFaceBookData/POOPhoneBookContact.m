//
//  POOPhoneBookModel.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 19.01.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "POOPhoneBookContact.h"

@implementation POOPhoneBookContact

- (POOPhoneBookContact *) initWithContact:(CNContact *)contact {
    _phones = [NSMutableDictionary dictionary];
    _name = contact.givenName;
    _secondName = contact.familyName;
    _emails = contact.emailAddresses;
    for (CNLabeledValue *lableValue in contact.phoneNumbers) {
        NSString *type = [[lableValue.label substringFromIndex:4] substringToIndex:lableValue.label.length - 8];
        CNPhoneNumber *phoneNumber = lableValue.value;
        
        [_phones setObject:phoneNumber.stringValue forKey:type];
    }
    
    return self;
}

@end
