//
//  TableViewCell.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 12.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOTableViewCell.h"
#import "POOCache.h"
#import "String+Md5.h"


@interface POOTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *photo;

@end

@implementation POOTableViewCell (NewInitMethod)

- (void)configureWithName:(NSString *)name  SecondName:(NSString *) secondName online:(NSInteger) online image:(NSString *) image {
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",name, secondName];
    if (online == 1) {
        self.subtitleLabel.text = @"online";
    } else {
        self.subtitleLabel.text = @"";
    }
    
    [self loadImageFromURL:image];
}

- (void)configureWithName:(NSString *)name  SecondName:(NSString *) secondName {
    self.titleLabel.text = name;
    if (secondName.length > 0) {
        self.subtitleLabel.text = [NSString stringWithFormat:@"%@ %@", name, secondName];
    }
}

@end

@implementation POOTableViewCell

+(instancetype) cell {
    return [[[[self class] cellNib]instantiateWithOwner:nil options:nil] firstObject];
}

+ (UINib *)cellNib {
    return [UINib nibWithNibName:[[self class] identifier] bundle:nil];
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)heightWithPOOFriendText:(NSString *)title subTitle:(NSString *)subTitle andMaxWidth:(CGFloat)maxWidth {
    
    static UILabel *titleLabel = nil;
    static UILabel *subtitleLabel = nil;
    
    if (!titleLabel || !subtitleLabel) {
        titleLabel = [[UILabel alloc] init];
        subtitleLabel = [[UILabel alloc] init];
    }
    
    titleLabel.text = title;
    subtitleLabel.text = subTitle;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSRange fullRangeTitle = NSMakeRange(0, titleLabel.attributedText.length);
    NSRange fullRangeSubTitle = NSMakeRange(0, subtitleLabel.attributedText.length);
    
    NSMutableAttributedString *attributedTextTitle = [[NSMutableAttributedString alloc] initWithAttributedString:titleLabel.attributedText];
    [attributedTextTitle addAttributes:@{ NSParagraphStyleAttributeName:style } range:fullRangeTitle];
    
    NSMutableAttributedString *attributedTextSubTitle = [[NSMutableAttributedString alloc] initWithAttributedString:subtitleLabel.attributedText];
    [attributedTextSubTitle addAttributes:@{ NSParagraphStyleAttributeName:style } range:fullRangeSubTitle];
    
    return  (attributedTextTitle.length > 225) ? [attributedTextTitle
             boundingRectWithSize: CGSizeMake(maxWidth, MAXFLOAT)
             options: NSStringDrawingUsesLineFragmentOrigin
             context: nil].size.height +
             [attributedTextSubTitle
             boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
             options: NSStringDrawingUsesLineFragmentOrigin
              context: nil].size.height +120 : [attributedTextTitle
                                                boundingRectWithSize: CGSizeMake(maxWidth, MAXFLOAT)
                                                options: NSStringDrawingUsesLineFragmentOrigin
                                                context: nil].size.height +
                                                [attributedTextSubTitle
                                                 boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                                 options: NSStringDrawingUsesLineFragmentOrigin
                                                 context: nil].size.height +15;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)configureWithTitleLabel:(NSString *)titleString  andSubtitleLabel:(NSString *) SubTitleLabel {
    self.titleLabel.text = titleString;
    NSLog(@"%@",_titleLabel.text);
    self.subtitleLabel.text = SubTitleLabel;
    
    [self loadImageFromURL:SubTitleLabel];
}

- (void) loadImageFromURL:(NSString *)URL {
    NSURL *imageURL = [NSURL URLWithString:URL];
    NSString *key = [URL MD5Hash];
    UIImage *image = [POOCache objectForKey:key];
    if (image) {
        self.imageView.image = image;
    } else { 
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:data];
            [POOCache setObject:data forKey:key];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
                [self layoutSubviews];
            });
        });
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    
    self.heightConstraintTitle.constant = [[self class] heightWithPOOFriendText:_titleLabel.text subTitle:_subtitleLabel.text andMaxWidth:CGRectGetWidth(self.bounds)];
    self.widthConstraintTitle.constant = CGRectGetWidth(self.bounds);
    
    self.heightConstraint.constant = [[self class] heightWithPOOFriendText:_titleLabel.text subTitle:_subtitleLabel.text andMaxWidth:CGRectGetWidth(self.bounds)];
    self.widthConstraint.constant = CGRectGetWidth(self.bounds);
    
    [self updateFocusIfNeeded];
//    if (self.constraints.count == 0) {
//        _photo.translatesAutoresizingMaskIntoConstraints = NO;
//        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        // photo Constrains
//        NSLayoutConstraint *photoTopConstraint = [NSLayoutConstraint
//                                                  constraintWithItem:_photo
//                                                  attribute:NSLayoutAttributeTop
//                                                  relatedBy:NSLayoutRelationEqual
//                                                  toItem:self attribute:NSLayoutAttributeTop
//                                                  multiplier:1 constant:0];
//        NSLayoutConstraint *photoLeadingConstraint = [NSLayoutConstraint
//                                                      constraintWithItem:_photo
//                                                      attribute:NSLayoutAttributeTrailing
//                                                      relatedBy:NSLayoutRelationEqual
//                                                      toItem:self
//                                                      attribute:NSLayoutAttributeLeading
//                                                      multiplier:1 constant:0];
//        
//        NSLayoutConstraint *photoBottomConstraint = [NSLayoutConstraint
//                                                     constraintWithItem:self
//                                                     attribute:NSLayoutAttributeBottom
//                                                     relatedBy:NSLayoutRelationEqual
//                                                     toItem:_photo
//                                                     attribute:NSLayoutAttributeBottom
//                                                     multiplier:1 constant:0];
//        // titleLable Constrains
//        NSLayoutConstraint *titleLableTopConstraint = [NSLayoutConstraint
//                                                       constraintWithItem:self
//                                                       attribute:NSLayoutAttributeTop
//                                                       relatedBy:NSLayoutRelationEqual
//                                                       toItem:_titleLabel
//                                                       attribute:NSLayoutAttributeTop
//                                                       multiplier:1 constant:50];
//        
//        NSLayoutConstraint *titleLableLeatdingConstraint = [NSLayoutConstraint
//                                                            constraintWithItem:_titleLabel
//                                                            attribute:NSLayoutAttributeLeading
//                                                            relatedBy:NSLayoutRelationEqual
//                                                            toItem:_photo
//                                                            attribute:NSLayoutAttributeTrailing
//                                                            multiplier:1 constant:75];
//        
//        NSLayoutConstraint *titleLableHeight = [NSLayoutConstraint
//                                                constraintWithItem:_titleLabel
//                                                attribute:NSLayoutAttributeHeight
//                                                relatedBy:NSLayoutRelationEqual
//                                                toItem:nil
//                                                attribute:NSLayoutAttributeNotAnAttribute
//                                                multiplier:1 constant:[[self class] heightWithPOOFriendText:_titleLabel.text subTitle:_subtitleLabel.text andMaxWidth:CGRectGetWidth(self.bounds)]];
//        NSLayoutConstraint *titleLableWigth = [NSLayoutConstraint
//                                               constraintWithItem:_titleLabel
//                                               attribute:NSLayoutAttributeWidth
//                                               relatedBy:NSLayoutRelationEqual
//                                               toItem:nil attribute:NSLayoutAttributeNotAnAttribute
//                                               multiplier:1 constant:CGRectGetWidth(self.bounds)];
//        // subTitleLable Constrains
//        NSLayoutConstraint *subTitleLableTopConstraint = [NSLayoutConstraint
//                                                          constraintWithItem:_titleLabel
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                          toItem:_subtitleLabel
//                                                          attribute:NSLayoutAttributeBottom
//                                                          multiplier:1 constant:0];
//        NSLayoutConstraint *subTitleLableBottomConstraint = [NSLayoutConstraint
//                                                          constraintWithItem:_subtitleLabel
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                          toItem:self
//                                                          attribute:NSLayoutAttributeBottom
//                                                          multiplier:1 constant:0];
//        
//        NSLayoutConstraint *subTitleLableLeadingConstraint = [NSLayoutConstraint
//                                                              constraintWithItem:_subtitleLabel
//                                                              attribute:NSLayoutAttributeLeading
//                                                              relatedBy:NSLayoutRelationEqual
//                                                              toItem:_photo
//                                                              attribute:NSLayoutAttributeTrailing
//                                                              multiplier:1 constant:75];
//        NSLayoutConstraint *subTitleLableTrailingConstraint = [NSLayoutConstraint
//                                                              constraintWithItem:_subtitleLabel
//                                                              attribute:NSLayoutAttributeTrailing
//                                                              relatedBy:NSLayoutRelationEqual
//                                                              toItem:self
//                                                              attribute:NSLayoutAttributeTrailing
//                                                              multiplier:1 constant:-5];
//        
//        NSLayoutConstraint *subTitleLableHeight = [NSLayoutConstraint
//                                                   constraintWithItem:_subtitleLabel
//                                                   attribute:NSLayoutAttributeHeight
//                                                   relatedBy:NSLayoutRelationEqual
//                                                   toItem:nil
//                                                   attribute:NSLayoutAttributeNotAnAttribute
//                                                   multiplier:1 constant:[[self class] heightWithPOOFriendText:_titleLabel.text subTitle:_subtitleLabel.text andMaxWidth:CGRectGetWidth(self.bounds)]];
//        NSLayoutConstraint *subTitleLableWigth = [NSLayoutConstraint
//                                                  constraintWithItem:_subtitleLabel
//                                                  attribute:NSLayoutAttributeWidth
//                                                  relatedBy:NSLayoutRelationEqual
//                                                  toItem:nil
//                                                  attribute:NSLayoutAttributeNotAnAttribute
//                                                  multiplier:1 constant:CGRectGetWidth(self.bounds)];
//        
//        [self addConstraints:@[photoTopConstraint, photoBottomConstraint, photoLeadingConstraint, titleLableTopConstraint, titleLableLeatdingConstraint, titleLableHeight, titleLableWigth, subTitleLableTopConstraint, subTitleLableLeadingConstraint, subTitleLableHeight, subTitleLableWigth,subTitleLableBottomConstraint, subTitleLableTrailingConstraint]];
//    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
