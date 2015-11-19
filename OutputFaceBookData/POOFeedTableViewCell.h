//
//  POOFeedTableViewCell.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 02.11.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POOFeedTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *message;
@property (nonatomic, strong) IBOutlet UILabel *creatTime;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * messageHeightConstrain;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * messageWidthConstrain;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * collectionHeightConstrain;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * collectionWidthConstrain;

- (void) configWithMessage:(NSString *)message picture:(NSString *)picture date:(NSString *)date imageCount:(NSInteger) imageCount itemSize:(CGSize) itemSize;
- (void) configWithDelegateAndDataSource:(id<UICollectionViewDataSource,UICollectionViewDelegate>)dataSourceDelegate;
+ (CGFloat) setCollectionViewContentSize:(NSInteger) cellCount itemSize:(CGSize) itemSize;
+ (CGFloat) hieghtWithMessage:(NSString *) message image:(CGFloat) image time:(NSString *) time maxWighth:(CGFloat) maxWigth;
@end
