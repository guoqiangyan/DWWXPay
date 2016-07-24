//
//  NSString+Extension.h
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import <Foundation/Foundation.h>

/** md5加密 */
#import <CommonCrypto/CommonDigest.h>

/** 获取本机IP */
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include<arpa/inet.h>
#include<net/if.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunicode-whitespace"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN        @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#pragma clang diagnostic pop

@interface NSString (Extension)

/** md5 一般加密 */
+ (NSString *)dw_md5String:(NSString *)str;

/** md5 NB( 牛逼的意思 ) 加密 */
+ ( NSString *)dw_md5StringNB:( NSString *)str;

/** 获取随机数 */
+ (NSString *)dw_getNonce_str;

/** 获取IP地址 */
+ (NSString *)dw_getIPAddress:(BOOL)preferIPv4;

/** 获取付款XML字符串 */
+ (NSString *)dw_payMoenyGetXmlAppid:(NSString *)appid Mch_id:(NSString *)mch_id Nonce_str:(NSString *)nonce_str Sign:(NSString *)sign Body:(NSString *)body Out_trade_no:(NSString *)out_trade_no Total_fee:(int)total_fee Spbill_create_ip:(NSString *)spbill_create_ip Notify_url:(NSString *)notify_url Trade_type:(NSString *)trade_type;

/** 获取退款XML字符串 */
+ (NSString *)dw_returnedMoneyGetXmlAppid:(NSString *)appid Mch_id:(NSString *)mch_id Nonce_str:(NSString *)nonce_str Op_user_id:(NSString *)op_user_id Out_refund_no:(NSString *)out_refund_no Out_trade_no:(NSString *)out_trade_no Refund_fee:(int)refund_fee Total_fee:(int)total_fee Sign:(NSString *)sign;
@end
