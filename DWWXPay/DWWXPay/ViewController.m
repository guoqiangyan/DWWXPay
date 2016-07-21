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

@property (weak, nonatomic) UIButton *sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    
    self.sender = button;
    
    button.backgroundColor = [UIColor orangeColor];
    
    [button setTitle:@"微信支付测试" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    pay = [DWWXPay dw_sharedManager];
}

- (void)click {
    
    NSString *fee = @"价格单位为分，需要*100，但是必须在此处定义变量进行赋值：如 int i = 10 * 100,那么下面只需要传入i即可";
    
    NSString *xmlString = [pay dw_setAppid:@"appid" Mch_id:@"商户id" PartnerKey:@"商户密钥" Body:@"微信支付测试" Out_trade_no:@"订单号" total_fee:[fee intValue] Notify_url:@"回调地址" Trade_type:@"支付类型"];
    
    
    [pay dw_post:@"https://api.mch.weixin.qq.com/pay/unifiedorder" xml:xmlString return_ErrorCode:^(NSString *return_msg, NSString *err_code, NSString *err_code_des) {
        
        
        
    } backResp:^(BaseResp *backResp) {
        
        
        
    } backCode:^(NSString *backCode) {
        
        [self.sender setTitle:[NSString stringWithFormat:@"%@",backCode] forState:UIControlStateNormal];
        
        NSLog(@"%@",backCode);
        
    }];
    
}

@end
