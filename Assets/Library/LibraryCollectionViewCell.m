//
//  LibraryCollectionViewCell.m
//  PhotoFlow
//
//  Created by zhaochunyang on 16/3/1.
//  Copyright © 2016年 jijunyuan. All rights reserved.
//

#import "LibraryCollectionViewCell.h"

@interface LibraryCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imgThumb;

@end

@implementation LibraryCollectionViewCell

- (void)setAsset:(ALAsset *)asset
{
    CGImageRef thumbnailImageRef = [asset aspectRatioThumbnail];
    _imgThumb.image = [UIImage imageWithCGImage:thumbnailImageRef];
}

@end
