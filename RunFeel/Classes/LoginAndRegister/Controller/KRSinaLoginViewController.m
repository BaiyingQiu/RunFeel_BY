//
//  KRSinaLoginViewController.m
//  RunFeel
//
//  Created by Tarena on 16/6/8.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "KRSinaLoginViewController.h"
#import "AFNetworking.h"
#import "KRUserInfo.h"
#import "KRXMPPTool.h"
#import "NSString+MD5.h"

#define  APPKEY       @"3893301452"
#define  REDIRECT_URI @"http://www.tedu.cn"
#define  APPSECRET    @"c5d9ce0901e2bcffefd10f1c0c8cd513"

@interface KRSinaLoginViewController ()<UIWebViewDelegate,KRXMPPLoginDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation KRSinaLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString  *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@"
                         ,APPKEY,REDIRECT_URI];
    NSURL *url = [NSURL URLWithString:urlStr];
    self.webView.delegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@",url);
    NSRange range = [url rangeOfString:@"/?code="];
    NSString *code = nil;
    if (range.length > 0) {
        code = [url substringFromIndex:range.location +range.length];
        NSLog(@"code=%@",code);
        //在发送一次请求 获取access_token
        [self accessTokenWhithCode:code];
        return NO;
    }
    return YES;
}
//获取access_token 的方法, access_token获取到之后可以进行读 发微博等一系列的功能
- (void)accessTokenWhithCode:(NSString *)code {
    NSString *url = @"https://api.weibo.com/oauth2/access_token";
    //使用AFN 发送Web请求 获取access_token
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"client_id"] = APPKEY;
    parameters[@"client_secret"] = APPSECRET;
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"code"] = code;
    parameters[@"redirect_uri"] = REDIRECT_URI;
    //
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        //把uid作为用户名 access_token为密码
        NSString *uid = responseObject[@"uid"];
        NSString *access_token= responseObject[@"access_token"];
        [KRUserInfo sharedKRUserInfo].login = NO;
        [KRUserInfo sharedKRUserInfo].userRegisterName = uid;
        [KRUserInfo sharedKRUserInfo].userRegisterPassword = access_token;
        //调用XMPPTool完成注册
        __weak typeof(self) weakSelf = self;
        [[KRXMPPTool sharedKRXMPPTool] userReister:^(KRXMPPResultType type) {
            [weakSelf handleRegisterResultType:type];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}
/** 把uid作为用户名 access_token为密码 进行OpenFile注册
    注册成功发起Web注册
    Web注册成功再发Openfile起登录
 *
 */
- (void)handleRegisterResultType:(KRXMPPResultType) type {
    switch (type) {
        case KRXMPPResultTypeRegisterSuccess:
            NSLog(@"XMPP注册成功-sina");
            //发起Web注册
            [self registerForWebSever];
            break;
        case KRXMPPResultTypeRegisterFailed:
            NSLog(@"XMPP注册失败-sina");
            //注册失败也需要登录
            
            //完成openfile服务器的登录
            [KRUserInfo sharedKRUserInfo].userName = [KRUserInfo sharedKRUserInfo].userRegisterName;
            [KRUserInfo sharedKRUserInfo].userPassword = [KRUserInfo sharedKRUserInfo].userRegisterPassword;
            [KRUserInfo sharedKRUserInfo].login = YES;
            //调用工具了类 完成工具类的方法
            [[KRXMPPTool sharedKRXMPPTool] userLogin];
            [KRXMPPTool sharedKRXMPPTool].loginDelegate = self;
            
            break;
        case KRXMPPResultTypeRegisterError:
            NSLog(@"XMPP注册网络错误-sina");
            //            [MBProgressHUD hideHUD];
            break;
        default:
            break;
    }
}
//发起Web注册
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
        
        //完成openfile服务器的登录
        [KRUserInfo sharedKRUserInfo].userName = [KRUserInfo sharedKRUserInfo].userRegisterName;
        [KRUserInfo sharedKRUserInfo].userPassword = [KRUserInfo sharedKRUserInfo].userRegisterPassword;
        [KRUserInfo sharedKRUserInfo].login = YES;
        //调用工具了类 完成工具类的方法
        [[KRXMPPTool sharedKRXMPPTool] userLogin];
        [KRXMPPTool sharedKRXMPPTool].loginDelegate = self;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败!%@",error);
    }];
    
    
}
#define mark -- 登录代理方法
-(void)LoginSuccess {
    NSLog(@"通过新浪登录成功");
    //跳转
    UIStoryboard *soryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = soryboard.instantiateInitialViewController;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)Loginfailed {
    NSLog(@"通过新浪登录失败");
}
-(void)LoginNetError {
    NSLog(@"通过新浪登录时网络错误");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#define mark -- 电子名片

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
