//
//  KRloginAndRegisterViewController.m
//  RunFeel
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "KRloginAndRegisterViewController.h"
#import "KRUserInfo.h"

@interface KRloginAndRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameFlied;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordFlied;

@end

@implementation KRloginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //代码设置TextField图片
//    UIImageView *leftN = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
//    leftN.frame = CGRectMake(0, 0, 55, 20);
//    self.userNameFlied.leftViewMode = UITextFieldViewModeAlways;
//    self.userNameFlied.leftView = leftN;
}
- (IBAction)loginBtnClick:(UIButton *)sender {
    [KRUserInfo sharedKRUserInfo].userName = self.userNameFlied.text;
    [KRUserInfo sharedKRUserInfo].userPassword = self.userPasswordFlied.text;
    //调用xmppframework API完成登录
    //最后是和服务器的交互封装成工具类
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
