//
//  POOFeedViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 02.11.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOFeedViewController.h"
#import "POOFacebookFeed.h"
#import "POOFeedTableViewCell.h"
#import "POOCollectionViewCell.h"

static CGFloat const kCollectionViewControllerSpace = 5.f;

@interface POOFeedViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger collectionItemCounter;
    NSInteger numberOfElementInCollection;
    CGSize itemSize;
}

@property (nonatomic, strong) NSArray *feeds;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collection;
@end

@implementation POOFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initWithArray:(NSArray *)array {
    self.feeds = array;
    [self.tableView reloadData];
}
#pragma mark - TableView
- (void) creatTable {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *identifier = @"identifier";
    
    POOFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"POOFeedTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    POOFacebookFeed *feed = [self.feeds objectAtIndex:indexPath.row];
    collectionItemCounter = feed.images.count;
    numberOfElementInCollection = indexPath.row;
    
    if (collectionItemCounter == 0) {
        cell.collectionView.hidden = YES;
    }
    
    [cell configWithMessage:feed.message picture:nil date:feed.timeCreat imageCount:feed.images.count itemSize:CGSizeMake(110, 110)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    POOFacebookFeed *feed = [self.feeds objectAtIndex:indexPath.row];
    
    return [POOFeedTableViewCell hieghtWithMessage:feed.message image:[POOFeedTableViewCell setCollectionViewContentSize:feed.images.count itemSize:CGSizeMake(110, 110)] time:feed.timeCreat maxWighth:CGRectGetWidth(self.tableView.bounds)];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(POOFeedTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell configWithDelegateAndDataSource:self];
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionItemCounter;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([POOCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([POOCollectionViewCell class])];
    
    POOCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([POOCollectionViewCell class]) forIndexPath:indexPath];
    
    POOFacebookFeed *feed = [self.feeds objectAtIndex:numberOfElementInCollection];
    
    [cell configureWithThumbnailUrl:[feed.images objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rows = 3;
    NSUInteger col = 3;
    if (collectionItemCounter == 1) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds) - kCollectionViewControllerSpace, (CGRectGetHeight(collectionView.bounds) - kCollectionViewControllerSpace));
    }
    return CGSizeMake((CGRectGetWidth(collectionView.bounds) - kCollectionViewControllerSpace * (rows + 1)) / rows, (CGRectGetHeight(collectionView.bounds) - kCollectionViewControllerSpace * (col + 1))/ col);;
}

- (UIEdgeInsets
   )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCollectionViewControllerSpace, kCollectionViewControllerSpace, kCollectionViewControllerSpace, kCollectionViewControllerSpace);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewControllerSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewControllerSpace;
}

@end
