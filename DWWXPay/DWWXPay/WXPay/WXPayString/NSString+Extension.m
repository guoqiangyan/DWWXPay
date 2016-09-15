//
//  NSString+Extension.m
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "NSString+Extension.h"
#import "DWGetIP.h"

@implementation NSString (Extension)

#pragma mark ---md5 一般加密
+ (NSString *)dw_md5String:(NSString *)str {
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    NSString *md5Str = [md5String uppercaseString];
    
    return md5Str;
    
}


#pragma mark ---md5 NB( 牛逼的意思 ) 加密
+ ( NSString *)dw_md5StringNB:( NSString *)str {
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    [md5String appendFormat : @"%02x" ,mdc[ 0 ]];
    
    for ( int i = 1 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]^mdc[ 0 ]];
        
    }
    
    NSString *md5Str = [md5String uppercaseString];
    
    return md5Str;
    
}

#pragma mark ---获取IP地址
+ (NSString *)dw_getIPAddress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i;
    //    NSString *deviceIP = nil;
    for (i=0; i<MAXADDRS; ++i)
    {
        static unsigned long localHost = 0x7F000001;            // 127.0.0.1
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
        
        return [NSString stringWithFormat:@"%s",ip_names[i]];
    }
    
    return @"192.168.0.1";
}

#pragma mark ---获取随机数
+ (NSString *)dw_getNonce_str {
    
    NSArray *sourceStr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                           @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",
                           @"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",
                           @"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    NSString *resultStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < 32; i ++) {
        
        int value = arc4random() % 32;
        
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"%@",sourceStr[value]]];
    }
    
    return [NSString stringWithString:resultStr];
    
}


#pragma mark ---支付xmlString
+ (NSString *)dw_payMoenyGetXmlAppid:(NSString *)appid
                               Mch_id:(NSString *)mch_id
                                Nonce_str:(NSString *)nonce_str
                                Sign:(NSString *)sign
                                Body:(NSString *)body
                                Out_trade_no:(NSString *)out_trade_no
                                Total_fee:(int)total_fee
                                Spbill_create_ip:(NSString *)spbill_create_ip
                                Notify_url:(NSString *)notify_url
                                Trade_type:(NSString *)trade_type {
    
    NSString *xmlString = [NSString stringWithFormat:@"<xml><appid>%@</appid><body>%@</body><mch_id>%@</mch_id><nonce_str>%@</nonce_str><notify_url>%@</notify_url><out_trade_no>%@</out_trade_no><spbill_create_ip>%@</spbill_create_ip><total_fee>%d</total_fee><trade_type>%@</trade_type><sign>%@</sign></xml>",
                           appid,
                           body,
                           mch_id,
                           nonce_str,
                           notify_url,
                           out_trade_no,
                           spbill_create_ip,
                           total_fee,
                           trade_type,
                           sign];
    
    return [NSString stringWithString:xmlString];
    
}

#pragma mark ---查询订单xmlString
+ (NSString *)dw_queryOrderGetXmlAppid:(NSString *)appid
                                 Mch_id:(NSString *)mch_id
                                 Nonce_str:(NSString *)nonce_str
                                 Out_trade_no:(NSString *)out_trade_no
                                 Sign:(NSString *)sign {
    
    NSString *xmlString = [NSString stringWithFormat:@"<xml><appid>%@</appid><mch_id>%@</mch_id><nonce_str>%@</nonce_str><out_trade_no>%@</out_trade_no><sign>%@</sign></xml>",
                           appid,
                           mch_id,
                           nonce_str,
                           out_trade_no,
                           sign];
    
    
    return [NSString stringWithString:xmlString];
}

@end
