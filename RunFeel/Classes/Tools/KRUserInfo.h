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

@end
