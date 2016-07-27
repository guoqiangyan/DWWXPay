# DWWXPay
#简单两步使用微信支付与查询订单
---

1、iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
受此影响，当你的应用在iOS 9中需要使用微信SDK的相关能力（分享、收藏、支付、登录等）时，需要在“Info.plist”里增加如下代码：

     <key>LSApplicationQueriesSchemes</key>
     <array>
     <string>weixin</string>
     </array>
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>

2、开发者需要在工程中链接上 CoreTelephony.framework

3、解决bitcode编译不过问题


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
      CFNetwork.framework

---
##第一步
    在AppDelegate中导入头文件
    #import "DWWXPayH.h"
---
>#*在- (BOOL)application:(UIApplication ＊)application didFinishLaunchingWithOptions:(NSDictionary ＊)launchOptions;*方法中添加以下代码
     [[DWWXPay dw_sharedManager] dw_RegisterApp:@"你的appid" withDescription:@"你的项目Bundle Identifier"];
     
---
>#在AppDelegate.m中添加以下三个方法
     -(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
          return [WXApi handleOpenURL:url delegate:[DWWXPay dw_sharedManager]];
    }
---
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[DWWXPay dw_sharedManager]];
    }
---
     //此方法是由于系统版本更新而出现的方法
     - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
          return [WXApi handleOpenURL:url delegate:[DWWXPay dw_sharedManager]];
     }
---
#第二步
    在需要使用微信支付的地方导入头文件
    #import "DWWXPayH.h"
---    

#*在开始支付时调用以下代码*
     NSString *xmlString = [pay dw_payMoenySetAppid:@"appid" Mch_id:@"商户id" PartnerKey:@"密钥" Body:@"商品信息" Out_trade_no:@"订单号" total_fee:1 Notify_url:@"回调地址" Trade_type:@"类型"];
    
----
	[pay dw_post:@"https://api.mch.weixin.qq.com/pay/unifiedorder" xml:xmlString return_ErrorCode:^(NSString *return_msg, NSString *err_code, NSString *err_code_des) {
        
        NSLog(@"付款出现错误:%@--%@--%@",return_msg,err_code,err_code_des);
        
    } backResp:^(BaseResp *backResp) {
        
	//        NSLog(@"微信返回内容");
        
        
    } backCode:^(NSString *backCode) {
        
        NSLog(@"微信支付返回结果为:%@",backCode);
        
        
    } BackTrade_stateMsg:^(NSString *backTrade_stateMsg, NSString *backTrade_state) {
        
        
    }];

#*在开始查询订单时调用以下代码*
	 NSString *xmlString = [pay dw_queryOrderSetAppid:@"appid" Mch_id:@"商户id" PartnerKey:@"商户密钥" Out_trade_no:@"订单号"];
	 
---
    [pay dw_post:@"https://api.mch.weixin.qq.com/pay/orderquery" xml:xmlString return_ErrorCode:^(NSString *return_msg, NSString *err_code, NSString *err_code_des) {
        
        
    } backResp:^(BaseResp *backResp) {
        
        
        
    } backCode:^(NSString *backCode) {
        
        
        
    }BackTrade_stateMsg:^(NSString *backTrade_stateMsg, NSString *backTrade_state) {
        
        NSLog(@"返回订单状态%@------返回订单状态码%@",backTrade_stateMsg,backTrade_state);
        
    }];
