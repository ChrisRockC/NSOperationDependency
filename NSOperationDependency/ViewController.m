//
//  ViewController.m
//  NSOperationDependency
//
//  Created by mac on 15/6/19.
//  Copyright (c) 2015年 CC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//依赖关系

// 用户登录，付费，下载，通知用户
-(void)dependency
{
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"用户登录--- %@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"付费--- %@",[NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载--- %@",[NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"通知用户--- %@",[NSThread currentThread]);
    }];
    
    //设置依赖关系，这里是并发效率是比GCD得串行队列要好！
    [op2 addDependency:op1];
    [op3 addDependency:op2];
    [op4 addDependency:op3];
    
    
    //注意：不要用循环依赖
    //循环依赖在iOS不同的版本的表现是不一样额。之前的会直接死锁。现在会直接不执行，但还是不要用
//    [op4 addDependency:op1]; 
    
    //NO 异步  YES 同步
    [self.queue addOperations:@[op1,op2,op3] waitUntilFinished:NO];
    
    //通知是在主队列完成,也验证了依赖关系可跨队列指定！！
    [[NSOperationQueue mainQueue] addOperation:op4];
    
    
    //测试waitUntilFinished 同步异步
    NSLog(@"come here");
    
    
}
@end
