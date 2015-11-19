//
//  POOCollectionViewCell.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 19.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOCollectionViewCell.h"
#import "String+Md5.h"
#import "POOCache.h"

@interface POOCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation POOCollectionViewCell

- (void)configureWithThumbnailUrl:(NSString *)thumbnailUrl {
    if (thumbnailUrl) {
        NSURL *imageURL = [NSURL URLWithString:thumbnailUrl];
        NSString *key = [thumbnailUrl MD5Hash];
        UIImage *image = [POOCache objectForKey:key];
        if (image) {
            self.thumbnailImageView.image = image;
        }
        [self.activityView startAnimating];
        
        typeof(self) __weak weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            UIImage *img = [[UIImage alloc] initWithData:data];
            [[POOCache sharedInstance] cacheImage:img forKey:key];
            [POOCache setObject:data forKey:key];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.thumbnailImageView.image = img;
                [weakSelf.activityView stopAnimating];
            });
        });
    }
}

@end
