//
//  YCANavigationController.m
//  RooLive
//
//  Created by yan on 16/7/18.
//  Copyright © 2016年 nawei. All rights reserved.
//

#import "YCANavigationController.h"
#import "Masonry.h"
@interface YCANavigationController ()<UIGestureRecognizerDelegate>{
    UIActivityIndicatorView *indicatorView;
}


@end

@implementation YCANavigationController

//此方法，会在CZNavController当前类，执行第一个方法之前先会执行一次，并且只会调用一次
+ (void)initialize{
    //设置导航条的样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //UIBarMetricsDefault  背景图片 在横竖屏都显示
    
    
    [navBar setBarTintColor:[UIColor colorWithHexString:@"006124"]];
    
    navBar.backItem.hidesBackButton = YES;
    
    //设置标题的颜色
    [navBar  setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor  whiteColor],
                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
}


//重写导航控制器的push方法，每一个子控制器在跳转的时候都会调用此方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //viewController  就是子控制器，设置子控制器的自定义后退按钮

    if (self.viewControllers.count) {
        UIImage * image = [UIImage imageNamed:@"back"];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 60, 40);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
        viewController.navigationItem.leftBarButtonItem = item;
        item.title = @"";
//        viewController.navigationController.navigationBar.hidden = YES;
        //当push的时候隐藏tabBar
//        viewController.hidesBottomBarWhenPushed = YES;
    }
    
//    viewController.navigationItem.hidesBackButton = YES;

    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    //真正的做了控制器之间的跳转
    [super pushViewController:viewController animated:animated];

}

//-(void)startNetWorking{
//    if (indicatorView == nil) {
//        indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    }
//    [self.navigationBar addSubview:indicatorView];
//    indicatorView.frame = CGRectMake(SCREEN_WIDTH-30, 14, 20, 20);
////    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.equalTo(self);
////        make.leading.equalTo(self).offset(10);
////        make.width.mas_equalTo(20);
////        make.height.mas_equalTo(20);
////    }];
//    
//    [indicatorView startAnimating];
//
//}
//
//-(void)stopNetWorking{
//    [indicatorView stopAnimating];
//}

-(void)backButtonClick{
    NSArray *viewcontrollers=self.viewControllers;
//    UIViewController *tempV = viewcontrollers[2];
    
//    if ([[tempV class] isEqual:[DrawCachViewController class]]) {
//        [self popToViewController:tempV animated:YES];
//    }
    
    if (viewcontrollers.count <= 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self popViewControllerAnimated:YES];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NSCalendarUnitWeekOfYear;
    [self.navigationItem setHidesBackButton:YES];

    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_backImg"] forBarMetrics:UIBarMetricsDefault];
}


-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 1;
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
