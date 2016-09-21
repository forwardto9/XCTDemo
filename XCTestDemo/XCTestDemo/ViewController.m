//
//  ViewController.m
//  XCTestDemo
//
//  Created by uwei on 9/21/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "SigninViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 按钮点击，登录事件
 
 @param sender 按钮控件
 */
- (IBAction)login:(id)sender {
    if (self.userNameTextfield.text.length == 0 || self.passwordTextfield.text.length == 0) {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Error" message:@"password or username empty" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertViewController addAction:action];
        [self presentViewController:alertViewController animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"ShowTimesPage" sender:nil];
        
    }
}

@end
