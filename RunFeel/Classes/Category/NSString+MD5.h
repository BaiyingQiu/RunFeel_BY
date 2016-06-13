//
//  NSString+MD5.h
//  RunFeel
//
//  Created by Tarena on 16/6/8.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
/** 基础加密 */
- (NSString *)md5Str;
/** 改进加密 */
- (NSString *)md5StrXor;
@end
