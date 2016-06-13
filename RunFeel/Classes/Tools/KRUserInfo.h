//
//  KRUserInfo.h
//  RunFeel
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface KRUserInfo : NSObject
singleton_interface(KRUserInfo)

/** 用户名 */
@property (nonatomic, copy) NSString *userName;
/** 密码 */
@property (nonatomic, copy) NSString *userPassword;
/** 注册的名字 */
@property (nonatomic, copy) NSString *userRegisterName;
/** 注册的密码 */
@property (nonatomic, copy) NSString *userRegisterPassword;
/** 登录还是注册 */
@property (nonatomic, assign, getter=isLogin) BOOL login;
/** 昵称 */
@property (nonatomic, copy) NSString *nickname;
/** Email */
@property (nonatomic, copy) NSString *Email;
@end
