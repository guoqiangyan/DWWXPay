//
//  DWWXPay.h
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface DWWXPay : NSObject<WXApiDelegate>

/** 微信返回结果的回调 */
typedef void(^BackCode)(NSString *backCode);

/** 微信返回内容的回调 */
typedef void(^BackResp)(BaseResp *backResp);

typedef void(^Return_ErrorCode)(NSString *return_msg, NSString *err_code, NSString *err_code_des);

@property (copy, nonatomic) NSString *partnerKey;

@property (copy, nonatomic) BackCode backCode;

@property (copy, nonatomic) BackResp backResp;

@property (copy, nonatomic) Return_ErrorCode return_ErrorCode;

+ (DWWXPay *) dw_sharedManager;

/**
 *  向微信终端程序注册第三方应用。
 *
 *  @param appid   微信开发者ID
 *  @param appdesc 应用附加信息，长度不超过1024字节
 */
- (BOOL)dw_RegisterApp:(NSString *)appid withDescription:(NSString *)appdesc;

/*!
 *  @author dwang, 16-07-08 19:07:57
 *
 *  @brief 获取最终发送的XML
 *
 *  @param appid        应用id
 *  @param mch_id       商户号
 *  @param partnerKey   用户Key密钥
 *  @param body         商品描述
 *  @param out_trade_no 商户订单号
 *  @param total_fee    总金额
 *  @param notify_url   通知地址
 *  @param trade_type   交易类型
 *
 *  @return xmlString
 *
 *  @since <#version number#>
 */- (NSString *)dw_setAppid:(NSString *)appid Mch_id:(NSString *)mch_id PartnerKey:(NSString *)partnerKey Body:(NSString *)body Out_trade_no:(NSString *)out_trade_no total_fee:(int)total_fee Notify_url:(NSString *)notify_url Trade_type:(NSString *)trade_type;

/**
 *  网络请求
 *
 *  @param url      https://api.mch.weixin.qq.com/pay/unifiedorder
 *  @param xml      xmlString
 *  @param backCode  微信支付的返回结果
 */
- (void)dw_post:(NSString*)url xml:(NSString*)xml return_ErrorCode:(Return_ErrorCode)return_ErrorCode backResp:(BackResp)backResp backCode:(BackCode)backCode;


@end
