//
//  FirstViewController.m
//  NavigationAndCustom
//
//  Created by Thinkive on 2017/8/8.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "FirstViewController.h"
#import "UIView+Show.h"
#import "TableViewCell.h"
#import "DetailViewController.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    通过代码局部设置状态栏的文字颜色
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.view.backgroundColor = [UIColor whiteColor];

    //设置状态栏颜色，见ViewController使用navigationBar.barTintColor
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor yellowColor];
    [self.navigationController.navigationBar addSubview:statusBarView];

    
    self.navigationItem.title = @"控制器1";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"left" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    // 监听UITabBarItem被重复点击时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarDidClick) name:@"TheSameNotification" object:nil];
    
    
//    tableview
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
//    设置TableViewCell的圆角
    [TableViewCell appearance].radios = 4;
}


- (void)tabBarDidClick
{
    // 如果本控制器的view显示在最前面，就做自定义事件比如下拉刷新等
    if ([self.view isShowingOnKeyWindow]) { // 判断一个view是否显示在根窗口上，该方法在UIView的分类中实现
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"你好" message:@"收到了点击同一个TabBarItem通知" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark -- dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld",indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"hello";
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"bye";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
