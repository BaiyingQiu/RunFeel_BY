//
//  KRXMPPTool.m
//  RunFeel
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "KRXMPPTool.h"
#import "KRUserInfo.h"

@interface KRXMPPTool ()<XMPPStreamDelegate>

/** 设置流（给对象赋值 和 设置代理 以及后续模块添加） */
-(void) setupXmppStream;
/** 1 连接服务器 */
- (void) connetToServer;
/** 2 连接成功与否 通过代理方法 */
/** 3 如果连接连成功，就发送密码进行授权 */
- (void)sendPassword;

/** 4 授权成功与否 通过代理方法 */
/** 4 授权成功 发送在线消息 */
- (void) sendOnLine;

@end

@implementation KRXMPPTool
singleton_implementation(KRXMPPTool)
- (void)setupXmppStream {
    self.xmppStream = [XMPPStream new];
   [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (void)connetToServer {
    // 断开之前连接
    [self.xmppStream disconnect];
    if (nil == self.xmppStream) {
        [self setupXmppStream];
    }
    //设置服务器的 IP 端口  （soket）
    self.xmppStream.hostName = KRXMPPHOSTNAME;
    self.xmppStream.hostPort = KRXMPPPORT;
    
    //根据当前用户的jid
    NSString *userName = nil;
    userName = [KRUserInfo sharedKRUserInfo].userName;
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",userName,KRXMPPDOMAIN];
    self.xmppStream.myJID = [XMPPJID jidWithString:jidStr];
    //开始连接
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];//调用连接方法，设置连接超时-1
    if (error) {
        NSLog(@"%@",error);
    }
}

#pragma mark -- XMPPstreamDelegate
/** 连接成功 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    //发送密码
    [self.loginDelegate LoginSuccess];
    [self sendPassword];
    NSLog(@"连接成功");
}
/** 连接失败 会自动 断开连接  （可能主动断开、这种情况是没有error的）*/
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    //断开分为主动断开、密码错误断开
    if (error) {
        NSLog(@"%@",error);
        [self.loginDelegate LoginNetError];
    } else {        
        [self.loginDelegate Loginfailed];
    }
}
- (void)sendPassword {

    NSString *password = nil;
    NSError *error = nil;
    password = [KRUserInfo sharedKRUserInfo].userPassword;
    //使用密码进行授权码
    [self.xmppStream authenticateWithPassword:password error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}
/** 授权成功 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    [self sendOnLine];
    
    NSLog(@"授权成功");
}
/** 授权失败 */
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
//    NSLog(@"授权失败");
    if (error) {
        NSLog(@"%@",error);
    }
}
/** 发送在线消息 */
- (void)sendOnLine {
    [self.xmppStream sendElement:[XMPPPresence new]];
}
/** 用户登录的方法 */
- (void)userLogin {
    [self connetToServer];
}
@end
