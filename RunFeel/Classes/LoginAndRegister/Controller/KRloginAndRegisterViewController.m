//
//  KRloginAndRegisterViewController.m
//  RunFeel
//
//  Created by Tarena on 16/6/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "KRloginAndRegisterViewController.h"

@interface KRloginAndRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameFlied;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@end

@implementation KRloginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *leftN = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    leftN.frame = CGRectMake(0, 0, 55, 20);
    self.userNameFlied.leftViewMode = UITextFieldViewModeAlways;
    self.userNameFlied.leftView = leftN;
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
