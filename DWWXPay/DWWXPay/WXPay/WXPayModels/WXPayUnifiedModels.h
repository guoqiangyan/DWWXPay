//
//  WXPayUnifiedModels.h
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXPayUnifiedModels : NSObject

/**
 *  用户Key密钥
 */
@property (copy, nonatomic) NSString *partnerKey;

/**
 *  应用ID
 *  微信开放平台审核通过的应用APPID
 *  必填
 */
@property (copy, nonatomic) NSString *appid;

/**
 *  商户号
 *  微信支付分配的商户号
 *  必填
 */
@property (copy, nonatomic) NSString *mch_id;

/**
 *  设备号
 *  终端设备号(门店号或收银设备ID)，默认请传"WEB"
 *  可选
 */
@property (copy, nonatomic) NSString *device_info;

/**
 *  随机字符串
 *  随机字符串，不长于32位
 *  必填
 */
@property (copy, nonatomic) NSString *nonce_str;

/**
 *  签名
 *  必填
 */
@property (copy, nonatomic) NSString *sign;

/**
 *  商品描述
 *  商品或支付单简要描述
 *  必填
 */
@property (copy, nonatomic) NSString *body;

/**
 *  商品详情
 *  商品名称明细列表
 *  可选
 */
@property (copy, nonatomic) NSString *detail;

/**
 *  附加数据
 *  附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
 *  可选
 */
@property (copy, nonatomic) NSString *attach;

/**
 *  商户订单号
 *  商户系统内部的订单号,32个字符内、可包含字母
 *  必填
 */
@property (copy, nonatomic) NSString *out_trade_no;

/**
 *  货币类型
 *  符合ISO 4217标准的三位字母代码，默认人民币：CNY，
 *  可选
 */
@property (copy, nonatomic) NSString *fee_type;

/**
 *  总金额
 *  订单总金额，单位为分
 *  必填
 */
@property (assign, nonatomic) int total_fee;

/**
 *  终端IP
 *  用户端实际ip
 *  必填
 */
@property (copy, nonatomic) NSString *spbill_create_ip;

/**
 *  交易起始时间
 *  订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。
 *  可选
 */
@property (copy, nonatomic) NSString *time_start;

/**
 *  交易结束时间
 *  订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010
 *  可选
 */
@property (copy, nonatomic) NSString *time_expire;

/**
 *  商品标记
 *  商品标记，代金券或立减优惠功能的参数，
 *  可选
 */
@property (copy, nonatomic) NSString *goods_tag;

/**
 *  通知地址
 *  接收微信支付异步通知回调地址，通知url必须为直接可访问的url，不能携带参数。
 *  必填
 */
@property (copy, nonatomic) NSString *notify_url;

/**
 *  交易类型
 *  支付类型
 *  必填
 */
@property (copy, nonatomic) NSString *trade_type;

/**
 *  指定支付方式
 *  no_credit--指定不能使用信用卡支付
 *  可选
 */
@property (copy, nonatomic) NSString *limit_pay;



@end
