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
    
    //1 - 54 的随机数
    int y = (arc4random() % 10) + 1;
    
    if (_imageArray == nil) {
        
        _imageArray = [NSMutableArray array];
        
        for (int i = 1; i < y; i ++ ) {
            //获取1 - 10 之间随机的图片
            int z = (arc4random() % 10) + 1;
            [_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image_%d",z]]];
        }
        
    }
    
    return _imageArray;
}

static NSString * const CCPCell = @"CCPCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断是否有网络链接
    if (![CCPNetworking isHaveNetwork]) {
        
        [MBProgressHUD showInformation:@"网络无连接，请检查网络" toView:self.view.window andAfterDelay:5.0];
        
    }
    
    [self.CCPTableView registerNib:[UINib nibWithNibName:@"CCPTableViewCell" bundle:nil] forCellReuseIdentifier:CCPCell];
    
    self.title = @"首页";
    
    self.CCPTableView.delegate = self;
    self.CCPTableView.dataSource = self;
    
    NSMutableArray *imageArr = [NSMutableArray array];
    
    for (int i = 1; i < 56; i ++ ) {
        
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Expression_%d",i]]];
    }
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    
    showImageView.animationImages = imageArr;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imageArr.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [MBProgressHUD showCustomview:showImageView andTextString:@"数据加载中..." toView:self.view.window andAfterDelay:5.0];

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
   
//    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

@end
