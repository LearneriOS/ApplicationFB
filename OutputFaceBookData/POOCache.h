//
//  POOCache.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 23.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface POOCache : NSObject

+ (POOCache *)sharedInstance;
- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getCachedImageForKey:(NSString*)key;
    
+ (NSString*) cacheDirectoryName;
+ (UIImage *) objectForKey:(NSString *)key;
+ (void) setObject:(NSData*)data forKey:(NSString*)key;

@end
