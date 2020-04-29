//
//  TFPhotoBrowser.h
//  test
//
//  Created by wubocheng on 16/4/25.
//  Copyright © 2016年 吴伯程. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPhotoBrowserDelegate <NSObject>

- (void)deleteImageWithIndex:(int)index;

@end

@interface TFPhotoBrowser : UICollectionView

@property (nonatomic) int currentIndex;
//@property (nonatomic, strong) NSArray *assetsArray;
@property (nonatomic, strong) NSArray *imageArray;
- (void)show;

@property (nonatomic, strong) id<TFPhotoBrowserDelegate> deleteDelegate;

@property (nonatomic, getter=isHiddenDeleteButton) BOOL hiddenDeleteButton;
/** 照片 */
@property (nonatomic, weak) NSMutableArray *contractPhotoArray;

- (void)downloadImage;



@end
