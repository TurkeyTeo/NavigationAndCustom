//
//  ViewController.m
//  NavigationAndCustom
//
//  Created by Teo on 2017/8/8.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //方法1:   navigationBar的setBarTintColor接口，用此接口可改变statusBar的背景色
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    
    //    如果想将状态栏和导航栏字体全变为白色,如下
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
//    另方法2：可以添加一个高度为20的view
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
//    statusBarView.backgroundColor = [UIColor yellowColor];
//    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
    //    如果只想改变导航栏的字体颜色,可以这样
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    //    还可以改变字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:22]}];
    
    //    或者可以设置背景图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"account_highlight"] forBarMetrics:UIBarMetricsDefault];
    
    
//    另外图片透明处理
//    navigationBar为透明,注释掉self.edgesForExtendedLayout = 0;
//    self.edgesForExtendedLayout = 0;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
 
    
    
    self.navigationItem.title = @"控制器2";

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
