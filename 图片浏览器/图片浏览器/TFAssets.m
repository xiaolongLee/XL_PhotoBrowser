//
//  TFAssets.m
//  test
//
//  Created by wubocheng on 16/4/25.
//  Copyright © 2016年 吴伯程. All rights reserved.
//

#import "TFAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation TFAssets

- (void)dealloc {
    //MYLog(@"%s", __func__);
}

- (void)originalImage:(void (^)(UIImage *))returnImage {
    ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
    [assetsLibrary assetForURL:self.imageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *assetRepresentation = asset.defaultRepresentation;
        CGImageRef imageRef = assetRepresentation.fullResolutionImage;
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:assetRepresentation.scale orientation:(UIImageOrientation)assetRepresentation.orientation];
        if (image) {
            returnImage(image);
        }
    } failureBlock:^(NSError *error) {
        //MYLog(@"error = %@", error);
    }];
}

@end
