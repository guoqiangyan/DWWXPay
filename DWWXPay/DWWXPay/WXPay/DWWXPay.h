//
//  DWWXPay.h
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWWXPay : NSObject

+ (DWWXPay *) sharedManager;

/**
 *  向微信终端程序注册第三方应用。
 *
 *  @param appid   微信开发者ID
 *  @param appdesc 应用附加信息，长度不超过1024字节
 */
- (BOOL)dw_RegisterApp:(NSString *)appid withDescription:(NSString *)appdesc;

/**
 *  填写支付本地参数获取XML
 *
 *  @param appid      <#appid description#>
 *  @param mch_id     <#mch_id description#>
 *  @param partnerKey <#partnerKey description#>
 *  @param total_fee  <#total_fee description#>
 *  @param notify_url <#notify_url description#>
 *  @param trade_type <#trade_type description#>
 *
 *  @return 最终发送的xmlString
 */
- (NSString *)dw_setAppid:(NSString *)appid Mch_id:(NSString *)mch_id PartnerKey:(NSString *)partnerKey Body:(NSString *)body Out_trade_no:(NSString *)out_trade_no total_fee:(int)total_fee Notify_url:(NSString *)notify_url Trade_type:(NSString *)trade_type;

/**
 *  网络请求
 *
 *  @param url      https://api.mch.weixin.qq.com/pay/unifiedorder
 *  @param xml      xmlString
 *  @param callback <#callback description#>
 */
- (void)dw_post:(NSString*)url xml:(NSString*)xml callback:(void (^)(NSData* data, NSError* error))callback;

@end
