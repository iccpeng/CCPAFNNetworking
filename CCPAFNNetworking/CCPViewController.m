//
//  CCPViewController.m
//  CCPAFNNetworking
//
//  Created by C CP on 16/9/11.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "CCPViewController.h"
#import "CCPNetworking.h"

@interface CCPViewController ()

@end

@implementation CCPViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSMutableArray *imageArr = [NSMutableArray array];
    
    for (int i = 1; i < 71; i ++ ) {
        
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loadingImage_%d",i]]];
    }
    

    [CCPNetworking getOrPostWithType:POST WithUrl:@"fafafa" params:nil loadingImageArr:imageArr toShowView:self.view success:^(id response) {
        
        
    } fail:^(NSError *error) {
        
        
    } showHUD:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
