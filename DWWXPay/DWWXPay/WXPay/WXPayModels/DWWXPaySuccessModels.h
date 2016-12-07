//
//  DWWXPaySuccessModels.h
//  DWWXPay
//
//  Created by dwang.vip on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWWXPaySuccessModels : NSObject

/**
 *  此字段是通信标识，非交易标识，交易是否成功需要查看result_code来判断
 *  SUCCESS/FAIL
 */
@property (copy, nonatomic) NSString *return_code;

/**
 *  返回信息，如非空，为错误原因
 *  签名失败
 *  参数格式校验错误
 */
@property (copy, nonatomic) NSString *return_msg;

/**
 *  应用APPID
 */
@property (copy, nonatomic) NSString *appid;

/**
 *  商户号
 */
@property (copy, nonatomic) NSString *mch_id;

/**
 *  设备号，
 */
@property (copy, nonatomic) NSString *device_info;

/**
 *  随机字符串
 */
@property (copy, nonatomic) NSString *nonce_str;

/**
 *  签名
 */
@property (copy, nonatomic) NSString* sign;

/**
 *  业务结果
 */
@property (copy, nonatomic) NSString *result_code;

/**
 *  错误代码
 */
@property (copy, nonatomic) NSString *err_code;

/**
 *  错误代码描述
 */
@property (copy, nonatomic) NSString *err_code_des;

/**
 *  交易类型
 */
@property (copy, nonatomic) NSString *trade_type;

/**
 *  预支付交易会话标识
 */
@property (copy, nonatomic) NSString *prepay_id;

/**
 *  交易状态
 */
@property (copy, nonatomic) NSString *trade_state;

@end
