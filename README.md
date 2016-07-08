# DWWXPay
#简单两步使用微信支付
---

***导入微信支付API时libc++这个包一定要导入啊!!!虽然官方文档没说，但是有着血与泪的教训啊***
      
                      ***以下框架不分顺序导入***
      libz.tbd
      libsqlite3.0.tbd
      libc++.tbd
      Security.framework
      CoreTelephony.framework
      UIKit.framework
      SystemConfiguration.framework
      Foundation.framework

---
##第一步
    在AppDelegate中导入头文件
    #import "DWWXPayH.h"
---
>#*在- (BOOL)application:(UIApplication ＊)application didFinishLaunchingWithOptions:(NSDictionary ＊)launchOptions;*方法中添加以下代码
     [[DWWXPay dw_sharedManager] dw_RegisterApp:@"你的appid" withDescription:@"你的项目Bundle Identifier"];
     
---
     -(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:[DWWXPay dw_sharedManager]];
    }
---
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[DWWXPay dw_sharedManager]];
    }

---
---
#第二步
    在需要使用微信支付的地方导入头文件
    #include "DWWXPayH.h"
---    

#*在开始支付时调用以下代码*
     NSString *xmlString = [pay dw_setAppid:@"appid" Mch_id:@"商户id" PartnerKey:@"密钥" Body:@"商品信息" Out_trade_no:@"订单号" total_fee:1 Notify_url:@"回调地址" Trade_type:@"类型"];
    
----
    [pay dw_post:@"https://api.mch.weixin.qq.com/pay/unifiedorder" xml:xmlString return_ErrorCode:^(NSString *return_msg, NSString *err_code, NSString *err_code_des) {
        //错误信息
        
        
    } backResp:^(BaseResp *backResp) {
        //返回参数*
        
        
        
    } backCode:^(NSString *backCode) {
        
      //**支付完成或者取消支付的回调**
        NSLog(@"%@",backCode);
        
    }];
