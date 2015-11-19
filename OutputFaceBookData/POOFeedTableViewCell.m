//
//  POOFeedTableViewCell.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 02.11.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOFeedTableViewCell.h"
#import "POOCollectionViewLayout.h"
#import "POOFeedViewController.h"

@interface POOFeedTableViewCell ()
{
    NSInteger imageCounter;
    CGSize imageHeight;
}
@end

@implementation POOFeedTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configWithDelegateAndDataSource:(id<UICollectionViewDataSource,UICollectionViewDelegate>)dataSourceDelegate {
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.dataSource = dataSourceDelegate;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
}

+ (CGFloat) setCollectionViewContentSize:(NSInteger) cellCount itemSize:(CGSize) itemSize {
    CGFloat collectionViewHeight = cellCount * itemSize.height;
    if (cellCount > 2) {
        if (cellCount % 2 == 0) {
            return collectionViewHeight / 2;
        }
        return collectionViewHeight / 1.7;
    }
    
    return collectionViewHeight;
}

+ (CGFloat) hieghtWithMessage:(NSString *) message image:(CGFloat) image time:(NSString *) time maxWighth:(CGFloat) maxWigth {
    static UILabel *messageStatic = nil;
    static CGFloat imageStatic = 0;
    static UILabel *timeStatic = nil;

    if(!messageStatic || !timeStatic) {
        messageStatic = [[UILabel alloc] init];
        timeStatic = [[UILabel alloc] init];
    }
    
    messageStatic.text = message;
    timeStatic.text = [NSString stringWithFormat:@"%@",time];
    imageStatic = image;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSRange fullRangeMessage = NSMakeRange(0, messageStatic.attributedText.length);
    NSRange fullRangeTime = NSMakeRange(0, timeStatic.attributedText.length);
    
    NSMutableAttributedString *attributedTextMessage = [[NSMutableAttributedString alloc] initWithAttributedString:messageStatic.attributedText];
    [attributedTextMessage addAttributes:@{ NSParagraphStyleAttributeName:style } range:fullRangeMessage];
    
    NSMutableAttributedString *attributedTextTime = [[NSMutableAttributedString alloc] initWithAttributedString:timeStatic.attributedText];
    [attributedTextTime addAttributes:@{ NSParagraphStyleAttributeName:style } range:fullRangeTime];
    if (imageStatic != 0) {
        return  image +[attributedTextMessage boundingRectWithSize:CGSizeMake(maxWigth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + [attributedTextTime boundingRectWithSize:CGSizeMake(maxWigth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 60;
    }
    return [attributedTextMessage boundingRectWithSize:CGSizeMake(maxWigth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + [attributedTextTime boundingRectWithSize:CGSizeMake(maxWigth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 20;
}

- (void) configWithMessage:(NSString *)message picture:(NSString *)picture date:(NSString *)date imageCount:(NSInteger) imageCount itemSize:(CGSize) itemSize {
    self.message.text = message;
    self.creatTime.text = date;
    imageCounter = imageCount;
    imageHeight = itemSize;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    self.messageHeightConstrain.constant = [[self class] hieghtWithMessage:self.message.text image:[[self class] setCollectionViewContentSize:imageCounter itemSize:imageHeight] time:self.creatTime.text maxWighth:CGRectGetWidth(self.bounds)];
    self.messageWidthConstrain.constant = CGRectGetWidth(self.bounds);
    
    self.collectionHeightConstrain.constant = [[self class] hieghtWithMessage:self.message.text image:[[self class] setCollectionViewContentSize:imageCounter itemSize:imageHeight] time:self.creatTime.text maxWighth:CGRectGetWidth(self.bounds)];
    self.collectionWidthConstrain.constant = CGRectGetWidth(self.bounds);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[message]-0-|" options:0 metrics:@{} views:@{@"message" : _message}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[message]-0-[collectionView]-30-|" options:0 metrics:@{} views:@{@"message": _message, @"collectionView": _collectionView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:@{} views:@{ @"collectionView": _collectionView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[collectionView]" options:0 metrics:@{} views:@{ @"collectionView": _collectionView}]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-185-[time]-5-|" options:0 metrics:@{} views:@{@"time" : _creatTime}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[time]-5-|" options:0 metrics:@{} views:@{@"time" : _creatTime}]];
}


@end
