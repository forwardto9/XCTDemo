//
//  ViewController.m
//  XCTestDemo
//
//  Created by uwei on 9/21/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "SigninViewController.h"
#define kTabelCellID @"CellID"
@interface ViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame     = CGRectMake(10, 80, 100, 44);
    [button setTitle:@"MyButton" forState:UIControlStateNormal];
    [button setIsAccessibilityElement:YES];
    button.accessibilityIdentifier = @"MButton";
    [button addTarget:self action:@selector(changeTitle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(110, 80, self.view.bounds.size.width-110, 60)];
    subView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:subView];
    
    UIButton *subViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    subViewButton.frame     = CGRectMake(0, 0, 60, 44);
    [subViewButton setTitle:@"SubBtn" forState:UIControlStateNormal];
    [subViewButton setIsAccessibilityElement:YES];
    subViewButton.accessibilityIdentifier = @"SubButton";
    [subViewButton addTarget:self action:@selector(changeSubTitle:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:subViewButton];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, 100, 50)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(100, 500);
    [scrollView setIsAccessibilityElement:YES];
    scrollView.accessibilityIdentifier = @"MyScrollView";
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - 64)/2 + 60, self.view.bounds.size.width, (self.view.bounds.size.height/2) + 60) style:(UITableViewStylePlain)];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:kTabelCellID];
    table.accessibilityIdentifier = @"MyTable";
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
}


- (void)changeTitle:(UIButton *)sender {
    self.navigationItem.title = @"My";
}

- (void)changeSubTitle:(UIButton *)sender {
    self.navigationItem.title = @"subView";
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


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - UITable
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTabelCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTabelCellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

@end
