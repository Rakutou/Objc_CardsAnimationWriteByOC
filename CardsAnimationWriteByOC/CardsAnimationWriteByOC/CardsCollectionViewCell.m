//
//  CardsCollectionViewCell.m
//  CardsAnimationWriteByOC
//
//  Created by zhangle on 15/11/10.
//  Copyright © 2015年 zhangle. All rights reserved.
//

#import "CardsCollectionViewCell.h"

@implementation CardsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.contentImageView = [UIImageView new];
        [self.contentView addSubview:self.contentImageView];
        self.contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = @{@"imageView":self.contentImageView};
        NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-16.0)-[imageView]-(-16.0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
        
        NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-16.0)-[imageView]-(-16.0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
        [self.contentView addConstraints:constraintsH];
        [self.contentView addConstraints:constraintsV];
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        self.layer.shadowOpacity = 0.3;
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    self.layer.anchorPoint = CGPointMake(0.5, 1.0);
}

@end
