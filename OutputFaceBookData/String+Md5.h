//
//  String+Md5.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 23.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *) MD5Hash;

@end
