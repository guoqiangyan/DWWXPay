//
//  NSString+Extension.m
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "NSString+Extension.h"

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


#pragma mark ---获取IP地址
+ (NSString *)dw_getIPAddress:(BOOL)preferIPv4 {
    
    NSArray *searchArray = preferIPv4 ?
    
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    struct ifaddrs *interfaces;
    
    if(!getifaddrs(&interfaces)) {
        
    struct ifaddrs *interface;
        
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                
                continue;
            
            }
            
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                
                NSString *type;
                
                if(addr->sin_family == AF_INET) {
                    
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        
                        type = IP_ADDR_IPv4;
                        
                    }
                    
                } else {
                    
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        
                        type = IP_ADDR_IPv6;
                        
                    }
                    
                }
                
                if(type) {
                    
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    
                }
                
            }
            
        }
        
        freeifaddrs(interfaces);
        
    }
    
    NSDictionary *addressess = [addresses count] ? addresses : nil;
    
    __block NSString *address;
    
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     
     {
         
         address = addressess[key];
         
         if(address) *stop = YES;
         
     } ];
    
    return address ? address : @"0.0.0.0";
    
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
