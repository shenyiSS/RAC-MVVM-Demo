//
//  LoginViewModel.m
//  RAC01
//
//  Created by ShenYi on 2016/10/24.
//  Copyright © 2016年 ShenYi. All rights reserved.
//

#import "LoginViewModel.h"


@implementation LoginViewModel

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
    //创建信号
    _loginEnbleSingal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, psw)] reduce:^id(NSString *account, NSString *psw){
        
        NSLog(@"更改文本框");
        
        return @(account.length && psw.length);
        
    }];
    
    //创建登录命令
    _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"发送登录请求");
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:@"请求登录的信息"];
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
    }];
    
    
    //获取命令中的信号
    [_command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@123", x);
    }];
    
    //判断是否执行
    [[[_command executing] skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES){
            NSLog(@"正在执行");
            [MBProgressHUD showMessage:@"正在执行..."];
        }else{
            NSLog(@"执行完成");
            [MBProgressHUD hideHUD];
        }
    }];
}

@end
