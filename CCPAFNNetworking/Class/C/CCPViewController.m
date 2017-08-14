//
//  CCPViewController.m
//  CCPAFNNetworking
//
//  Created by C CP on 16/9/11.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "CCPViewController.h"
#import "CCPNetworking.h"
#import "CCPTableViewCell.h"
#import "CCPTableViewController.h"
#import "MBProgressHUD+ADD.h"

@interface CCPViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *CCPTableView;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,copy) NSString *filePathString;

@end

@implementation CCPViewController


- (UITableView *)CCPTableView {
    
    if (_CCPTableView == nil) {
        
        _CCPTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        
        _CCPTableView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_CCPTableView];
    }
    
    return _CCPTableView;
    
}

- (NSMutableArray *)imageArray {
    
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
        for (int i = 1; i < 11; i ++ ) {
            [_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image_%d",i]]];
        }
    }
    return _imageArray;
}


static NSString * const CCPCell = @"CCPCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.CCPTableView.delegate = self;
    self.CCPTableView.dataSource = self;
    self.title = @"首页";
    [self.CCPTableView registerNib:[UINib nibWithNibName:@"CCPTableViewCell" bundle:nil] forCellReuseIdentifier:CCPCell];
    [self aboutDownload];
    
    
    //判断是否有网络链接
    if (![CCPNetworking isHaveNetwork]) {
        [MBProgressHUD showInformation:@"网络无连接，请检查网络" toView:self.view.window andAfterDelay:3.0];
    }
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 1; i < 12; i ++ ) {
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_1_%d",i]]];
    }
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imageArr;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imageArr.count + 1) * 0.075];
    [showImageView startAnimating];
    [MBProgressHUD showCustomview:showImageView andTextString:@"数据加载中..." toView:self.view.window andAfterDelay:3.0];
}

//下载路径
- (void) aboutDownload {

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(clickTheButton)];
    // 创建目标文件
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/mp4_movie",pathDocuments];
    if (![[NSFileManager defaultManager]fileExistsAtPath:createPath]) {
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        NSLog(@"文件已经创建");
    }
    
    self.filePathString = createPath;
}

//下载
- (void) clickTheButton {
    NSString *pathStr = [NSString stringWithFormat:@"下载完成文件路径---%@",self.filePathString];
    [CCPNetworking downloadWithUrl:@"http://106.2.184.232:9999/bla.gtimg.com/qqlive/201612/BRDS_20161215163219457.mp4" saveToPath:self.filePathString loadingImageArr:nil progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
    } toShowView:self.view isFullScreen:YES success:^(id response) {
        [MBProgressHUD showInformation:pathStr toView:self.view andAfterDelay:2.0];
    } failure:^(NSError *error) {
    } showHUD:NO];
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CCPCell];
    
    UIImage *image = self.imageArray[indexPath.row];
    
    cell.girl_imageVIew.image = image;
    
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCPTableViewController *VC = [[CCPTableViewController alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 205;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    cell.layer.transform = rotation;
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

@end
