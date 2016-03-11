//
//  POOFriendPhotoViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 19.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOFriendPhotoViewController.h"
#import "POOCollectionViewCell.h"
#import "POOTESTFriend.h"

static CGFloat const kCollectionViewControllerSpace = 5.f;

@interface POOFriendPhotoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *friendsPhoro;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation POOFriendPhotoViewController

- (void) initByArray:(NSArray *) array {
    _friendsPhoro = array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView(>=0)]|" options:0 metrics:@{} views:@{@"collectionView": _collectionView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView(>=0)]|" options:0 metrics:@{} views:@{@"collectionView": _collectionView}]];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([POOCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([POOCollectionViewCell class])];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.friendsPhoro.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"POOCollectionViewCell";
    
    POOCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    POOTESTFriend *friend = [self.friendsPhoro objectAtIndex:indexPath.row];
    [cell configureWithThumbnailUrl:friend.thumpnailUrl];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rows = 3;
    NSUInteger col = 3;
    
    return CGSizeMake((CGRectGetWidth(collectionView.bounds) - kCollectionViewControllerSpace * (rows + 1)) / rows, (CGRectGetHeight(collectionView.bounds) - (60+kCollectionViewControllerSpace) * (col + 1))/ col);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCollectionViewControllerSpace, kCollectionViewControllerSpace, kCollectionViewControllerSpace, kCollectionViewControllerSpace);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewControllerSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewControllerSpace;
}

@end
