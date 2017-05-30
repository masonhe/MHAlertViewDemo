//
//  ViewController.m
//  MHAlertViewDemo
//
//  Created by mason on 2017/5/30.
//  Copyright © 2017年 mason. All rights reserved.
//

#import "ViewController.h"
#import <MHAlertView.h>

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)singleAction:(id)sender {
    MHAlertView *alertView = [MHAlertView show:@"提示" message:@"提示信息" actions:@[@"确定"] alertActionStyles:@[@(MHAlertActionStyleWhite)] didSeletectItemAction:^(NSInteger index) {
        
    }];
    alertView.separatorLineColor = RGBA(220, 220, 220, 1);
}


- (IBAction)doubleAction:(id)sender {
    MHAlertView *alertView = [MHAlertView show:@"提示" message:@"提示信息" actions:@[@"取消",@"确定"] alertActionStyles:@[@(MHAlertActionStyleWhite), @(MHAlertActionStyleRed)] didSeletectItemAction:^(NSInteger index) {
        
    }];
    alertView.separatorLineColor = RGBA(220, 220, 220, 1);
}


- (IBAction)coustomColorAction:(id)sender {
    MHAlertView *alertView = [MHAlertView show:@"提示" message:@"提示信息" actions:@[@"取消",@"确定"] alertActionStyles:@[@(0),@(1)] didSeletectItemAction:^(NSInteger index) {
    }];
    
    alertView.defaultActionBackroundColor = [UIColor blueColor];
    alertView.defaultActionTitleColor = [UIColor redColor];
    alertView.separatorLineColor = RGBA(220, 220, 220, 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
