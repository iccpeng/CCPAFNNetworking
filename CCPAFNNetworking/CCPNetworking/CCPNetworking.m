//
//  CCPNetworking.m
//  CCPNetworkingDemo
//
//  Created by CCP on 16/5/12.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "CCPNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+ADD.h"
#import "DGActivityIndicatorView.h"

#ifdef DEBUG
#   define CCPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define CCPLog(...)
#endif


@implementation CCPNetworking

+ (CCPNetworking *)sharedCCPNetworking
{
    static CCPNetworking *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[CCPNetworking alloc] init];
    });
    return handler;
}

+(CCPURLSessionTask *)getOrPostWithType:(httpMethod)httpMethod   WithUrl:(NSString *)url params:(NSDictionary *)params loadingImageArr:(NSMutableArray *)loadingImageArr  toShowView:(UIView *)showView isFullScreen:(BOOL)isFull success:(CCPResponseSuccess)success fail:(CCPResponseFail)fail showHUD:(BOOL)showHUD{
    return [self baseRequestType:httpMethod url:url params:params loadingImageArr:loadingImageArr toShowView:showView isFullScreen:isFull success:success fail:fail showHUD:showHUD];
}

+ (CCPURLSessionTask *)baseRequestType:(httpMethod)type url:(NSString *)url params:(NSDictionary *)params  loadingImageArr:(NSMutableArray *)loadingImageArr  toShowView:(UIView *)showView isFullScreen:(BOOL)isFull success:(CCPResponseSuccess)success fail:(CCPResponseFail)fail showHUD:(BOOL)showHUD {
    
    if (url==nil) {
        
        return nil;
    }
    
    if (showHUD == YES) {
        
        [MBProgressHUD showHUDWithImageArr:loadingImageArr andShowView:showView isFullScreen:isFull];
    }
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager=[self getAFManager];
    
    CCPURLSessionTask *sessionTask=nil;
    
    if (type== GET) {
        sessionTask = [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                
                success(responseObject);
            }
            
            
            if (showHUD==YES) {
                
                [MBProgressHUD dissmissShowView:showView];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (fail) {
                fail(error);
            }
            
            if (showHUD==YES) {
                
                [MBProgressHUD dissmissShowView:showView];
                
            }
            
        }];
        
    }else{
        
        sessionTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(responseObject);
            }
            
            if (showHUD==YES) {
                
                [MBProgressHUD dissmissShowView:showView];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (fail) {
                fail(error);
            }
            
            
            if (showHUD==YES) {
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    
                    sleep(1.0);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MBProgressHUD dissmissShowView:showView];
                    });
                });
                
            }
            
        }];
        
    }
    
    return sessionTask;
}




+(CCPURLSessionTask *)getOrPostWithType:(httpMethod)httpMethod   WithUrl:(NSString *)url params:(NSDictionary *)params animationType:(AnimationType)animationType animationTypeColor:(UIColor *)color isFullScreen:(BOOL)isFull success:(CCPResponseSuccess)success fail:(CCPResponseFail)fail showHUD:(BOOL)showHUD {
    
    //展示loading
    UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
    
    if (color == nil) {
        color = [UIColor redColor];
    }
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(int)animationType tintColor:color size:50.0f];
    activityIndicatorView.userInteractionEnabled = YES;
    
    CGFloat pointY;
    if (isFull) {
        pointY = 0.0;
    } else {
        pointY = 64.0;
    }
    activityIndicatorView.frame = CGRectMake(0.0f, pointY,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - pointY);
    [currentWindows addSubview:activityIndicatorView];
    
    if (url==nil) {
        
        return nil;
    }
    
    if (showHUD == YES) {
        [activityIndicatorView startAnimating];
    }
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    AFHTTPSessionManager *manager=[self getAFManager];
    CCPURLSessionTask *sessionTask=nil;
    if (httpMethod == GET) {
        sessionTask = [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
            if (showHUD==YES) {
                //取消loading
                [activityIndicatorView stopAnimating];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (fail) {
                fail(error);
            }
            if (showHUD==YES) {
                //取消loading
                [activityIndicatorView stopAnimating];
            }
            
        }];
        
    }else{
        
        sessionTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
            if (showHUD==YES) {
                //取消loading
                [activityIndicatorView stopAnimating];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (fail) {
                fail(error);
            }
            if (showHUD==YES) {
                //取消loading
                [activityIndicatorView stopAnimating];
            }
        }];
        
    }
    return sessionTask;
}

+ (CCPURLSessionTask *)uploadWithImages:(NSArray *)imageArr url:(NSString *)url filename:(NSString *)filename names:(NSArray *)nameArr params:(NSDictionary *)params loadingImageArr:(NSMutableArray *)loadingImageArr toShowView:(UIView *)showView isFullScreen:(BOOL)isFull progress:(CCPUploadProgress)progress success:(CCPResponseSuccess)success fail:(CCPResponseFail)fail showHUD:(BOOL)showHUD {
    
    if (url==nil) {
        return nil;
    }
    if (showHUD==YES) {
        
        [MBProgressHUD showHUDWithImageArr:loadingImageArr andShowView:showView isFullScreen:isFull];
    }
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager=[self getAFManager];
    CCPURLSessionTask *sessionTask=nil;
    sessionTask = [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < imageArr.count; i ++) {
            
            UIImage *image = (UIImage *)imageArr[i];
            
            NSData *imageData = UIImageJPEGRepresentation(image,1.0);
            
            NSString *imageFileName = filename;
            if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@.png", str];
            }
            
            NSString *nameString = (NSString *)nameArr[i];
            
            [formData appendPartWithFileData:imageData name:nameString fileName:imageFileName mimeType:@"image/jpg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        CCPLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
        if (progress) {
            
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
        if (showHUD==YES) {
            
            [MBProgressHUD dissmissShowView:showView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            fail(error);
        }
        
        if (showHUD==YES) {
            
            [MBProgressHUD dissmissShowView:showView];
        }
        
    }];
    
    return sessionTask;
    
}


+ (CCPURLSessionTask *)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath loadingImageArr:(NSMutableArray *)loadingImageArr progress:(CCPDownloadProgress )progressBlock toShowView:(UIView *)showView isFullScreen:(BOOL)isFull success:(CCPResponseSuccess )success failure:(CCPResponseFail )fail showHUD:(BOOL)showHUD{
    if (url==nil) {
        return nil;
    }
    if (showHUD==YES) {
        [MBProgressHUD showHUDWithImageArr:loadingImageArr andShowView:showView isFullScreen:isFull];
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self getAFManager];
    
    CCPURLSessionTask *sessionTask = nil;
    
    sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        CCPLog(@"下载进度--%.1f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!saveToPath) {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            CCPLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        }else{
            NSURL *downloadURL = [NSURL fileURLWithPath:saveToPath];
            CCPLog(@"目标下载路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error == nil) {
            
            if (success) {
                success([filePath path]);//返回完整路径
            }
            
        } else {
            
            if (fail) {
                
                fail(error);
                
            }
        }
        
        if (showHUD==YES) {
            
            [MBProgressHUD dissmissShowView:showView];
        }
        
    }];
    
    //开始下载
    [sessionTask resume];
    
    return sessionTask;
    
}


+ (AFHTTPSessionManager *)getAFManager{
    
    static AFHTTPSessionManager *httpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        httpManager = [AFHTTPSessionManager manager];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
        //httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置返回NSData 数据
        httpManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        httpManager.requestSerializer.timeoutInterval= 30;
        httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
    });
    
    return httpManager;
}

#pragma makr - 开始监听程序在运行中的网络连接变化
+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                
                [CCPNetworking sharedCCPNetworking].networkStats=StatusUnknown;
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
                [CCPNetworking sharedCCPNetworking].networkStats=StatusNotReachable;
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                
                [CCPNetworking sharedCCPNetworking].networkStats=StatusReachableViaWWAN;
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                [CCPNetworking sharedCCPNetworking].networkStats=StatusReachableViaWiFi;
                
                break;
        }
    }];
    
    [mgr startMonitoring];
}

+ (NetworkStatu)checkNetStatus {
    
    [self startMonitoring];
    
    if ([CCPNetworking sharedCCPNetworking].networkStats == StatusReachableViaWiFi) {
        
        return StatusReachableViaWiFi;
        
    } else if ([CCPNetworking sharedCCPNetworking].networkStats == StatusNotReachable) {
        
        return StatusNotReachable;
        
    } else if ([CCPNetworking sharedCCPNetworking].networkStats == StatusReachableViaWWAN) {
        
        return StatusReachableViaWWAN;
        
    } else {
        
        return StatusUnknown;
        
    }
    
}


+ (BOOL) isHaveNetwork {
    
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    if ([conn currentReachabilityStatus] == NotReachable) {
        
        return NO;
        
    } else {
        
        return YES;
    }
}

+ (NSString *)strUTF8Encoding:(NSString *)str{
    
    if (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)) {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
@end
