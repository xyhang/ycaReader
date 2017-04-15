//
//  BaseTabbarController.m
//  ycaReader
//
//  Created by yan on 2017/4/13.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BaseTabbarController.h"

@interface BaseTabbarController ()

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor colorWithHexString:@"F9F10E"];
    self.tabBar.barTintColor = [UIColor colorWithHexString:@"006124"];
    // Do any additional setup after loading the view.
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
