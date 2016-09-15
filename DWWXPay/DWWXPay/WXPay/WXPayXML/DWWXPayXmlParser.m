//
//  DWWXPayXmlParser.m
//  DWWXPay
//
//  Created by cdk on 16/7/8.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "DWWXPayXmlParser.h"

@implementation DWWXPayXmlParser

+ (NSDictionary*)dw_parseData:(NSData*)data
{
    DWWXPayXmlParser* parser = [[DWWXPayXmlParser alloc] init];
    return [parser dw_parseData:data];
}

- (NSDictionary*)dw_parseData:(NSData*)data
{
    lastError = nil;
    dictionary = [NSMutableDictionary new];
    valBuffer = [NSMutableString string];
    xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    if(lastError)
        return nil;
    return [dictionary copy];
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string{
    [valBuffer setString:string];
}

- (void)parser:(NSXMLParser*)parser
        didEndElement:(NSString*)elementName
        namespaceURI:(NSString*)namespaceURI
        qualifiedName:(NSString*)qName{
    
    if([valBuffer isEqualToString:@"\n"]==NO &&
       [elementName isEqualToString:@"root"]==NO)
    {
        [dictionary setObject:[valBuffer copy] forKey:elementName];
    }
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
    lastError = parseError;
}

- (void)parser:(NSXMLParser*)parser validationErrorOccurred:(NSError*)validationError
{
    lastError = validationError;
}


@end
