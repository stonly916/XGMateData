//
//  XGMateData.h
//  QianQianDog
//
//  Created by whg on 2017/12/5.
//  Copyright © 2017年 LongPei. All rights reserved.
//

#import <Foundation/Foundation.h>

//配对数组：用于将对象配对到对应下标位置

@interface XGMateData : NSObject <NSFastEnumeration>

+ (instancetype)mateData;
+ (XGMateData *)dataWithObjects:(NSArray *)arr;

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

-(void)removeObject:(id)anObject;
-(void)removeObjectAtIndex:(NSUInteger)index;
-(void)removeAllObjects;
-(NSUInteger)count;
- (NSUInteger)maxIndex;
- (NSArray<NSString *>*)allIndexs;
- (NSArray *)allObjects;

@end

@interface NSArray(MateData)
- (XGMateData *)mateDataWithIndex:(NSUInteger)firstIndex,... NS_REQUIRES_NIL_TERMINATION;
@end
