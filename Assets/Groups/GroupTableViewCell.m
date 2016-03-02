//
//  GroupTableViewCell.m
//  PhotoFlow
//
//  Created by zhaochunyang on 16/3/1.
//  Copyright © 2016年 jijunyuan. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "QBImagePickerThumbnailView.h"

@interface GroupTableViewCell ()

@property (strong, nonatomic) IBOutlet QBImagePickerThumbnailView *thumbView;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblNumber;

@end

@implementation GroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Update thumbnail view
    _thumbView.assetsGroup = self.assetsGroup;
    
    // Update label
    self.lblName.text = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.lblNumber.text = [NSString stringWithFormat:@"%ld", (long)self.assetsGroup.numberOfAssets];
}

@end
