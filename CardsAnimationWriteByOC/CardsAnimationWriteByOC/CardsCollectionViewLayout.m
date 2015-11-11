//
//  CardsCollectionViewLayout.m
//  CardsAnimationWriteByOC
//
//  Created by zhangle on 15/11/10.
//  Copyright © 2015年 zhangle. All rights reserved.
//

#import "CardsCollectionViewLayout.h"

@implementation CardsCollectionViewLayout {
    
    CGFloat cardWidth;
    CGFloat cardHeight;
    CGFloat start_offset_y;
    CGFloat y_distance_in_cells;
    NSInteger numberOfItems;
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *attributesList;
}

- (void)assignmentDefaultValue {
    cardWidth = 300.0;
    cardHeight = 200.0;
    numberOfItems = 0;
    start_offset_y = 0.0;
    y_distance_in_cells = 30.0;
    attributesList = [NSMutableArray array];
}

- (instancetype)init {
    if (self = [super init]) {
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.collectionView.pagingEnabled = YES;
        [self assignmentDefaultValue];
    }
    return self;
}

- (CATransform3D)makePerspectiveTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -2000;
    return transform;
}

- (CGSize)collectionViewContentSize {
    CGFloat height = MAX((y_distance_in_cells * numberOfItems), (self.collectionView.bounds.size.height + 1.0));
    return CGSizeMake(self.collectionView.bounds.size.width, height * 2.0);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSMutableArray *array = [NSMutableArray array];
    
    CGFloat offset_y = self.collectionView.contentOffset.y;
    CGFloat max_offset_y = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
    start_offset_y = floor(max_offset_y / 2.0 / 30.0) * 30.0;
    CGFloat reverse_offset_y = start_offset_y - offset_y;
    numberOfItems = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < numberOfItems; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat center_x = self.collectionView.bounds.size.width / 2.0;
        CGFloat center_y = self.collectionView.bounds.size.height / 2.0 + offset_y + cardHeight / 2.0;
        CGFloat ratio    = 1.0 - 0.1 * indexPath.row;
        ratio   += reverse_offset_y / y_distance_in_cells / 10.0;
        if (ratio < 1.0) {
            center_y += -(1.0 - ratio) * y_distance_in_cells * 10.0;
        }
        
        attributes.center    = CGPointMake(center_x, center_y);
        CGFloat scale        = MIN((1.0 * ratio), 1.0);
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
        attributes.bounds    = CGRectMake(0.0, 0.0, cardWidth, cardHeight);
        attributes.alpha     = 1.0;
        attributes.zIndex    = 10000 - indexPath.row;
        
        if (ratio > 1.0) {
            CGFloat alpha = (1.1 - ratio) * 10.0;
            alpha = MIN(alpha, 1.0);
            alpha = MAX(alpha, 0.0);
            attributes.alpha = alpha;
            
            CGFloat angle_ratio = 1.0 - (1.1 - ratio) * 10.0;
            angle_ratio = MIN(angle_ratio, 1.0);
            angle_ratio = MAX(angle_ratio, 0.0);
            CGFloat angle = -179.999 * angle_ratio;
            CGFloat radians = angle * M_PI / 180.0;
            
            CATransform3D transform_perspective = [self makePerspectiveTransform];
            CATransform3D transform_3d = CATransform3DRotate(transform_perspective, radians, 1.0, 0.0, 0.0);
            attributes.transform3D = transform_3d;
        }
        
        if (ratio > 0.0) {
            [array addObject:attributes];
        }
    }
    attributesList = array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return attributesList[indexPath.row];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return attributesList;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGPoint targetContentOffset = proposedContentOffset;
    
    CGFloat total = targetContentOffset.y / y_distance_in_cells;
    CGFloat more = fmod(targetContentOffset.y, y_distance_in_cells);

    if (more > 0.0) {
        if (more >= y_distance_in_cells / 2.0) {
            targetContentOffset.y = ceil(total) * y_distance_in_cells;
        }else {
            targetContentOffset.y = floor(total) * y_distance_in_cells;
        }
    }
    
    return targetContentOffset;
}

@end
