//
//  PromiseTest.m
//  PromiseDemo
//
//  Created by weil on 2019/7/30.
//  Copyright © 2019 AllYoga. All rights reserved.
//

#import "PromiseTest.h"
#import <FBLPromises.h>

@implementation PromiseTest
- (void)excute
{
//    [self _normalExample];
    [self _promiseExample];
//    [self _allExample];
//    [self _alwaysExample];
//    [self _anyExample];
//    [self _raceExample];
//    [self _recoverExample];
//    [self _reduceExample];
//    [self _timeoutExample];
//    [self _validateExample];
}

/********************       block嵌套类型              *********************/

//一般的block回调嵌套
- (void) _normalExample
{
    [self _normalBlock1:^(id value) {
        [self _normalBlock2:^(id value) {
            [self _normalBlock3:^(id value) {
                [self _normalBlock4:^(id value) {
                    [self _normalBlock5:^(id value) {
                        [self _normalBlock6:^(id value) {
                            
                        }];
                    }];
                }];
            }];
        }];
    }];
}
//正常blocks
- (void) _normalBlock1:(void(^)(id value))block
{
    NSLog(@"_normalBlock1");
    block(@(1));
}
- (void) _normalBlock2:(void(^)(id value))block
{
    block(@"_normalBlock2");
}
- (void) _normalBlock3:(void(^)(id value))block
{
    block(@"_normalBlock3");
}
- (void) _normalBlock4:(void(^)(id value))block
{
    block(@"_normalBlock4");
}
- (void) _normalBlock5:(void(^)(id value))block
{
    block(@"_normalBlock5");
}
- (void) _normalBlock6:(void(^)(id value))block
{
    block(@"_normalBlock6");
}
/********************       promise优化后的嵌套类型              *********************/
//采用promise
- (void) _promiseExample
{
    [[[[[[[FBLPromise do:^id _Nullable{
        return [self _promise1];
    }] then:^id _Nullable(id  _Nullable value) {
        return [self _promise2];
    }] then:^id _Nullable(id  _Nullable value) {
        return [self _promise3];
    }] then:^id _Nullable(id  _Nullable value) {
        return [self _promise4];
    }] then:^id _Nullable(id  _Nullable value) {
        return [self _promise5];
    }] then:^id _Nullable(id  _Nullable value) {
        return [self _promise6];
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//promises
- (FBLPromise *) _promise1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_promise1");
    }];
}
- (FBLPromise *) _promise2
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_promise2");
    }];
}
- (FBLPromise *) _promise3
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_promise3");
    }];
}
- (FBLPromise *) _promise4
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_promise4");
    }];
}
- (FBLPromise *) _promise5
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_promise5");
    }];
}
- (FBLPromise *) _promise6
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_promise6");
    }];
}

/********************       依赖关系then的使用             *********************/
//then
- (void) _thenExample
{
    [[[FBLPromise do:^id _Nullable{
        return [self _thenPromise1];
    }] then:^id _Nullable(id  _Nullable value) {
        return [self _thenPromise2:[value intValue]];
    }] then:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        return nil;
    }];
    
    [FBLPromise do:^id _Nullable{
        return [self _thenPromise1];
    }].then(^ id (id value){
        return [self _thenPromise2:[value intValue]];
    }).then(^ id (id value){
        NSLog(@"%@",value);
        return nil;
    });
}

- (FBLPromise *) _thenPromise1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(1));
    }];
}
- (FBLPromise *) _thenPromise2:(int)input
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        int sum = input + 10;
        fulfill(@(sum));
    }];
}
/********************       all的使用             *********************/
- (void) _allExample
{
    NSArray *promises = @[[self _allPromise1],[self _allPromise2]];
    [[[[FBLPromise all:promises] then:^id _Nullable(NSArray * _Nullable value) {
        NSLog(@"%@",value);
        return [self _allPromise3];
    }] then:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        return nil;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (FBLPromise *) _allPromise1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            fulfill(@"_allPromise1 执行完成");
        });
    }];
}
- (FBLPromise *) _allPromise2
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_allPromise2 执行完成");
    }];
}
- (FBLPromise *) _allPromise3
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_allPromise3 执行完成");
    }];
}

/********************       catch的使用             *********************/
- (void) _catchExample
{
    [[FBLPromise do:^id _Nullable{
        return [self _catchPromise];
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (FBLPromise *) _catchPromise
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        NSError *error = [NSError errorWithDomain:@"catch.example" code:0 userInfo:@{}];
        reject(error);
//        fulfill(error);
    }];
}

/********************      always的使用             *********************/
- (void) _alwaysExample
{
    [[[[FBLPromise do:^id _Nullable{
        return [self _alwaysPromise1];
    }] then:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        return [self _alwaysPromise2];
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }] always:^{
        NSLog(@"总是会执行");
    }];
}
- (FBLPromise *) _alwaysPromise1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        NSError *error = [NSError errorWithDomain:@"catch.example" code:0 userInfo:@{}];
        fulfill(error);
    }];
}
- (FBLPromise *) _alwaysPromise2
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_alwaysPromise2");
    }];
}

/********************      any的使用             *********************/
- (void) _anyExample
{
    [[[[FBLPromise any:@[[self _anyPromise1],[self _anyPromise2]]] then:^id _Nullable(NSArray * _Nullable value) {
        return [self _anyPromise3];
    }] then:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@",value);
        return value;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (FBLPromise *) _anyPromise1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_anyPromise1");
//        NSError *error = [NSError errorWithDomain:@"any.example" code:1 userInfo:@{}];
//        reject(error);
    }];
}
- (FBLPromise *) _anyPromise2
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        NSError *error = [NSError errorWithDomain:@"any.example" code:0 userInfo:@{}];
        reject(error);
    }];
}
- (FBLPromise *) _anyPromise3
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_anyPromise3");
    }];
}
/********************      race的使用             *********************/
- (void) _raceExample
{
    [[[FBLPromise race:@[[self _racePromise1],[self _racePromise2]]] then:^id _Nullable(id  _Nullable value) {
        return value;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (FBLPromise *) _racePromise1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
//        fulfill(@"_racePromise1");
        NSError *error = [NSError errorWithDomain:@"race.example" code:2 userInfo:@{}];
        reject(error);
    }];
}
- (FBLPromise *) _racePromise2
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
//        NSError *error = [NSError errorWithDomain:@"race.example" code:0 userInfo:@{}];
//        reject(error);
    }];
}
/********************      recover的使用             *********************/
- (void) _recoverExample
{
    [[[[self _recoverPromise1] recover:^id _Nullable(NSError * _Nonnull error) {
        if (error) {
            return [self _recoverPromise2];
        }
        return nil;
    }] then:^id _Nullable(id  _Nullable value) {
        return value;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (FBLPromise *) _recoverPromise1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        NSError *error = [NSError errorWithDomain:@"recover.example" code:0 userInfo:@{}];
//        reject(error);
        fulfill(error);
//        fulfill(@"_recoverPromise1");
    }];
}
- (FBLPromise *) _recoverPromise2
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@"_recoverPromise2");
    }];
}

/********************      reduce的使用             *********************/
- (void) _reduceExample
{
    [[[[self _reducePromise1] reduce:@[@(10), @(20)] combine:^id _Nullable(id  _Nullable partial, id  _Nonnull next) {
        return @([partial intValue] * [next intValue]);
    }] then:^id _Nullable(id  _Nullable value) {
        return value;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (FBLPromise *) _reducePromise1
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(3));
    }];
}

/********************      timeout的使用             *********************/
- (void) _timeoutExample
{
    [[[[self _timeoutPromise] timeout:2] then:^id _Nullable(id  _Nullable value) {
        return value;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (FBLPromise *) _timeoutPromise
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            fulfill(@"_timeoutPromise");
        });
    }];
}

/********************      validate的使用             *********************/
- (void) _validateExample
{
    [[[[self _validatePromise] validate:^BOOL(id  _Nullable value) {
        return ([value intValue] > 50);
    }] then:^id _Nullable(id  _Nullable value) {
        return value;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (FBLPromise *) _validatePromise
{
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        fulfill(@(20));
    }];
}
@end
