//
//  LoginViewModel.h
//  RAC01
//
//  Created by ShenYi on 2016/10/24.
//  Copyright © 2016年 ShenYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MBProgressHUD+XMG.h"

@interface LoginViewModel : NSObject
//账户，密码
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *psw;

//登录按钮可用信号
@property (nonatomic, strong, readonly) RACSignal *loginEnbleSingal;
//登录命令信号
@property (nonatomic, strong, readonly) RACCommand *command;

@end
