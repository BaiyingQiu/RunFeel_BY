//
//  KRMyInfoViewController.m
//  RunFeel
//
//  Created by Tarena on 16/6/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "KRMyInfoViewController.h"
#import "XMPPvCardTemp.h"
#import "KRXMPPTool.h"
#import "KRUserInfo.h"

@interface KRMyInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLabel;

@end

@implementation KRMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.bounds.size.width*0.5;
    self.headerImageView.layer.borderWidth = 1;
    self.headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    //获取电子名片
   XMPPvCardTemp *vcardTemp = [KRXMPPTool sharedKRXMPPTool].xmppvCard.myvCardTemp;
    
    self.userNameLabel.text = [KRUserInfo sharedKRUserInfo].userName;
    self.nikeNameLabel.text = vcardTemp.nickname;
    if (vcardTemp.photo == nil) {
        self.headerImageView.image = [UIImage imageNamed:@"微信"];
    } else {
        self.headerImageView.image = [UIImage imageWithData:vcardTemp.photo];
    }
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
