//
//  GroupsViewController.m
//  PhotoFlow
//
//  Created by zhaochunyang on 16/3/1.
//  Copyright © 2016年 jijunyuan. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupTableViewCell.h"
#import "LibraryViewController.h"

static NSString *const appName = @"快照";

@interface GroupsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) ALAssetsGroup *assetsGroup;
@property (strong, nonatomic) ALAssetsFilter *assetsFilter;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) IBOutlet UITableView *customTableView;
@property (strong, nonatomic) NSMutableArray *arrGroups;    // 相册数组

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationbar];
    [self configTableFooterView];
    [self registerTableViewCell];
    [self getAssetsGroup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取相册数据

- (void)getAssetsGroup
{
    __block NSString *tipTextWhenWrong;
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    if (authorizationStatus == ALAuthorizationStatusDenied || authorizationStatus == ALAuthorizationStatusRestricted) {
        tipTextWhenWrong = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相", appName];
        [self alertWithMessage:tipTextWhenWrong];
    }
    
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    _arrGroups = [NSMutableArray array];
    // 遍历相册，取出相册数组
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            // 把有相片的相册储存到数组中，方便后面展示相册时使用
            if (group.numberOfAssets > 0) {
                [_arrGroups addObject:group];
            }
        }
        else {
            if (_arrGroups.count > 0) {
                // 把所有的相册储存完毕，可以展示相册列表
                [self.customTableView reloadData];
            }
            else {
                // 没有任何有资源的相册，输出提示
                tipTextWhenWrong = @"相册里没有任何图片";
                [self alertWithMessage:tipTextWhenWrong];
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Asset group not found!\n");
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifiter = @"GroupTableViewCell";
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiter];
    cell.assetsGroup = _arrGroups[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LibraryViewController *libraryConstroller = [LibraryViewController loadFromStoryBoard:@"LibraryViewController"];
    libraryConstroller.assetsGroup = _arrGroups[indexPath.row];
    [self.navigationController pushViewController:libraryConstroller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.f;
}

#pragma mark - 注册 tableViewCell 和配置 footerView

- (void)registerTableViewCell
{
    [self.customTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GroupTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GroupTableViewCell class])];
}

- (void)configTableFooterView
{
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor whiteColor];
    self.customTableView.tableFooterView = footer;
}

#pragma mark - 配置navigationbar

- (void)configNavigationbar
{
    self.title = @"照片";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}

// 取消
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - alert

- (void)alertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
