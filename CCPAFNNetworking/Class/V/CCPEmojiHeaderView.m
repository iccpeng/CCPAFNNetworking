//
//  CCPEmojiHeaderView.m
//  CCPAFNNetworking
//
//  Created by CCP on 2016/11/18.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "CCPEmojiHeaderView.h"

@implementation CCPEmojiHeaderView

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=55; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Expression_%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=22; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_7_%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}


@end
