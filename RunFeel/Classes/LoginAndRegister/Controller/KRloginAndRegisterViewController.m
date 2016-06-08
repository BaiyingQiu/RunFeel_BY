//
//  KRloginAndRegisterViewController.m
//  RunFeel
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "KRloginAndRegisterViewController.h"
#import "KRUserInfo.h"
#import "KRXMPPTool.h"

@interface KRloginAndRegisterViewController ()<KRXMPPLoginDelegate>
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
    
    [KRXMPPTool sharedKRXMPPTool].loginDelegate = self;
}
- (void)LoginSuccess {
    NSLog(@"控制器中获得登录成功");
//    //通过故事板界面切换（更换跟视图）
//    UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    [UIApplication sharedApplication].keyWindow.rootViewController = storyboad.instantiateInitialViewController;
}
- (void)Loginfailed {
    NSLog(@"控制器中获得登录失败");
}
- (void)LoginNetError {
    NSLog(@"控制器中获得网络错误");
}
- (IBAction)passwordFiledEnter:(id)sender {
    [self loginBtnClick:nil];
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    [KRUserInfo sharedKRUserInfo].userName = self.userNameFlied.text;
    [KRUserInfo sharedKRUserInfo].userPassword = self.userPasswordFlied.text;
    [KRUserInfo sharedKRUserInfo].login = YES;
    //调用xmppframework API完成登录
    //最好是和服务器的交互封装成工具类
    [[KRXMPPTool sharedKRXMPPTool] userLogin];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
