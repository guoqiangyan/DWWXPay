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

/** 微信退款申请发送成功的回调 */
typedef void(^ReturnedMoney)(NSString *returnedMoney);

typedef void(^Return_ErrorCode)(NSString *return_msg, NSString *err_code, NSString *err_code_des);

@property (copy, nonatomic) NSString *partnerKey;

@property (copy, nonatomic) BackCode backCode;

@property (copy, nonatomic) BackResp backResp;

@property (copy, nonatomic) ReturnedMoney returnedMoney;

@property (copy, nonatomic) Return_ErrorCode return_ErrorCode;

+ (DWWXPay *) dw_sharedManager;

/**
 *  向微信终端程序注册第三方应用。
 *
 *  @param appid   微信开发者ID
 *  @param appdesc 应用附加信息，长度不超过1024字节
 */
- (BOOL)dw_RegisterApp:(NSString *)appid withDescription:(NSString *)appdesc;

/**----------------------------------------付款----------------------------------*/
/*!
 *  @author dwang, 16-07-08 19:07:57
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
 *  @since <#version number#>
 */
- (NSString *)dw_payMoenySetAppid:(NSString *)appid Mch_id:(NSString *)mch_id PartnerKey:(NSString *)partnerKey Body:(NSString *)body Out_trade_no:(NSString *)out_trade_no total_fee:(int)total_fee Notify_url:(NSString *)notify_url Trade_type:(NSString *)trade_type;

/**--------------------------------------退款------------------------------------*/
/*!
 *  @author dwang, 16-07-24 13:07:11
 *
 *  @brief 获取最终发送的退款XML
 *
 *  @param appid         微信开放平台审核通过的应用APPID
 *  @param mch_id        微信支付分配的商户号
 *  @param partnerKey    用户Key密钥
 *  @param out_trade_no  商户侧传给微信的订单号
 *  @param out_refund_no 商户系统内部的退款单号，商户系统内部唯一，同一退款单号多次请求只退一笔
 *  @param total_fee     订单总金额，单位为分，只能为整数
 *  @param refund_fee    退款总金额，订单总金额，单位为分，只能为整数
 *  @param op_user_id    操作员帐号, 默认为商户号
 *
 *  @return xmlString
 *
 *  @since <#version number#>
 */
- (NSString *)dw_returnedMoneySetAppid:(NSString *)appid Mch_id:(NSString *)mch_id PartnerKey:(NSString *)partnerKey Out_trade_no:(NSString *)out_trade_no Out_refund_no:(NSString *)out_refund_no Total_fee:(int)total_fee Refund_fee:(int)refund_fee Op_user_id:(NSString *)op_user_id;

/**---------------------------------------网络请求------------------------------------------------*/
/*!
 *  @author dwang, 16-07-24 14:07:22
 *
 *  @brief 网络请求
 *
 *  @param url              付款:@"https://api.mch.weixin.qq.com/pay/unifiedorder"
 *                          退款:@"https://api.mch.weixin.qq.com/secapi/pay/refund"
 *  @param xml              最终发送的XML
 *  @param return_ErrorCode 失败的错误信息
 *  @param backResp         微信返回内容的回调
 *  @param backCode         微信返回结果的回调
 *  @param returnedMoney    申请退款结果的回调
 *
 *  @since <#version number#>
 */- (void)dw_post:(NSString*)url xml:(NSString*)xml return_ErrorCode:(Return_ErrorCode)return_ErrorCode backResp:(BackResp)backResp backCode:(BackCode)backCode returnedMoney:(ReturnedMoney)returnedMoney;


@end
