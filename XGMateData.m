//
//  XGMateData.m
//  QianQianDog
//
//  Created by whg on 2017/12/5.
//  Copyright © 2017年 LongPei. All rights reserved.
//

#import "XGMateData.h"

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@interface XGMateData()
{
    NSMutableArray *_dataArr;
    NSMutableDictionary *_flagDic;
    dispatch_semaphore_t _lock;
}

@end
@implementation XGMateData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArr = [NSMutableArray array];
        _flagDic = [NSMutableDictionary dictionary];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

+ (instancetype)mateData
{
    return [[self alloc] init];
}

+ (XGMateData *)dataWithObjects:(NSArray *)arr
{
    XGMateData *data = [self mateData];
    for (id obj in arr) {
        NSString *key = @(data->_flagDic.count).stringValue;
        [data->_flagDic setObject:obj forKey:key];
    }
    [data reloadDataArray];
    return data;
}

- (void)addObjectWhenInstall:(id)obj
{
    NSString *key = @(_flagDic.count).stringValue;
    [_flagDic setObject:obj forKey:key];
}

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index
{
    LOCK(
         NSString *key = @(index).stringValue;
         [_flagDic setObject:anObject forKey:key];
         [self reloadDataArray];
    );
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    id obj = _flagDic[@(idx).stringValue];
    return obj;
}

-(void)removeObject:(id)anObject
{
    LOCK(
         NSArray *keys = [_flagDic allKeysForObject:anObject];
         for (NSString *key in keys) {
             [_flagDic removeObjectForKey:key];
         }
         [_dataArr removeObject:anObject];
         );
}

-(void)removeObjectAtIndex:(NSUInteger)index
{
    NSString *key = @(index).stringValue;
    id obj = _flagDic[key];
    if (obj != nil) {
        [_dataArr removeObject:obj];
    }
    [_flagDic removeObjectForKey:key];
}

-(void)removeAllObjects
{
    [_flagDic removeAllObjects];
    [_dataArr removeAllObjects];
}

- (void)reloadDataArray
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0; i <= self.maxIndex; i++) {
        id obj = self[i];
        if (obj != nil) {
            [arr addObject:self[i]];
        }
    }
    _dataArr = arr;
}

-(NSUInteger)count
{
    return _flagDic.count;
}

- (NSUInteger)maxIndex
{
    NSUInteger max = [[_flagDic.allKeys valueForKeyPath:@"@max.floatValue"] unsignedIntegerValue];
    return max;
}

- (NSArray<NSString *>*)allIndexs
{
    NSArray *arr = _flagDic.allKeys;
    NSArray *array = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         return [obj1 compare:obj2];
    }];
    return array;
}

- (NSArray *)allObjects
{
    return _dataArr;
}

#pragma mark - 快速遍历

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer count:(NSUInteger)len
{
    return [_dataArr countByEnumeratingWithState:state objects:buffer count:len];
}

@end

@implementation NSArray(MateData)
- (XGMateData *)mateDataWithIndex:(NSUInteger)firstIndex,... NS_REQUIRES_NIL_TERMINATION
{
    // 取出第一个参数
    XGMateData *data = [XGMateData mateData];
    data[firstIndex] = self[firstIndex];
    // 定义一个指向个数可变的参数列表指针；
    va_list args;
    // 用于存放取出的参数
    NSUInteger arg;
    // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
    va_start(args, firstIndex);
    // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
    while ((arg = va_arg(args, NSUInteger))) {
        data[arg] = self[arg];
    }
    // 清空参数列表，并置参数指针args无效
    va_end(args);
    
    return data;
}
@end
