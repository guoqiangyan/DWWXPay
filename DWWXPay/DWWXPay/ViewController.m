//
//  ViewController.m
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "ViewController.h"
#import "DWWXPayH.h"

@interface ViewController (){
    
    DWWXPay *pay;
    
}

@property (weak, nonatomic) UIButton *payMoeny;

@property (weak, nonatomic) UIButton *returnedMoney;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pay = [DWWXPay dw_sharedManager];
    
    /*---------------------------------------微信支付测试------------------------------------------*/
    UIButton *payMoeny = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    
    self.payMoeny = payMoeny;
    
    payMoeny.backgroundColor = [UIColor orangeColor];
    
    [payMoeny setTitle:@"微信支付测试" forState:UIControlStateNormal];
    
    [payMoeny addTarget:self action:@selector(payMoenyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:payMoeny];
    
    /*---------------------------------------微信退款测试------------------------------------------*/
    UIButton *returnedMoney = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    
    self.returnedMoney = returnedMoney;
    
    returnedMoney.backgroundColor = [UIColor orangeColor];
    
    [returnedMoney setTitle:@"微信退款测试" forState:UIControlStateNormal];
    
    [returnedMoney addTarget:self action:@selector(returnedMoneyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:returnedMoney];
    
    pay = [DWWXPay dw_sharedManager];

    
}

//付款
- (void)payMoenyClick {
    
    NSString *fee = @"价格单位为分，需要*100，但是必须在此处定义变量进行赋值：如 int i = 10 * 100,那么下面只需要传入i即可";
    
    NSString *xmlString = [pay dw_payMoenySetAppid:@"appid" Mch_id:@"商户id" PartnerKey:@"商户密钥" Body:@"微信支付测试" Out_trade_no:@"订单号" total_fee:[fee intValue] Notify_url:@"回调地址" Trade_type:@"支付类型"];
    
    
    
    
    [pay dw_post:@"https://api.mch.weixin.qq.com/pay/unifiedorder" xml:xmlString return_ErrorCode:^(NSString *return_msg, NSString *err_code, NSString *err_code_des) {
        
        NSLog(@"付款出现错误:%@--%@--%@",return_msg,err_code,err_code_des);
        
    } backResp:^(BaseResp *backResp) {
        
//        NSLog(@"微信返回内容");
        
        
    } backCode:^(NSString *backCode) {
        
        NSLog(@"微信支付返回结果为:%@",backCode);
        
        [self.payMoeny setTitle:[NSString stringWithFormat:@"%@",backCode] forState:UIControlStateNormal];
        
    } returnedMoney:^(NSString *returnedMoney) {
        
        
    }];
    
}

//退款
- (void)returnedMoneyClick {
    
    NSString *total_fee = @"订单总金额,单位为分,只能为整数,需要*100,但是必须在此处定义变量进行赋值：如 int i = 10 * 100,那么下面只需要传入i即可";
    
    NSString *refund_fee = @"退款总金额,订单总金额,单位为分,只能为整数,需要*100,但是必须在此处定义变量进行赋值：如 int i = 10 * 100,那么下面只需要传入i即可";
    
   NSString *xmlString = [pay dw_returnedMoneySetAppid:@"appid" Mch_id:@"商户id" PartnerKey:@"商户密钥" Out_trade_no:@"商户订单号" Out_refund_no:@"商户退款单号" Total_fee:[total_fee intValue] Refund_fee:[refund_fee intValue] Op_user_id:@"操作员帐号, 默认为商户号"];
    
    [pay dw_post:@"https://api.mch.weixin.qq.com/secapi/pay/refund" xml:xmlString return_ErrorCode:^(NSString *return_msg, NSString *err_code, NSString *err_code_des) {
        
        NSLog(@"付款出现错误:%@--%@--%@",return_msg,err_code,err_code_des);
        
    } backResp:^(BaseResp *backResp) {
        
        //        NSLog(@"微信返回内容");
        
    } backCode:^(NSString *backCode) {
        
          NSLog(@"微信支付返回结果为:%@",backCode);
        
    } returnedMoney:^(NSString *returnedMoney) {
        
        [self.returnedMoney setTitle:[NSString stringWithFormat:@"%@",returnedMoney] forState:UIControlStateNormal];
        
    }];
    
}

@end
