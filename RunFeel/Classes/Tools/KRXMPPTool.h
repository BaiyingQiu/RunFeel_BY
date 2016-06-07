//
//  KRXMPPTool.h
//  RunFeel
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "Singleton.h"
/** 自己定义登录协议 */
@protocol KRXMPPLoginDelegate <NSObject>

- (void)LoginSuccess;
- (void)Loginfailed;
- (void)LoginNetError;

@end

@interface KRXMPPTool : NSObject
singleton_interface(KRXMPPTool)

/** xmpp服务器交换核心引擎 */
@property (nonatomic, strong) XMPPStream *xmppStream;

/** 登录的代理属性 */
@property (nonatomic, weak)id<KRXMPPLoginDelegate>  loginDelegate;

/** 完成登录的公开方法 */
- (void)userLogin;
@end
