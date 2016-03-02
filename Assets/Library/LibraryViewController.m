//
//  LibraryViewController.m
//  PhotoFlow
//
//  Created by zhaochunyang on 16/3/1.
//  Copyright © 2016年 jijunyuan. All rights reserved.
//

#import "LibraryViewController.h"
#import "LibraryCollectionViewCell.h"

@interface LibraryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arrLibrarys;  // 相片数组

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) ALAsset *asset;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationbar];
    [self getAssetsLibrary];
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取相片数组

- (void)getAssetsLibrary
{
    _arrLibrarys = [NSMutableArray array];
    // 以反序的方式遍历相册
    [_assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [_arrLibrarys addObject:result];
        }
        else {
            if (_arrLibrarys.count > 0) {
                [self.collectionView reloadData];
            }
            else {
                NSLog(@"出错了");
            }
        }
    }];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrLibrarys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LibraryCollectionViewCell" forIndexPath:indexPath];
    cell.asset = _arrLibrarys[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = _arrLibrarys[indexPath.row];
    CGImageRef thumbnailImageRef = [asset aspectRatioThumbnail];
    [self readerQRCodeWithImage:[UIImage imageWithCGImage:thumbnailImageRef]];
    [self cancel];
}

#pragma mark - 属性

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        CGFloat space = 3;
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake((SCREEN_BOUNDS_SIZE_WIDTH - 2*space)/3, (SCREEN_BOUNDS_SIZE_WIDTH - 2*space)/3);
        _layout.minimumInteritemSpacing = space;
        _layout.minimumLineSpacing = space;
    }
    return _layout;
}

#pragma mark - 

- (void)configNavigationbar
{
    self.title = [NSString stringWithFormat:@"%@", [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}

- (void)cancel
{
    NSNotification *notification = [NSNotification notificationWithName:@"Notification_CloseGroup" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

/**
 *  读取相册二维码
 *
 *  @param image 图片
 */
- (void)readerQRCodeWithImage:(UIImage *)image
{
    //1. 初始化扫描仪，设置设别类型和识别质量
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    //2. 扫描获取的特征组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSString *scannedResult;
    //3. 获取扫描结果
    if (features.count > 0) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        scannedResult = feature.messageString;
        NSLog(@"扫描结果 %@", scannedResult);
    }
    
    NSNotification *notification = [NSNotification notificationWithName:@"Notification_PassQRCodeInfo" object:scannedResult];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//- (void)getImage
//{
//    ALAssetRepresentation *representation = [_asset defaultRepresentation];
//    // 拉取图片全屏图 （fullResolutionImage 原图，未做任何调整的原图，较大，没有特殊要求不建议拉取）
//    UIImage *imageAsset = [UIImage imageWithCGImage:[representation fullScreenImage]];
//}

@end
