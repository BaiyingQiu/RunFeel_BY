//
//  KRRegisterViewController.m
//  RunFeel
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "KRRegisterViewController.h"
#import "KRUserInfo.h"
#import "KRXMPPTool.h"


@interface KRRegisterViewController ()//<KRXMPPReisterDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;

@end

@implementation KRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [KRXMPPTool sharedKRXMPPTool].reisterDelegate = self;
}
- (IBAction)registerBtnClick:(id)sender {
    //传参数
    [KRUserInfo sharedKRUserInfo].userRegisterName = self.userNameField.text;
    [KRUserInfo sharedKRUserInfo].userRegisterPassword = self.userPasswordField.text;
    [KRUserInfo sharedKRUserInfo].login = NO;
    //调用注册方法
//    [[KRXMPPTool sharedKRXMPPTool] userReister];
    
    //使用弱引用解决循环引用
//    __weak KRRegisterViewController* weakSelf = self;
    __weak typeof(self) weakSelf = self;
    [[KRXMPPTool sharedKRXMPPTool] userReister:^(KRXMPPResultType type) {
        [weakSelf handleRegisterResultType:type];
    }];
    
}
- (void)handleRegisterResultType:(KRXMPPResultType) type {
    switch (type) {
        case KRXMPPResultTypeRegisterSuccess:
            NSLog(@"注册成功");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case KRXMPPResultTypeRegisterFailed:
            NSLog(@"注册失败");
            break;
        case KRXMPPResultTypeRegisterError:
            NSLog(@"网络错误");
            break;
        default:
            break;
    }
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc {
    NSLog(@"注册控制器销毁");
}

#pragma mark --KRXMPPReisterDelegate 相关方法
//- (void)reisterSuccess {
//    NSLog(@"注册成功");
//
//}
//- (void)reisterfailed {
//    NSLog(@"注册失败");
//}
//- (void)reisterNetError {
//    NSLog(@"注册时网络错误");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
