//
//  KRXMPPTool.h
//  RunFeel
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"//已在XMPPFramework.h 中导入三个vCard头文件
#import "Singleton.h"
/** 自己定义登录协议 */
@protocol KRXMPPLoginDelegate <NSObject>

- (void)LoginSuccess;
- (void)Loginfailed;
- (void)LoginNetError;

@end
/** 自己定义注册协议 */
@protocol KRXMPPReisterDelegate <NSObject>
- (void)reisterSuccess;
- (void)reisterfailed;
- (void)reisterNetError;
@end
typedef enum {
    KRXMPPResultTypeRegisterSuccess,
    KRXMPPResultTypeRegisterFailed,
    KRXMPPResultTypeRegisterError
    
}KRXMPPResultType;
//
typedef void(^KRXMPPResultBlock)(KRXMPPResultType type);

@interface KRXMPPTool : NSObject
//创建单列方法
singleton_interface(KRXMPPTool)

/** 电子名片模块 */
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCard;
/** 电子名片对应的存储 */
@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardStorage;
/** 头像模块 */
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatar;



/** xmpp服务器交换核心引擎 */
@property (nonatomic, strong) XMPPStream *xmppStream;

/** 登录的代理属性 */
@property (nonatomic, weak)id<KRXMPPLoginDelegate>  loginDelegate;
//@property (nonatomic, weak)id<KRXMPPReisterDelegate> reisterDelegate;

/** 完成登录的公开方法 */
- (void)userLogin;
///** 完成注册公开方法 */
//- (void)userReister;
/** 完成注册的公开方法,带有状态参数 */
- (void)userReister:(KRXMPPResultBlock)block;
@end
