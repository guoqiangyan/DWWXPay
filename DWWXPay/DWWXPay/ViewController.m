//
//  ViewController.m
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "ViewController.h"
#include "DWWXPayH.h"

@interface ViewController (){
    
    DWWXPay *pay;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pay = [DWWXPay sharedManager];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
   NSString *xmlString = [pay dw_setAppid:@"wx14ca19e6f0c43049" Mch_id:@"1363533002" PartnerKey:@"yzy2333yzy233yzy2333yzy2333yzy23" Body:@"支付测试" Out_trade_no:@"16369" total_fee:1 Notify_url:@"http://www.yzyclub.cn/wx_native_callback.php" Trade_type:@"APP"];
    
    NSLog(@"%@",xmlString);
    
    [pay dw_post:@"https://api.mch.weixin.qq.com/pay/unifiedorder" xml:xmlString callback:^(NSData *data, NSError *error) {
        
        
        
        
    }];
    
}

@end
