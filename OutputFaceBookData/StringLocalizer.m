//
//  StringLocalizer.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 09.02.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "StringLocalizer.h"

@implementation NSString (Localizer)

- (NSString *) localized {
    return NSLocalizedString(self, nil);
}

@end
