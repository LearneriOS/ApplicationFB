//
//  POOVKTableViewCell.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 16.02.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "POOVKTableViewCell.h"
#import "String+Md5.h"
#import "POOCache.h"

@interface POOVKTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *fullnameOrStatus;

@end

@implementation POOVKTableViewCell

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

- (void)configureWithName:(NSString *)name  SecondName:(NSString *) secondName online:(NSInteger) online image:(NSString *) image {
    self.name.text = [NSString stringWithFormat:@"%@ %@",name, secondName];
    if (online == 1) {
        self.fullnameOrStatus.text = @"online";
    } else {
        self.fullnameOrStatus.text = @"";
    }
    
    [self loadImageFromURL:image];
}

- (void)configureWithName:(NSString *)name  SecondName:(NSString *) secondName {
    self.name.text = name;
    if (secondName.length > 0) {
        self.fullnameOrStatus.text = [NSString stringWithFormat:@"%@ %@", name, secondName];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)configureWithTitleLabel:(NSString *)titleString  andSubtitleLabel:(NSString *) SubTitleLabel {
    self.name.text = titleString;
    self.fullnameOrStatus.text = SubTitleLabel;
    
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
