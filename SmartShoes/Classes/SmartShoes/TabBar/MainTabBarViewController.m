//
//  MainTabBarViewController.m
//  nRF Toolbox
//
//  Created by SINOWINNER on 16/5/9.
//  Copyright © 2016年 Nordic Semiconductor. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *view1 = self.viewControllers[0];
    UIViewController *view2 = self.viewControllers[1];
    UIViewController *view3 = self.viewControllers[2];
    UIViewController *view4 = self.viewControllers[3];
    
    view1.tabBarItem.title = NSLocalizedString(@"首页", nil);
    view2.tabBarItem.title = NSLocalizedString(@"数据", nil);
    view3.tabBarItem.title = NSLocalizedString(@"知识", nil);
    view4.tabBarItem.title = NSLocalizedString(@"我", nil);
    
    view1.tabBarItem.image = [UIImage imageNamed:@"home"];
    [view1.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    view2.tabBarItem.image = [UIImage imageNamed:@"shuju"];
    [view2.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    view3.tabBarItem.image = [UIImage imageNamed:@"zhishi"];
    [view3.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    view4.tabBarItem.image = [UIImage imageNamed:@"wo"];
    [view4.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
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
