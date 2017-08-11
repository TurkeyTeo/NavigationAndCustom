//
//  RootTabBarViewController.m
//  NavigationAndCustom
//
//  Created by Thinkive on 2017/8/8.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "RootNavController.h"
#import "FirstViewController.h"
#import "ViewController.h"

@interface RootTabBarViewController ()<UITabBarControllerDelegate>

/** 之前被选中的UITabBarItem */
@property (nonatomic, strong) UITabBarItem *lastItem;

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    NSArray *array = @[
                       @{@"class"    :@"FirstViewController",
                         @"imageName":@"account_highlight",
                         @"title"    :@"ONE"},
                       @{@"class"    :@"ViewController",
                         @"imageName":@"mycity_highlight",
                         @"title"    :@"TWO"}
                       ];
    [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dic[@"class"]) new];
        RootNavController *nav = [[RootNavController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dic[@"title"];
        item.image = [UIImage imageNamed:dic[@"imageName"]];
        item.selectedImage = [[UIImage imageNamed:dic[@"imageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor yellowColor]} forState:UIControlStateSelected];
//        等价于    [[UITabBar appearance] setTintColor:[UIColor yellowColor]];

        [self addChildViewController:nav];
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 将默认被选中的tabBarItem保存为属性
    self.lastItem = self.tabBar.selectedItem;
}


//UITabBarController已经遵守了UITabBarDelegate协议,实现一下即可
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    // 判断本次点击的UITabBarItem是否和上次的一样
    if (item == self.lastItem) { // 一样就发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TheSameNotification" object:nil userInfo:nil];
    }
    // 将这次点击的UITabBarItem赋值给属性
    self.lastItem = item;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}



@end
