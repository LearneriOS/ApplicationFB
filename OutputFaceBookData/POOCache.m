//
//  POOCache.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 23.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOCache.h"

@interface POOCache ()

@property (nonatomic, strong) NSCache *imageCache;

@end

static POOCache *sharedInstance = nil;

@implementation POOCache

+ (POOCache *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[POOCache alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
        [self.imageCache setTotalCostLimit:1024 * 1024];
    }
    return self;
}

- (void)cacheImage:(UIImage*)image forKey:(NSString*)key {
    [self.imageCache setObject:image forKey:key];
    NSLog(@"%@",self.imageCache);
}

- (UIImage*)getCachedImageForKey:(NSString*)key {
    return [self.imageCache objectForKey:key];
}

+ (NSString *) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"Temp"];
    NSLog(@"%@",cacheDirectoryName);
    return cacheDirectoryName;
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[self cacheDirectoryName] stringByAppendingPathComponent:key];
    
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:[self cacheDirectoryName] isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:[self cacheDirectoryName] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSError *error;
    
    [data writeToFile:filename options:NSDataWritingAtomic error:&error];
    
    [[POOCache sharedInstance] cacheImage:[UIImage imageWithData:data] forKey:filename];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *casheTime = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 2];
    NSLog(@"%@",casheTime);
    NSLog(@"%@",[NSDate date]);
    
    [defaults setObject:casheTime forKey:key];
}

+ (UIImage *) objectForKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[self cacheDirectoryName] stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([NSData data] >= [defaults objectForKey:key]) {
            [fileManager removeItemAtPath:filename error:nil];
            [defaults removeObjectForKey:key];
        } else {
            if ([[POOCache sharedInstance] getCachedImageForKey:filename]) {
                return [[POOCache sharedInstance] getCachedImageForKey:filename];
            }
            else {
                NSData *data = [NSData dataWithContentsOfFile:filename];
                return [UIImage imageWithData:data];
            }
        }
    }
    return nil;
}

@end
