//
//  KREditMyProfileViewController.m
//  RunFeel
//
//  Created by Tarena on 16/6/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "KREditMyProfileViewController.h"
#import "KRUserInfo.h"
#import "XMPPvCardTemp.h"
#import "KRXMPPTool.h"
#import "UIImage+Circle.h"

@interface KREditMyProfileViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;

@end

@implementation KREditMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取电子名片模型对象
    XMPPvCardTemp *vcardTemp = [KRXMPPTool sharedKRXMPPTool].xmppvCard.myvCardTemp;
    if (vcardTemp.photo) {
        self.headerImageView.image = [UIImage imageWithData:vcardTemp.photo];
    } else {
        self.headerImageView.image = [UIImage imageNamed:@"placehoder"];
    }
    self.nicknameTextField.text = vcardTemp.nickname;
    self.EmailTextField.text = vcardTemp.mailer;//XMPP中没有实现Email,用其他属性代替
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
    [self.headerImageView addGestureRecognizer:tap];
    self.headerImageView.userInteractionEnabled = YES;
    //变圆
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.bounds.size.width*0.5;
    self.headerImageView.layer.borderWidth = 1;
    self.headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (void)changeImage {
    //弹出操作表选择相机或相册
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //创建alertAction
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //创建图片控制器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        // 设置编辑器类型 （相册或相机）
        // UIImagePickerControllerSourceTypePhotoLibrary
        // UIImagePickerControllerSourceTypeCamera
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置代理 （通过代理方法获得编辑完的图片）
        imagePickerController.delegate = self;
        //允许编辑图片
        imagePickerController.allowsEditing = YES;
        //打开图片编辑器
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //创建图片控制器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        // 设置编辑器类型 （相册或相机）
        // UIImagePickerControllerSourceTypePhotoLibrary
        // UIImagePickerControllerSourceTypeCamera
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置代理 （通过代理方法获得编辑完的图片）
        imagePickerController.delegate = self;
        //允许编辑图片
        imagePickerController.allowsEditing = YES;
        //打开图片编辑器
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 将编辑完的照片赋给 imageView
    
    //图片压缩
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSLog(@"%f", image.size.width);
    NSLog(@"%ld",UIImageJPEGRepresentation(image, 1.0).length);
    UIGraphicsBeginImageContext(CGSizeMake(self.headerImageView.frame.size.width, self.headerImageView.frame.size.height));
    [image drawInRect:CGRectMake(0, 0, self.headerImageView.frame.size.width, self.headerImageView.frame.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgData = UIImageJPEGRepresentation(newImage, 0.5);
    NSLog(@"%f", newImage.size.width);
    NSLog(@"%ld",imgData.length);
    //将头像变圆
    UIImage *circleImage = [UIImage circleImageWithImage:[UIImage imageWithData:imgData] borderWidth:0 borderColor:nil];
    self.headerImageView.image = circleImage;
    XMPPvCardTemp *vcardTemp = [KRXMPPTool sharedKRXMPPTool].xmppvCard.myvCardTemp;
    vcardTemp.photo = UIImagePNGRepresentation(circleImage);
    
    //返回界面
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)bcakBtnClick:(UIButton *)sender {
    //获取电子名片信息
    XMPPvCardTemp *vcardInfo = [KRXMPPTool sharedKRXMPPTool].xmppvCard.myvCardTemp;
    if (sender.tag == 100) {
        vcardInfo.photo = UIImagePNGRepresentation(self.headerImageView.image);
        if (self.nicknameTextField.text.length > 0) {
            vcardInfo.nickname = self.nicknameTextField.text;
        }
        if (self.EmailTextField.text.length > 0) {
            vcardInfo.mailer = self.EmailTextField.text;
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
