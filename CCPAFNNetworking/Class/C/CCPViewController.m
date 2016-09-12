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
    
    if (_imageArray == nil) {
        
        _imageArray = [NSMutableArray array];
        
        for (int i = 1; i < 54; i ++ ) {
            
            [_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image_%d",i]]];
        }
        
    }
    
    return _imageArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.CCPTableView.delegate = self;
    self.CCPTableView.dataSource = self;
    
    NSMutableArray *imageArr = [NSMutableArray array];
    
    for (int i = 1; i < 22; i ++ ) {
        
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_7_%d",i]]];
    }
    
    
    [CCPNetworking getOrPostWithType:GET WithUrl:@"http://newsapi.sina.cn/?resource=feed&accessToken=&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=3d91d5d90c90486cde48597325cf846b699ceb53&deviceModel=apple-iphone5&from=6053093012&idfa=7CE5628E-577A-4A0E-B9E5-283217ECA1F1&idfv=10E31C9D-59AE-4547-BDEF-5FF3EA045D86&imei=3d91d5d90c90486cde48597325cf846b699ceb53&location=39.998602%2C116.365189&osVersion=9.3.5&resolution=640x1136&token=61903050f1141245bfb85231b58e84fb586743436ceb50af9f7dfe17714ee6f7&ua=apple-iphone5__SinaNews__5.3__iphone__9.3.5&weiboSuid=&weiboUid=&wm=b207&rand=221&urlSign=3c861405dd&behavior=manual&channel=news_pic&lastTimestamp=1473578882&listCount=20&p=1&pullDirection=down&pullTimes=8&replacedFlag=1&s=20" params:nil loadingImageArr:imageArr toShowView:self.view success:^(id response) {

        
    } fail:^(NSError *error) {
        
        
    } showHUD:YES];

}


#pragma mark - tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CCPTableViewCell" owner:self options:nil] lastObject];
        
    };
    
    cell.backgroundColor = [UIColor redColor];
    
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


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    
//    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
//    
//    scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
//    
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    
//    [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
//    
//}



@end
