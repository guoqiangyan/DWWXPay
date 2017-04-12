//
//  DWWXPay.h
//  DWWXPay
//
//  Created by dwang.vip on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//
//*******************Github:https://github.com/dwanghello/DWWXPay*************
//*******************QQ:739814184*********************************************
//*******************问题交流QQ群:577506623*************************************

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface DWWXPay : NSObject<WXApiDelegate>

/** 微信返回结果的回调 */
typedef void(^BackCode)(NSString *backCode);

/** 微信返回内容的回调 */
typedef void(^BackResp)(BaseResp *backResp);

/** 微信返回的错误信息 */
typedef void(^Return_ErrorCode)(NSString *return_msg, NSString *err_code, NSString *err_code_des);

/** 微信返回的交易订单状态信息 */
typedef void(^BackTrade_stateMsg)(NSString *backTrade_stateMsg, NSString *backTrade_state);

/**
 *  商户密钥
 */
@property (copy, nonatomic) NSString *partnerKey;

@property (copy, nonatomic) BackCode backCode;

@property (copy, nonatomic) BackResp backResp;

@property (copy, nonatomic) Return_ErrorCode return_ErrorCode;

@property (copy, nonatomic) BackTrade_stateMsg backTrade_stateMsg;

/** 检查是否安装微信 */
+ (BOOL)dw_isWXAppInstalled;

/** 判断当前微信的版本是否支持OpenApi */
+ (BOOL)dw_isWXAppSupportApi;

/** 获取微信的itunes安装地址 */
+ (NSString *)dw_getWXAppInstallUrl;

/** 获取当前微信SDK的版本号 */
+ (NSString *)dw_getApiVersion;

/**
 *  单例创建支付对象
 *
 */
+ (DWWXPay *)dw_sharedManager;

/**
 *  向微信终端程序注册第三方应用。
 *
 *  @param appid        微信开发者ID
 *  @param isEnableMTA  是否支持MTA数据上报
 */
- (BOOL)dw_RegisterApp:(NSString *)appid enableMTA:(BOOL)isEnableMTA;

/*!
 *  @author dwang
 *
 *  @brief 获取最终发送的付款XML
 *
 *  @param appid        微信开放平台审核通过的应用APPID
 *  @param mch_id       微信支付分配的商户号
 *  @param partnerKey   用户Key密钥
 *  @param body         商品描述
 *  @param out_trade_no 商户订单号
 *  @param total_fee    总金额
 *  @param notify_url   通知地址
 *  @param trade_type   交易类型
 *
 *  @return xmlString
 *
 */
- (NSString *)dw_payMoenySetAppid:(NSString *)appid Mch_id:(NSString *)mch_id PartnerKey:(NSString *)partnerKey Body:(NSString *)body Out_trade_no:(NSString *)out_trade_no total_fee:(int)total_fee Notify_url:(NSString *)notify_url Trade_type:(NSString *)trade_type;


/*!
 *  @author dwang
 *
 *  @brief 获取最终发送的查询订单XML
 *
 *  @param appid        微信开放平台审核通过的应用APPID
 *  @param mch_id       微信支付分配的商户号
 *  @param partnerKey   用户Key密钥
 *  @param out_trade_no 商户订单号
 *
 *  @return xmlString
 *
 */
- (NSString *)dw_queryOrderSetAppid:(NSString *)appid Mch_id:(NSString *)mch_id PartnerKey:(NSString *)partnerKey Out_trade_no:(NSString *)out_trade_no;


/*!
 *  @author dwang
 *
 *  @brief 发送支付/查询订单网络请求
 *
 *  @param url                      付款:@"https://api.mch.weixin.qq.com/pay/unifiedorder"
 *                                  查询订单:@"https://api.mch.weixin.qq.com/pay/orderquery"
 *  @param xml                      最终发送的XML
 *  @param return_ErrorCode         失败的错误信息
 *  @param backResp                 微信返回内容的回调
 *  @param backCode                 微信返回结果的回调
 *  @param backTrade_stateMsg       微信返回的交易状态信息
 *
 */
- (void)dw_post:(NSString*)url xml:(NSString*)xml return_ErrorCode:(Return_ErrorCode)return_ErrorCode backResp:(BackResp)backResp backCode:(BackCode)backCode BackTrade_stateMsg:(BackTrade_stateMsg)backTrade_stateMsg;


@end
