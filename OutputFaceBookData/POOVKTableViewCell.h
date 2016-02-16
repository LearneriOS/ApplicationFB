//
//  POOVKTableViewCell.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 16.02.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POOVKTableViewCell : UITableViewCell

+ (instancetype)cell;
+ (NSString *)identifier;
+ (CGFloat)heightWithPOOFriendText:(NSString *)title subTitle:(NSString *)subTitle andMaxWidth:(CGFloat)maxWidth;

- (void)configureWithTitleLabel:(NSString *)titleString  andSubtitleLabel:(NSString *) SubTitleString;
- (void) loadImageFromURL:(NSString *)URL;
- (void)configureWithName:(NSString *)name  SecondName:(NSString *) secondName online:(NSInteger) online image:(NSString *) image;
- (void)configureWithName:(NSString *)name  SecondName:(NSString *) secondName;

@end
