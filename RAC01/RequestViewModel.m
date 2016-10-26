//
//  RequestViewModel.m
//  RAC01
//
//  Created by ShenYi on 2016/10/24.
//  Copyright © 2016年 ShenYi. All rights reserved.
//

#import "RequestViewModel.h"
#import "AFNetworking.h"

@implementation RequestViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //https://api.douban.com/v2/book/search?p="美女"
    _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //创建signal
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //发送网络请求
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            
            [mgr GET:@"https://api.douban.com/v2/book/search" parameters:@{@"p" : @"美女"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                //成功
                NSLog(@"请求成功");
                [subscriber sendNext:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                //失败
                NSLog(@"请求失败,%@",error);
                [subscriber sendNext:error];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
    
    
    
    
    
}

@end
