//
//  DWWXPayXmlParser.h
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWWXPayXmlParser : NSObject<NSXMLParserDelegate>
{
    NSXMLParser* xmlParser;
    NSMutableString* valBuffer;
    NSMutableDictionary* dictionary;
    NSError* lastError;
}

/** xml解析 */
+ (NSDictionary*)dw_parseData:(NSData*)data;

@end
