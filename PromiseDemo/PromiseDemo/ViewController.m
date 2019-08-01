//
//  ViewController.m
//  PromiseDemo
//
//  Created by weil on 2019/7/30.
//  Copyright © 2019 AllYoga. All rights reserved.
//

#import "ViewController.h"
#import <FBLPromises.h>
#import <PromiseKit/PromiseKit.h>
#import "PromiseTest.h"

@interface ViewController ()
@property (nonatomic, strong) PromiseTest *promiseTest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self _test1];
//    [self _test2];
//    [self _test3];
//    [self _test4];
    self.promiseTest = [[PromiseTest alloc] init];
    [self.promiseTest excute];
}

- (void) _test1
{
    [[[[FBLPromise do:^id _Nullable{
        return [self _task1];
    }] then:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        return [self _task2:[value intValue]];
    }] then:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        [self _task3:[value intValue]];
        return nil;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void) _test2
{
    FBLPromise *promise1 = [self _task1];
    FBLPromise *promise2 = [self _task2:10];
    [[[FBLPromise all:@[promise1,promise2]] then:^id _Nullable(NSArray * _Nullable value) {
        return [self _task3:[value.lastObject intValue]];
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void) _test3
{
    FBLPromise *promise1 = [self _task1];
    FBLPromise *promise2 = [self _task2:10];
    [[[FBLPromise any:@[promise1,promise2]] then:^id _Nullable(NSArray * _Nullable value) {
        return [self _task3:[value.firstObject intValue]];
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void) _test4
{
//    PMKWhen(@[[self task1], [self task2:30]])
//    .then(^(NSArray *results) {
//        [self task3:[results.lastObject intValue]];
//    }).catch(^(NSError *error) {
//        NSLog(@"%@",error);
//    });
    [self task1].then(^ id (id value) {
        return [self task2:[value intValue]];
    }).then(^ id (id value) {
        return [self task3:[value intValue]];
    }).then(^(id value) {
        NSLog(@"%@",value);
    }).catch(^(NSError *error) {
        NSLog(@"%@",error);
    });
}

- (FBLPromise *) _task1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        NSLog(@"_task1 beign");
        fulfill(@(2));
    }];
}
- (FBLPromise *) _task2:(int)input
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        NSLog(@"_task2 begin");
//        fulfill(@(input * 10));
        reject([NSError errorWithDomain:@"yoyoyo" code:0 userInfo:nil]);
    }];
}
- (FBLPromise *) _task3:(int)input
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        for (int i = 0; i < 5; ++i) {
            NSLog(@"_task3 输出：%d", input * (i + 1));
        }
        reject([NSError errorWithDomain:@"hahaha" code:9 userInfo:@{@"url":@"http://www.baidu.com"}]);
    }];
}

- (AnyPromise *) task1
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolver) {
        NSLog(@"task1 begin");
        resolver(@(10));
    }];
}

- (AnyPromise *)task2:(int)input
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolver) {
        NSLog(@"task2 begin");
        resolver(@(input * 10));
    }];
}
- (AnyPromise *)task3:(int)input
{
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolver) {
        int sum = 0;
        for (int i = 0; i < 5; ++i) {
            NSLog(@"_task3 输出：%d", input * (i + 1));
            sum += input * (i + 1);
        }
        resolver(@(sum));
//        resolver([NSError errorWithDomain:@"hahaha" code:9 userInfo:@{@"url":@"http://www.baidu.com"}]);
    }];
    return promise;
}

@end
