//
//  ViewController.m
//  RAC01
//
//  Created by ShenYi on 2016/10/21.
//  Copyright © 2016年 ShenYi. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACReturnSignal.h"
#import "MBProgressHUD+XMG.h"
#import "LoginViewModel.h"
#import "RequestViewModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pswField;
@property (nonatomic, strong) LoginViewModel *loginVM;
@property (nonatomic, strong) RequestViewModel *requestVM;

@end

@implementation ViewController
//懒加载ViewModel
- (LoginViewModel *)loginVM
{
    if (_loginVM == nil){
        _loginVM = [[LoginViewModel alloc] init];
    }
    return _loginVM;
}

- (RequestViewModel *)requestVM
{
    if (_requestVM == nil){
        _requestVM = [[RequestViewModel alloc] init];
    }
    return _requestVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //RACSignal
//    [self RACSignal];
//    [self RACSubject];
//    [self RACMuticastConnection];
//    [self bind];
//    [self flatten];
//    [self map];
//    [self concat];
    
    [[self.requestVM.command execute:nil] subscribeNext:^(id x) {
        NSLog(@"%@", x);
        NSLog(@"出来了");
    }];
    
    
    
}

- (void)loginAction
{
    //login按钮能否点击
    RAC(self.loginVM, account) = _accountField.rac_textSignal;
    RAC(self.loginVM, psw) = _pswField.rac_textSignal;
    RAC(_loginBtn, enabled) = self.loginVM.loginEnbleSingal;
    
    //login按钮点击执行业务
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"点击登录按钮");
        //执行命令
        [self.loginVM.command execute:@"123"];
    }];
}

- (void)concat{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"A");
        
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"B");
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    [[signalA concat:signalB] subscribeNext:^(id x) {
        
        NSLog(@"x--%@", x);
        
    }];
}

- (void)map{
    RACSubject *subject = [RACSubject subject];
    
    [[subject map:^id(id value) {
        return [NSString stringWithFormat:@"sy:%@", value];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
        
    }];
    
    [subject sendNext:@"12"];
    
}

- (void)flatten{
    //1.创建信号
    RACSubject *subject = [RACSubject subject];
    //2.绑定信号
    RACSignal *bindSignal = [subject flattenMap:^RACStream *(id value) {
        
        NSLog(@"%@", value);
        
        value = [NSString stringWithFormat:@"sy%@", value];
        return [RACReturnSignal return:value];
    }];
    //3.订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    //4.发送信号
    [subject sendNext:@"haha"];
}

- (void)bind
{
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *bindSignal = [subject bind:^RACStreamBindBlock{
        
        return ^RACSignal *(id value, BOOL *stop){
            NSLog(@"yuanxinhao%@", value);
            return [RACReturnSignal return:value];
        };
    }];
    
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"bangdingxinhao%@", x);
    }];
    
    [subject sendNext:@1];
}

- (void)RACMuticastConnection{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"创建信号");
        
        [subscriber sendNext:@3];
        
        return nil;
    }];
    
    RACMulticastConnection *connection = [signal publish];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅信号1%@",@1);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅信号2%@",@1);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅信号3%@",@1);
    }];
    
    [connection connect];
    
}

- (void)RACSubject
{
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"yihao %@", x);
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"erhao %@", x);
    }];
    
    [subject sendNext:@43];
}

- (void)RACSignal{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"创建信号");
        //发送信号
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁");
        }];
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅信号%@", x);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
