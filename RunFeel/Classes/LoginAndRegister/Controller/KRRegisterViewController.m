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
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "MBProgressHUD+KR.h"


@interface KRRegisterViewController ()/*<KRXMPPReisterDelegate>*/
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;

@end

@implementation KRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [KRXMPPTool sharedKRXMPPTool].reisterDelegate = self;
}
- (IBAction)registerBtnClick:(id)sender {
    if (self.userNameField.text.length == 0 || self.userPasswordField.text.length == 0) {
        [MBProgressHUD showError:@"用户名或密码不能为空"];
        return;
    }
    
    //传参数
    [KRUserInfo sharedKRUserInfo].userRegisterName = self.userNameField.text;
    [KRUserInfo sharedKRUserInfo].userRegisterPassword = self.userPasswordField.text;
    [KRUserInfo sharedKRUserInfo].login = NO;
    //调用注册方法
//    [[KRXMPPTool sharedKRXMPPTool] userReister];
    
    //使用弱引用解决循环引用
//    __weak KRRegisterViewController* weakSelf = self;
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在注册..."];
    [[KRXMPPTool sharedKRXMPPTool] userReister:^(KRXMPPResultType type) {
        [weakSelf handleRegisterResultType:type];
        [MBProgressHUD hideHUD];
    }];
    
}
- (void)handleRegisterResultType:(KRXMPPResultType) type {
    switch (type) {
        case KRXMPPResultTypeRegisterSuccess:
            NSLog(@"XMPP注册成功");
            [self registerForWebSever];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case KRXMPPResultTypeRegisterFailed:
            NSLog(@"XMPP注册失败");
//            [MBProgressHUD hideHUD];
            break;
        case KRXMPPResultTypeRegisterError:
            NSLog(@"XMPP注册网络错误");
//            [MBProgressHUD hideHUD];
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
- (void)registerForWebSever {
//    username=username&password=password&nickname=nickname&gender=gender&mobile=mobile
//    &latitude=latitude&longitude=longitude&intro=intro

    
    NSString *urlStr = @"http://localhost:8080/allRunServer/register.jsp";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = [KRUserInfo sharedKRUserInfo].userRegisterName;
    parameters[@"md5password"] = [[KRUserInfo sharedKRUserInfo].userRegisterPassword md5StrXor];
    parameters[@"nickname"] = [KRUserInfo sharedKRUserInfo].userRegisterName;
    parameters[@"gender"] = @(1);
    //头像参数 错误写法
    //parameters[@"pic"] =
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //调用POST 传数据 方法
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 在这里写上传的文件操作
        UIImage *image = [UIImage imageNamed:@"微博"];
        NSData *data = UIImagePNGRepresentation(image);
        /* 第一个参数 上传文件的二进制数据
           第二个参数 服务器于要求的文件参数名字
           第三个参数 服务器上储存的文件的名字
           第四个参数 说明数据的类型
        */
        [formData appendPartWithFileData:data name:@"pic" fileName:@"headImage.png" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"请求成功！%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败!%@",error);
    }];


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
