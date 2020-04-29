//
//  TFPhotoBrowser.m
//  test
//
//  Created by wubocheng on 16/4/25.
//  Copyright © 2016年 吴伯程. All rights reserved.
//

#import "TFPhotoBrowser.h"
#import "TFAssets.h"
#import "Masonry.h"
 

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kGap 10

typedef void(^BackBlock)();

@interface TFPhotoBrowserCell : UICollectionViewCell <UIScrollViewDelegate>

//@property (nonatomic, weak) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) BackBlock backBlock;

@end

@implementation TFPhotoBrowserCell

- (void)dealloc {
    //MYLog(@"%s", __func__);
}

//- (UIImageView *)imageView {
//    if (!_imageView) {
//        UIImageView *imageView = [UIImageView new];
//        imageView.userInteractionEnabled = YES;
//        self.imageView = imageView;
//        //[self.contentView addSubview:imageView];
//        //手势
//        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGR:)];
//        [imageView addGestureRecognizer:pinch];
//    }
//    return _imageView;
//}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self.contentView addSubview:_scrollView];
        __weak typeof(self)weakSelf = self;
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).with.offset(64);
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(0);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).with.offset(0);
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(0);
        }];
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.maximumZoomScale = 3;
        _scrollView.minimumZoomScale = 1;
        _scrollView.delegate = self;
        
        // 双击放大
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        tap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:tap];
        UITapGestureRecognizer *doubelGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGesture:)];
        doubelGesture.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubelGesture];
        [tap requireGestureRecognizerToFail:doubelGesture];
    }
    return _scrollView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:1];
    return imageView;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:1];
//    if (imageView.frame.size.height <= _scrollView.frame.size.height) {
//        if (imageView.frame.origin.y + imageView.frame.size.height >= _scrollView.frame.size.height || imageView.frame.origin.y <= 0) {
//            CGRect frame = imageView.frame;
//            frame.origin.y = (kScreenHeight - 64) / 2 - frame.size.height / 2;
//            imageView.frame = frame;
//        }
//        if (imageView.frame.origin.y + imageView.frame.size.height >= _scrollView.frame.size.height) {
//            CGRect frame = imageView.frame;
//            frame.origin.y -= imageView.frame.origin.y + imageView.frame.size.height - _scrollView.frame.size.height;
//            imageView.frame = frame;
//        } else if (imageView.frame.origin.y <= 0) {
//            CGRect frame = imageView.frame;
//            frame.origin.y += - imageView.frame.origin.y;
//            imageView.frame = frame;
//        }
//    }
//    _scrollView.contentSize = imageView.frame.size;
//}

//- (void)pinchGR:(UIPinchGestureRecognizer *)recognizer {
//    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
//    recognizer.scale = 1.0;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//}

#pragma mark - 双击放大

-(void)doubleGesture:(UIGestureRecognizer *)sender {
    if (self.scrollView.zoomScale == 1) {
        self.scrollView.zoomScale = 2;
    } else {
        self.scrollView.zoomScale = 1;
    }
}

- (void)back:(UIGestureRecognizer *)recognizer {
    _backBlock();
}

@end

@interface TFCollectionDelegate : NSObject<UICollectionViewDataSource, UICollectionViewDelegate>

//此处弱指针
@property (nonatomic, weak) TFPhotoBrowser *browser;
@property (nonatomic) BOOL isRemoveAnimation;

@property (copy, nonatomic) BackBlock backBlock;

@end

@implementation TFCollectionDelegate

- (void)dealloc {
    //MYLog(@"%s", __func__);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    return self.browser.imageArray.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TFPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TFPhotoBrowserCell" forIndexPath:indexPath];
    
    //双击放大
    cell.backBlock = ^(){
        _backBlock();
    };
    
 
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = ((UIImageView *)self.browser.imageArray[indexPath.item]).image;
    imageView.tag = 1;
    imageView.image = imageView.image;
    //imageView.center = CGPointMake(kWidth * 0.5, kHeight * 0.5);
    //imageView.center = cell.scrollView.center;
    
    float height = kWidth * imageView.image.size.height / imageView.image.size.width;
    float width = kWidth;
    if (height > kHeight - 64.0) {
        //如果超出展现范围的高
        height = kHeight - 64.0;
        width = height / (imageView.image.size.height / imageView.image.size.width);
    }
 
    for (UIView *subView in cell.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.scrollView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell.scrollView);
 
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(kHeight - 64));
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.scrollView.contentSize = imageView.bounds.size;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width) / kWidth - 1;
    if (index < 0) {
        return;
    }
    self.browser.currentIndex = index;
    if (self.isRemoveAnimation == NO) {
        self.isRemoveAnimation = YES;
        //移除缩放效果
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        TFPhotoBrowserCell *cell = [self.browser dequeueReusableCellWithReuseIdentifier:@"TFPhotoBrowserCell" forIndexPath:indexPath];
 
        cell.scrollView.zoomScale = 1;
 
        self.isRemoveAnimation = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_browser.imageArray[_browser.currentIndex] tag] == 1) { //需要下载图片
        [_browser downloadImage];
    }
}

@end

@interface TFPhotoBrowser () <UIGestureRecognizerDelegate  >

@property (nonatomic, weak) UILabel *indexLabel;
//目的是用强指针指向代理，代理弱指针指向自己，这样自己销毁，代理销毁，跟常规不一样
@property (nonatomic, strong) id daili;
@property (nonatomic, weak) UIButton *deleteButton;

@end

@implementation TFPhotoBrowser

- (void)dealloc {
    //MYLog(@"%s", __func__);
}

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(kWidth, kHeight);
    self.collectionViewLayout = flowLayout;
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout]) {
        self.pagingEnabled = YES;
        [self registerClass:[TFPhotoBrowserCell class] forCellWithReuseIdentifier:@"TFPhotoBrowserCell"];
        self.backgroundColor = [UIColor whiteColor];
        
        TFCollectionDelegate *delegate = [TFCollectionDelegate new];
        __weak TFPhotoBrowser *weakSelf = self;
        delegate.backBlock = ^(){
            [weakSelf back];
        };
        self.delegate = delegate;
        self.dataSource = delegate;
        self.daili = delegate;
        delegate.browser = self;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
//        [self addGestureRecognizer:tap];
    }
    return self;
}

 

- (void)back {
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0.1;
        weakSelf.indexLabel.alpha = 0.1;
        weakSelf.deleteButton.alpha = 0.1;
    } completion:^(BOOL finished) {
        [weakSelf.indexLabel removeFromSuperview];
        [weakSelf.deleteButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [window bringSubviewToFront:self.indexLabel];
    [window bringSubviewToFront:self.deleteButton];
    self.deleteButton.hidden = self.isHiddenDeleteButton;
    
    //显示当前图片，并滚动到当前位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    if ([_imageArray[_currentIndex] tag] == 1) { //无图 需请求
        [self downloadImage];
    }
}

- (void)setCurrentIndex:(int)currentIndex {
    _currentIndex = currentIndex;
//    self.indexLabel.text = [NSString stringWithFormat:@"%d/%d", self.currentIndex+1, self.assetsArray.count];
   
        self.indexLabel.text = [NSString stringWithFormat:@"%d / %ld", self.currentIndex+1, self.imageArray.count-1];
   
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18.0];
        label.textColor = [UIColor blackColor];
        _indexLabel = label;
        label.center = CGPointMake(kWidth*0.5, 42);
        label.bounds = CGRectMake(0, 0, 100, 44);
        [[UIApplication sharedApplication].keyWindow addSubview:label];
        
    }
    return _indexLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        UIButton *deleteButton = [UIButton new];
        _deleteButton = deleteButton;
        deleteButton.frame = CGRectMake(kWidth - 50, 20, 50, 44); /*CGRectMake(kWidth - 37, 0, 37, 36);*/
//        [deleteButton setImage:[UIImage imageNamed:_shopPhoto ? @"37x36灰" : @"0-58"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:deleteButton];
    }
    return _deleteButton;
}

- (void)clickDeleteButton {
//    if (self.shopPhoto) {
//        [self.deleteDelegate deleteImageWithIndex:0];
//        [self back];
//
//    }else {
        __weak typeof(self)weakSelf = self;
        if (_imageArray.count == 1) { // 防止快速连续点击删除按钮时发生闪退
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.frame = CGRectMake(kWidth, 0, 0, 0);
            } completion:^(BOOL finished) {
                [weakSelf.indexLabel removeFromSuperview];
                [weakSelf.deleteButton removeFromSuperview];
                [weakSelf removeFromSuperview];
            }];
            return;
        }
        
        [self.deleteDelegate deleteImageWithIndex:_currentIndex];
        
        //删除图片
        if (_imageArray.count - 1 == 0) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.frame = CGRectMake(kWidth, 0, 0, 0);
            } completion:^(BOOL finished) {
                [weakSelf.indexLabel removeFromSuperview];
                [weakSelf.deleteButton removeFromSuperview];
                [weakSelf removeFromSuperview];
            }];
        } else {
            self.currentIndex = _currentIndex;
            [self reloadData];
        }
//    }
    
}

 

@end
