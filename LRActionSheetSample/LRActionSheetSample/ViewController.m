//
//  ViewController.m
//  LRActionSheetSample
//
//  Created by Lorin on 15/10/22.
//  Copyright © 2015年 LorinRain. All rights reserved.
//

#import "ViewController.h"
#import "LRActionSheet/LRActionSheet.h"

@interface ViewController ()<LRActionSheetDelegate, UIActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 仅毁灭性按钮
    UIButton *btn1 = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn1 setTitle: @"仅destructive按钮" forState: UIControlStateNormal];
    btn1.frame = CGRectMake(50, 100, 200, 50);
    [btn1 addTarget: self action: @selector(onlyDestructive:) forControlEvents: UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: btn1];
    
    // 仅普通按钮
    UIButton *btn2 = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn2 setTitle: @"仅普通按钮" forState: UIControlStateNormal];
    btn2.frame = CGRectMake(50, 180, 200, 50);
    [btn2 addTarget: self action: @selector(onlyNormal:) forControlEvents: UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: btn2];
    
    // 都有
    UIButton *btn3 = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn3 setTitle: @"both" forState: UIControlStateNormal];
    btn3.frame = CGRectMake(50, 250, 200, 50);
    [btn3 addTarget: self action: @selector(both:) forControlEvents: UIControlEventTouchUpInside];
    btn3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: btn3];
}

#pragma mark - LRActionSheet Delegate
- (void)LRActionSheet:(LRActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: nil message: [actionSheet buttonTitleAtIndex: index] preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction: action];
    [self presentViewController: alertController animated: YES completion:^{
        
    }];
}

- (void)onlyDestructive:(UIButton *)btn
{
    LRActionSheet *actionSheet = [[LRActionSheet alloc] initWithTitle: @"title" destroyButtonTitle: @"destructive Button" otherButtonTitles: nil];
    actionSheet.delegate = self;
    [actionSheet show];
}

- (void)onlyNormal:(UIButton *)btn
{
    LRActionSheet *actionSheet = [[LRActionSheet alloc] initWithTitle: @"仅普通按钮" destroyButtonTitle: nil otherButtonTitles: @[@"按钮1", @"按钮2", @"按钮3"]];
    actionSheet.delegate = self;
    [actionSheet show];
}

- (void)both:(UIButton *)btn
{
    LRActionSheet *actionSheet = [[LRActionSheet alloc] initWithTitle: @"actionSheet标题" destroyButtonTitle: @"destructive Button" otherButtonTitles: @[@"按钮1", @"按钮2", @"按钮3"]];
    actionSheet.delegate = self;
    [actionSheet show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
