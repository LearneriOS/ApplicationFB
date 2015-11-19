//
//  POOCollectionViewLayout.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 10.11.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOCollectionViewLayout.h"

@interface POOCollectionViewLayout ()
{
    NSArray *layoutArr;
    CGSize currentContentSize;
}

@end

@implementation POOCollectionViewLayout

-(void) prepareLayout {
    [super prepareLayout];
    layoutArr = [self generateLayput];
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    
    return layoutArr;
}
- (CGSize) collectionViewContentSize {
    return currentContentSize;
}

- (NSArray *) generateLayput {
    NSMutableArray *arr = [NSMutableArray new];
    NSInteger sectionCount = 0;
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    
    //float width = self.collectionView.bounds.size.width;
    float xOffset = 0;
    float yOffset = 0;
    NSInteger itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:sectionCount];
    for (NSInteger item = 0; item < itemsCount; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:sectionCount];
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attrs.frame = CGRectMake(xOffset, yOffset, self.cellSize.width, self.cellSize.height);
        xOffset += self.cellSize.width;
        [arr addObject:attrs];
    }

    currentContentSize  = CGSizeMake(xOffset, yOffset);
    return arr;
}
@end
