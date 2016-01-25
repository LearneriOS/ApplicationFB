//
//  TableViewCell.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 12.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POOTESTFriend.h"

@interface POOTableViewCell : UITableViewCell

+ (instancetype)cell;
+ (NSString *)identifier;
+ (CGFloat)heightWithPOOFriendText:(NSString *)title subTitle:(NSString *)subTitle andMaxWidth:(CGFloat)maxWidth;

- (void)configureWithTitleLabel:(NSString *)titleString  andSubtitleLabel:(NSString *) SubTitleString;
- (void) loadImageFromURL:(NSString *)URL;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraintTitle;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraintTitle;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *LabelesConstrain;

@end

@interface POOTableViewCell (NewInitMethod)

- (void)configureWithName:(NSString *)name  SecondName:(NSString *) secondName online:(NSInteger) online image:(NSString *) image;
- (void)configureWithName:(NSString *)name  SecondName:(NSString *) secondName;

@end



