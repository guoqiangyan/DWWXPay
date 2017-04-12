//
//  DWWXPaySuccessModels.m
//  DWWXPay
//
//  Created by dwang.vip on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "DWWXPaySuccessModels.h"

@implementation DWWXPaySuccessModels

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
           }
    return self;
}

+ (instancetype)wxPaySuccessWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   //防止程序case
}

@end
