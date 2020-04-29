//
//  TFAssets.h
//  test
//
//  Created by wubocheng on 16/4/25.
//  Copyright © 2016年 吴伯程. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFAssets : NSObject

/** 缩略图 */
@property (nonatomic, strong) UIImage *thumbnail;
/** 原图URL */
@property (nonatomic, strong) NSURL *imageURL;
/** 是否被选中 */
@property (nonatomic, getter=isSelected) BOOL selected;
/** 记录照片的时间 */
@property (nonatomic, copy) NSString *date;

/** 获取原图 */
- (void)originalImage:(void (^)(UIImage *image))returnImage;

@end
