//
//  BookShopViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/13.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookShopViewController.h"
#import "LCESwitch.h"
#import "BookRankViewController.h"
#import "BookSearchViewController.h"
#import "BookCategoryViewController.h"
@interface BookShopViewController ()

@property (nonatomic , strong) BookRankViewController *brvc;

@property (nonatomic , strong) BookSearchViewController *bsvc;

@property (nonatomic , strong) BookCategoryViewController *bcvc;

@property (nonatomic , strong) UIViewController *currentVC;

//@property (nonatomic , strong)

@end

@implementation BookShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTitleView];
    [self initChildVC];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化子控制器
-(void)initChildVC{
    self.brvc = [[BookRankViewController alloc]initWithDefaultNibName];
    self.brvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addChildViewController:self.brvc];
    [self.view addSubview:self.brvc.view];
    
    self.currentVC = self.brvc;

    self.bsvc = [[BookSearchViewController alloc]initWithDefaultNibName];
//    [self addChildViewController:self.bsvc];
    self.bsvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.view addSubview:self.bsvc.view];


    self.bcvc = [[BookCategoryViewController alloc]initWithDefaultNibName];
//    [self addChildViewController:self.bcvc];
    self.bcvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.view addSubview:self.bcvc.view];
    
}



#pragma mark - 创建导航条自定义视图
-(void)createTitleView{
    LCESwitch *ls = [LCESwitch lceSwitchCGRect:CGRectMake(0, 0, 200, 40) masks:YES];
    ls.titleArray = @[@"排行榜",@"分类",@"搜索"];
    ls.backgroundColor = [UIColor colorWithHexString:@"006124" alpha:.8];
    self.navigationItem.titleView = ls;
    
    ls.switchBlock = ^(NSInteger index){
        [self switchChildVCWithIndex:index];
    };
}

#pragma mark - 切换子视图
-(void)switchChildVCWithIndex:(NSInteger)index{
    UIViewController *newController;
    if (index == 0) {
        newController = self.brvc;
    }else if (index == 1){
        newController = self.bcvc;
    }else if (index == 2){
        newController = self.bsvc;
    }else{
        return;
    }
    
    [self addChildViewController:newController];
    [self transitionFromViewController:self.currentVC toViewController:newController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [self.currentVC willMoveToParentViewController:nil];
            [self.currentVC removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = self.currentVC;
            
        }
    }];
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
