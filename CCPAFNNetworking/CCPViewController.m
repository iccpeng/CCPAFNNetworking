//
//  CCPViewController.m
//  CCPAFNNetworking
//
//  Created by C CP on 16/9/11.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "CCPViewController.h"
#import "CCPNetworking.h"

@interface CCPViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *CCPTableView;

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



- (void)viewDidLoad {
    [super viewDidLoad];

    self.CCPTableView.delegate = self;
    self.CCPTableView.dataSource = self;
    
    NSMutableArray *imageArr = [NSMutableArray array];
    
    for (int i = 1; i < 13; i ++ ) {
        
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_1_%d",i]]];
    }

    [CCPNetworking getOrPostWithType:POST WithUrl:@"fafafa" params:nil loadingImageArr:imageArr toShowView:self.view success:^(id response) {
        
        
    } fail:^(NSError *error) {
        
        
    } showHUD:YES];

}


#pragma mark - tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 100;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.textLabel.text = @"好好学习，天天向上";
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - tableView Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 260;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
    
    scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
    
}



@end
