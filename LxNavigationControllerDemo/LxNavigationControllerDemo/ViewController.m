//
//  ViewController.m
//  LxNavigationControllerDemo
//
//  Created by Jin on 15-4-3.
//  Copyright (c) 2015年 etiantian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"LxNavigationController";
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    
    UIButton * pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.backgroundColor = [UIColor whiteColor];
    [pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [pushButton setTitleColor:self.view.backgroundColor forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
    
    pushButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray * pushButtonConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[pushButton]-30-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(pushButton)];
    NSArray * pushButtonConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-90-[pushButton(==48)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(pushButton)];
    
    [self.view addConstraints:pushButtonConstraintsH];
    [self.view addConstraints:pushButtonConstraintsV];
}

- (void)pushButtonClicked:(UIButton *)btn
{
    ViewController * vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
