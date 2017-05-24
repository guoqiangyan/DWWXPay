//
//  NSString+Extension.m
//  DWWXPay
//
//  Created by dwang.vip on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "NSString+Extension.h"
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>


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
+ (NSString *)dw_getIPAddress {
    
    int sockfd =socket(AF_INET,SOCK_DGRAM, 0);
    
    //    if (sockfd <</span> 0) return nil;
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE =4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len =sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
            
            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
            
            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
            
            
            
            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    close(sockfd);
    
    NSString *deviceIP =@"";
    
    for (int i=0; i < ips.count; i++)
        
    {
        
        if (ips.count >0)
            
        {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
        
    }
    return deviceIP;
    
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
