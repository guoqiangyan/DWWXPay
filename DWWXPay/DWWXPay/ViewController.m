//
//  ViewController.m
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.


//*******************Github:https://github.com/dwanghello/DWWXPay*************
//*******************问题交流QQ群:577506623*************************************
//*******************codedata开源社区:http://www.codedata.cn********************
//*******************codedata官方群:157937068***********************************

#import "ViewController.h"
#import "DWWXPayH.h"

@interface ViewController ()

@property (strong, nonatomic) DWWXPay *pay;;


@property (weak, nonatomic) UIButton *payMoeny;

@property (weak, nonatomic) UIButton *queryOrder;

@end

#define DWLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);


@implementation ViewController


- (DWWXPay *)pay {
    
    if (!_pay) {
        
        _pay = [DWWXPay dw_sharedManager];
        
    }
    
    return _pay;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /*---------------------------------------微信支付测试------------------------------------------*/
    UIButton *payMoeny = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    
    self.payMoeny = payMoeny;
    
    payMoeny.backgroundColor = [UIColor orangeColor];
    
    [payMoeny setTitle:@"微信支付测试" forState:UIControlStateNormal];
    
    [payMoeny addTarget:self action:@selector(payMoenyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:payMoeny];
    
    /*---------------------------------------微信查询订单测试------------------------------------------*/
    UIButton *queryOrder = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    
    self.queryOrder = queryOrder;
    
    queryOrder.backgroundColor = [UIColor orangeColor];
    
    [queryOrder setTitle:@"微信查询订单测试" forState:UIControlStateNormal];
    
    [queryOrder addTarget:self action:@selector(queryOrderClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:queryOrder];

}

//付款
- (void)payMoenyClick {
    
    NSString *fee = @"价格单位为分，需要*100，但是必须在此处定义变量进行赋值：如 int i = 10 * 100,那么下面只需要传入i即可价格单位为分，需要*100，但是必须在此处定义变量进行赋值：如 int i = 10 * 100,那么下面只需要传入i即可";
    
    //Trade_type:@"APP"
    //Out_trade_no:商户系统内部的订单号,32个字符内、可包含字母
    NSString *xmlString = [self.pay dw_payMoenySetAppid:@"appid" Mch_id:@"商户id" PartnerKey:@"商户密钥" Body:@"商品信息" Out_trade_no:@"订单号必需为新的订单号，不可以是以存在的订单号" total_fee:[fee intValue] Notify_url:@"回调地址" Trade_type:@"支付类型"];
    
   //DWLog(@"%@",xmlString);
    
    [self.pay dw_post:@"https://api.mch.weixin.qq.com/pay/unifiedorder" xml:xmlString return_ErrorCode:^(NSString *return_msg, NSString *err_code, NSString *err_code_des) {
        
        DWLog(@"付款出现错误:%@--%@--%@",return_msg,err_code,err_code_des);
        
    } backResp:^(BaseResp *backResp) {
        
//        DWLog(@"微信返回内容");
        
        
    } backCode:^(NSString *backCode) {
        
        DWLog(@"微信支付返回结果为:%@",backCode);
        
        [self.payMoeny setTitle:[NSString stringWithFormat:@"%@",backCode] forState:UIControlStateNormal];
        
    } BackTrade_stateMsg:^(NSString *backTrade_stateMsg, NSString *backTrade_state) {}];
    
}

//查询订单
- (void)queryOrderClick {
  
    NSString *xmlString = [self.pay dw_queryOrderSetAppid:@"appid" Mch_id:@"商户id" PartnerKey:@"商户密钥" Out_trade_no:@"订单号必需为存在的订单号，不可以是虚假的订单号"];
    
    [self.pay dw_post:@"https://api.mch.weixin.qq.com/pay/orderquery" xml:xmlString return_ErrorCode:^(NSString *return_msg, NSString *err_code, NSString *err_code_des) {
        
        DWLog(@"%@---%@---%@",return_msg,err_code,err_code_des);
        
    } backResp:^(BaseResp *backResp) {
        
        
        
    } backCode:^(NSString *backCode) {
        
        
        
        
    }BackTrade_stateMsg:^(NSString *backTrade_stateMsg, NSString *backTrade_state) {
        
        DWLog(@"返回订单状态%@------返回订单状态码%@",backTrade_stateMsg,backTrade_state);
        
        [self.queryOrder setTitle:backTrade_stateMsg forState:UIControlStateNormal];
        
    }];
    
}

@end
