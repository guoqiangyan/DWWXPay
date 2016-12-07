//
//  NSString+Extension.h
//  DWWXPay
//
//  Created by dwang.vip on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import <Foundation/Foundation.h>

/** md5加密 */
#import <CommonCrypto/CommonDigest.h>


@interface NSString (Extension)

/** md5 一般加密 */
+ (NSString *)dw_md5String:(NSString *)str;

/** md5 NB( 牛逼的意思 ) 加密 */
+ ( NSString *)dw_md5StringNB:( NSString *)str;

/** 获取随机数 */
+ (NSString *)dw_getNonce_str;

/** 获取IP地址 */
+ (NSString *)dw_getIPAddress;

/** 获取付款XML字符串 */
+ (NSString *)dw_payMoenyGetXmlAppid:(NSString *)appid Mch_id:(NSString *)mch_id Nonce_str:(NSString *)nonce_str Sign:(NSString *)sign Body:(NSString *)body Out_trade_no:(NSString *)out_trade_no Total_fee:(int)total_fee Spbill_create_ip:(NSString *)spbill_create_ip Notify_url:(NSString *)notify_url Trade_type:(NSString *)trade_type;

/** 获取查询订单XML字符串 */
+ (NSString *)dw_queryOrderGetXmlAppid:(NSString *)appid Mch_id:(NSString *)mch_id Nonce_str:(NSString *)nonce_str Out_trade_no:(NSString *)out_trade_no Sign:(NSString *)sign;
@end
