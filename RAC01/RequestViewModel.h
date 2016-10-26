//
//  RequestViewModel.h
//  RAC01
//
//  Created by ShenYi on 2016/10/24.
//  Copyright © 2016年 ShenYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RequestViewModel : NSObject

//网络请求命令
@property (nonatomic, strong) RACCommand *command;

@end
