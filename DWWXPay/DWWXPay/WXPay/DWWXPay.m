//
//  DWWXPay.m
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "DWWXPay.h"
#import "WXApi.h"
#import "MJExtension.h"

#import "WXPayUnifiedModels.h"
#import "DWWXPaySuccessModels.h"
#import "NSString+Extension.h"
#import "DWWXPayXmlParser.h"

@implementation DWWXPay

static DWWXPay *sharedManager = nil;

+ (DWWXPay *)sharedManager {
    
    @synchronized (self) {
        
        if (!sharedManager) {
            
            sharedManager = [[[self class] alloc] init];
            
        }
        
    }
    
    return sharedManager;
}

- (BOOL)dw_RegisterApp:(NSString *)appid withDescription:(NSString *)appdesc {
    
    BOOL isbool = [WXApi registerApp:appid withDescription:appdesc];
    
    return isbool;
}

- (NSString *)dw_setAppid:(NSString *)appid Mch_id:(NSString *)mch_id PartnerKey:(NSString *)partnerKey Body:(NSString *)body Out_trade_no:(NSString *)out_trade_no total_fee:(int)total_fee Notify_url:(NSString *)notify_url Trade_type:(NSString *)trade_type {
    
    WXPayUnifiedModels *payUnifiedModels = [[WXPayUnifiedModels alloc] init];
    
    payUnifiedModels.appid = appid;
    
    payUnifiedModels.body = body;
    
    payUnifiedModels.out_trade_no = out_trade_no;
    
    payUnifiedModels.total_fee = total_fee;

    payUnifiedModels.partnerKey = partnerKey;
    
    payUnifiedModels.mch_id = mch_id;
    
    payUnifiedModels.notify_url = notify_url;
    
    payUnifiedModels.trade_type = trade_type;
    
    payUnifiedModels.nonce_str = [NSString dw_getNonce_str];
    
    payUnifiedModels.spbill_create_ip = [NSString dw_getIPAddress:YES];
    
    NSString *stringA = [NSString stringWithFormat:
                         @"appid=%@&body=%@&mch_id=%@&nonce_str=%@&notify_url=%@&out_trade_no=%@&spbill_create_ip=%@&total_fee=%d&trade_type=%@",
                         payUnifiedModels.appid,
                         payUnifiedModels.body,
                         payUnifiedModels.mch_id,
                         payUnifiedModels.nonce_str,
                         payUnifiedModels.notify_url,
                         payUnifiedModels.out_trade_no,
                         payUnifiedModels.spbill_create_ip,
                         payUnifiedModels.total_fee,
                         payUnifiedModels.trade_type];
    
    NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@",stringA,partnerKey];
    
    payUnifiedModels.sign = [NSString dw_md5String:stringSignTemp];
    
    NSString *xmlString = [NSString dw_GetXmlAppid:payUnifiedModels.appid Mch_id:payUnifiedModels.mch_id Nonce_str:payUnifiedModels.nonce_str Sign:payUnifiedModels.sign Body:payUnifiedModels.body Out_trade_no:payUnifiedModels.out_trade_no Total_fee:payUnifiedModels.total_fee Spbill_create_ip:payUnifiedModels.spbill_create_ip Notify_url:payUnifiedModels.notify_url Trade_type:payUnifiedModels.trade_type];
    
    return xmlString;
    
}


- (void)dw_post:(NSString*)url xml:(NSString*)xml callback:(void (^)(NSData* data, NSError* error))callback {
    
    if(callback==nil)
        return;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:12];
    
    [request setHTTPMethod:@"POST"];
    
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
        if(error)
            callback(nil, error);
        
        else if(data.length==0)
            callback(nil, [NSError errorWithDomain:NSStringFromClass(self.class) code:0 userInfo:@{NSLocalizedDescriptionKey:@"返回数据长度为0"}]);
        
        if(data.length){
            callback(data, nil);
            
           NSDictionary* respParams = [DWWXPayXmlParser dw_parseData:data];
            
            DWWXPaySuccessModels *paySuccessModels = [DWWXPaySuccessModels mj_objectWithKeyValues:respParams];
            
            if ([paySuccessModels.return_code isEqualToString:@"SUCCESS"] ) {
                
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = paySuccessModels.mch_id;
                request.prepayId= paySuccessModels.prepay_id;
                request.package = @"Sign=WXPay";
                request.nonceStr= paySuccessModels.nonce_str;
                time_t now;
                time(&now);
                request.timeStamp = (UInt32)[[NSString stringWithFormat:@"%ld", now] integerValue];
                
                
                NSString *stringA = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%d",paySuccessModels.appid,request.nonceStr,request.package,request.partnerId,request.prepayId,request.timeStamp];
                
                WXPayUnifiedModels *payUnifiedModels = [[WXPayUnifiedModels alloc] init];
                
                NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@",stringA, payUnifiedModels.partnerKey];
                
                request.sign = [[NSString dw_md5String:stringSignTemp] uppercaseString];
                
                [WXApi sendReq:request];
                
            }

            
        }
        
   
    }];
    
    [dataTask resume] ; // 开始
}


@end
