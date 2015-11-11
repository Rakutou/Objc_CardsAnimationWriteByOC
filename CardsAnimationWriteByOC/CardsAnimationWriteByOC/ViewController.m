//
//  ViewController.m
//  CardsAnimationWriteByOC
//
//  Created by zhangle on 15/11/10.
//  Copyright © 2015年 zhangle. All rights reserved.
//

#import "ViewController.h"
#import "CardsCollectionViewCell.h"
#import "CardsCollectionViewLayout.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation ViewController {
    CGFloat start_offset_y;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    start_offset_y = 0.0;
    self.images = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    [self prepareData];
    [self.dataArray addObjectsFromArray:self.images];
    [self.dataArray addObjectsFromArray:self.images];
    [self.dataArray addObjectsFromArray:self.images];

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[CardsCollectionViewLayout alloc] init]];
    [self.view addSubview:self.collectionView];
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerClass:[CardsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CardsCollectionViewCell class])];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    NSDictionary *views = @{ @"collectionView" : self.collectionView };
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-16.0)-[collectionView]-(-16.0)-|" options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:views];
    
    NSArray *constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-16.0)-[collectionView]-(-16.0)-|" options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:views];
    [self.view addConstraints:constraintH];
    [self.view addConstraints:constraintV];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView layoutIfNeeded];
    CGFloat max_offset_y = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
    start_offset_y = floor(max_offset_y / 2.0 / 30.0) * 30.0 - 30.0 * self.images.count;
    [self.collectionView setContentOffset:CGPointMake(0.0, start_offset_y) animated:NO];
    NSLog(@"contentSize.height :%f\nbounds.size.height :%f",self.collectionView.contentSize.height,self.collectionView.bounds.size.height);
}

- (void)prepareData {
    for (int i = 0; i < 10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i%10]];
        [self.images addObject:image];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CardsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CardsCollectionViewCell class]) forIndexPath:indexPath];
    
    UIImage *image = self.dataArray[indexPath.row];
    cell.contentImageView.image = image;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat translate = scrollView.contentOffset.y - start_offset_y;
    CGFloat target_scroll_y = 30.0 * (CGFloat)self.images.count;
    if (ABS(translate) >= target_scroll_y) {
        [scrollView setContentOffset:CGPointMake(0.0, start_offset_y) animated:NO];
    }
}

@end
