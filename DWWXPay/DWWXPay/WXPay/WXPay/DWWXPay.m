//
//  DWWXPay.m
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "DWWXPay.h"
#import "MJExtension.h"

#import "DWWXPaySuccessModels.h"
#import "NSString+Extension.h"
#import "DWWXPayXmlParser.h"


@implementation DWWXPay

static DWWXPay *sharedManager = nil;

+ (DWWXPay *)dw_sharedManager {
    
    @synchronized (self) {
        
        if (!sharedManager) {
            
            sharedManager = [[[self class] alloc] init];
            
        }
        
    }
    
    return sharedManager;
}

#pragma mark ---检测是否安装微信
+ (BOOL)dw_isWXAppInstalled {
   return [WXApi isWXAppInstalled];
}

#pragma mark ---判断当前微信的版本是否支持OpenApi
+ (BOOL) dw_isWXAppSupportApi {
    return [WXApi isWXAppSupportApi];
}

#pragma mark ---获取微信的itunes安装地址
+ (NSString *)dw_getWXAppInstallUrl {
    return [WXApi getWXAppInstallUrl];
}

#pragma mark ---获取当前微信SDK的版本号
+ (NSString *)dw_getApiVersion {
    return [WXApi getApiVersion];
}

#pragma mark ---向微信终端程序注册第三方应用
- (BOOL)dw_RegisterApp:(NSString *)appid withDescription:(NSString *)appdesc {
    
    BOOL isbool = [WXApi registerApp:appid withDescription:appdesc];
    
    return isbool;
}

#pragma mark ---获取支付最终发送的xml字符串
- (NSString *)dw_payMoenySetAppid:(NSString *)appid
                            Mch_id:(NSString *)mch_id
                            PartnerKey:(NSString *)partnerKey
                            Body:(NSString *)body
                            Out_trade_no:(NSString *)out_trade_no
                            total_fee:(int)total_fee
                            Notify_url:(NSString *)notify_url
                            Trade_type:(NSString *)trade_type {
    
    self.partnerKey = partnerKey;
    
    NSString *nonce_str =  [NSString dw_getNonce_str];
    
    NSString *spbill_create_ip = [NSString dw_getIPAddress];
    
    NSString *stringA = [NSString stringWithFormat:
                         @"appid=%@&body=%@&mch_id=%@&nonce_str=%@&notify_url=%@&out_trade_no=%@&spbill_create_ip=%@&total_fee=%d&trade_type=%@",
                         appid,
                         body,
                         mch_id,
                         nonce_str,
                         notify_url,
                         out_trade_no,
                         spbill_create_ip,
                         total_fee,
                         trade_type];
    
    
    NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@",stringA,partnerKey];
    
    NSString *sign = [NSString dw_md5String:stringSignTemp];
    
    NSString *xmlString = [NSString dw_payMoenyGetXmlAppid:appid
                                                    Mch_id:mch_id
                                                    Nonce_str:nonce_str
                                                    Sign:sign
                                                    Body:body
                                                    Out_trade_no:out_trade_no
                                                    Total_fee:total_fee
                                                    Spbill_create_ip:spbill_create_ip
                                                    Notify_url:notify_url
                                                    Trade_type:trade_type];
    
    return xmlString;
    
}

#pragma mark ---获取查询订单最终发送的xml字符串
- (NSString *)dw_queryOrderSetAppid:(NSString *)appid
                              Mch_id:(NSString *)mch_id
                              PartnerKey:(NSString *)partnerKey
                              Out_trade_no:(NSString *)out_trade_no {
    
    self.partnerKey = partnerKey;
    
    NSString *nonce_str =  [NSString dw_getNonce_str];
    
    NSString *stringA = [NSString stringWithFormat:
                         @"appid=%@&mch_id=%@&nonce_str=%@&out_trade_no=%@",
                         appid,
                         mch_id,
                         nonce_str,
                         out_trade_no];
    
    NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@",stringA,partnerKey];
    
    NSString *sign = [NSString dw_md5String:stringSignTemp];
    
    NSString *xmlString = [NSString dw_queryOrderGetXmlAppid:appid
                                                       Mch_id:mch_id
                                                       Nonce_str:nonce_str
                                                       Out_trade_no:out_trade_no
                                                       Sign:sign];
    
    return xmlString;
}

#pragma mark ---发送微信支付/查询订单请求
- (void)dw_post:(NSString*)url
            xml:(NSString*)xml
            return_ErrorCode:(Return_ErrorCode)return_ErrorCode
            backResp:(BackResp)backResp backCode:(BackCode)backCode
            BackTrade_stateMsg:(BackTrade_stateMsg)backTrade_stateMsg {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL: [NSURL URLWithString:url]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval:12];
    
    [request setHTTPMethod:@"POST"];
    
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession]
                                       dataTaskWithRequest:request
                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(data.length) {
            
            NSDictionary* respParams = [DWWXPayXmlParser dw_parseData:data];
            
            DWWXPaySuccessModels *paySuccessModels = [DWWXPaySuccessModels mj_objectWithKeyValues:respParams];
            
            if ([paySuccessModels.return_code isEqualToString:@"SUCCESS"]) {
                
                if ([paySuccessModels.result_code isEqualToString:@"SUCCESS"]) {
                    
                    if ([url isEqualToString:@"https://api.mch.weixin.qq.com/pay/orderquery"]) {
                        
                        if ([paySuccessModels.trade_state isEqualToString:@"SUCCESS"]) {
                            
                            [self backTrade_stateMsg:@"支付成功" backTrade_state:paySuccessModels.trade_state];
                            
                        }else if ([paySuccessModels.trade_state isEqualToString:@"REFUND"]) {
                            
                            [self backTrade_stateMsg:@"转入退款" backTrade_state:paySuccessModels.trade_state];
                            
                        }else if ([paySuccessModels.trade_state isEqualToString:@"NOTPAY"]) {
                            
                             [self backTrade_stateMsg:@"未支付" backTrade_state:paySuccessModels.trade_state];
                            
                        }else if ([paySuccessModels.trade_state isEqualToString:@"CLOSED"]) {
                            
                            [self backTrade_stateMsg:@"已关闭" backTrade_state:paySuccessModels.trade_state];
                            
                        }else if ([paySuccessModels.trade_state isEqualToString:@"REVOKED"]) {
                            
                            [self backTrade_stateMsg:@"用户支付中" backTrade_state:paySuccessModels.trade_state];
                            
                        }else if ([paySuccessModels.trade_state isEqualToString:@"PAYERROR"]) {
                            
                            [self backTrade_stateMsg:@"支付失败(其他原因，如银行返回失败)" backTrade_state:paySuccessModels.trade_state];
                        }
                        
                         return ;
                    }
                
                }else {
                    
                    if (self.return_ErrorCode) {
                        
                        NSString *err_code_des;
                        
                        if ([paySuccessModels.err_code isEqualToString:@"ORDERNOTEXIST"]) {
                            
                            err_code_des = @"此交易订单号不存在\n该API只能查提交支付交易返回成功的订单，请商户检查需要查询的订单号是否正确";
                            
                        }else if ([paySuccessModels.err_code isEqualToString:@"SYSTEMERROR"]) {
                            
                            err_code_des = @"系统错误\n系统异常，请再调用发起查询";
                        }
                        
                        self.return_ErrorCode(paySuccessModels.return_msg,paySuccessModels.err_code,err_code_des);
                        
                        return;
                    }
                }
                
                PayReq *request = [[PayReq alloc] init];
                
                request.partnerId = paySuccessModels.mch_id;
                
                request.prepayId= paySuccessModels.prepay_id;
                
                request.package = @"Sign=WXPay";
                
                request.nonceStr= [NSString dw_getNonce_str];
                
                //获取时间戳
                time_t now;
                time(&now);
                request.timeStamp = (UInt32)[[NSString stringWithFormat:@"%ld", now] integerValue];
                
                NSString *stringA = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%d",
                                     paySuccessModels.appid,
                                     request.nonceStr,
                                     request.package,
                                     request.partnerId,
                                     request.prepayId,
                                     request.timeStamp];
                
                NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@",stringA,self.partnerKey];
                
                request.sign = [[NSString dw_md5String:stringSignTemp] uppercaseString];
                
                //发起支付请求
                [WXApi sendReq:request];
                
            }else if(![paySuccessModels.return_code isEqualToString:@"SUCCESS"]){
                
                if (self.return_ErrorCode) {
                    
                    self.return_ErrorCode(paySuccessModels.return_msg,
                                          paySuccessModels.err_code,
                                          paySuccessModels.err_code_des);
                }
            }
        }
    }];
    
    [dataTask resume]; // 开始
    
#pragma mark ---微信返回的错误信息
    self.return_ErrorCode = ^(NSString *msg, NSString *code, NSString *codeMsg) {
        
        return_ErrorCode(msg,code,codeMsg);
        
    };
    
#pragma mark ---微信返回内容
    self.backResp = ^(BaseResp *resp) {
        
        backResp(resp);
        
    };
    
#pragma mark ---微信返回结果
    self.backCode = ^(NSString *code){
        
        backCode(code);
        
    };
    
#pragma mark ---微信返回的交易订单状态信息
    self.backTrade_stateMsg = ^(NSString *trade_stateMsg, NSString *trade_state) {
        
        backTrade_stateMsg(trade_stateMsg, trade_state);
        
    };
    
}

#pragma mark ---微信返回结果
- (void)backCode:(NSString *)backCode {
    
    if (self.backCode) {
        
        self.backCode(backCode);
        
    }
    
}

#pragma mark ---微信返回的交易订单状态信息
- (void)backTrade_stateMsg:(NSString *)backTrade_stateMsg backTrade_state:(NSString *)backTrade_state{
    
    if (self.backTrade_stateMsg) {
        
        self.backTrade_stateMsg(backTrade_stateMsg, backTrade_state);
        
    }
    
}

#pragma mark ---微信支付完成后回调
-(void)onResp:(BaseResp *)resp {
    
    if (self.backResp) {
        
        self.backResp(resp);
        
    }
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        
        switch(response.errCode){
            case WXSuccess:
                             
                [self backCode:@"支付成功"];
                
                break;
                
            case WXErrCodeUserCancel:
                
                [self backCode:@"用户取消"];
                
                break;
                
            case WXErrCodeSentFail:
                
                [self backCode:@"发送失败"];
                
                break;
                
            case WXErrCodeAuthDeny:
                
                [self backCode:@"授权失败"];
                
                break;
                
            case WXErrCodeUnsupport:
                
                [self backCode:@"微信不支持"];
                
                break;
                
            default:
                
                break;
        }
    }
}

@end
