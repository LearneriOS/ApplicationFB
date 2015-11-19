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
+ (CGFloat)heightWithPOOFriendText:(POOTESTFriend *)text andMaxWidth:(CGFloat)maxWidth;

- (void)configureWithTitleLabel:(NSString *)titleString  andSubtitleLabel:(NSString *) SubTitleString;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraintTitle;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraintTitle;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *LabelesConstrain;

@end
