//
//  BookReaderPageViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookReaderPageViewController.h"
#import "BookReaderViewController.h"
@interface BookReaderPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>{
    NSMutableArray *chapters; /// 存储章节信息
}

@property (nonatomic , strong) UIPageViewController *pageViewController;

@property (nonatomic , strong) BookReaderViewController *readView;


@property (nonatomic , strong) UIView *topView;

@property (nonatomic , strong) UIView *bottomView;


@end

@implementation BookReaderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 加载目录信息
    [self loadData];
    // Do any additional setup after loading the view.
    [self steupUI];
}

#pragma mark - 构建UI
-(void)steupUI{
//    [self addChildViewController:self.pageViewController];
    
}

#pragma mark - jiazai信息
-(void)loadData{
    // http://chapter2.qvodxy.com/project/xiaoshuo/book/createapi.php?primaryKey=chapters&url=http%3A%2F%2Fchapter2.qvodxy.com%2Fproject%2Fxiaoshuo%2Fbook%2Fmix-toc.php%3F_id%3D548d9c17eb0337ee6df738f5
    
    // http://chapter2.qvodxy.com/project/xiaoshuo/book/mix-toc.php?_id=548d9c17eb0337ee6df738f5
    // http://api.zhuishushenqi.com/mix-toc/548d9c17eb0337ee6df738f5
    NSString *url = [NSString stringWithFormat:@"http://chapter2.qvodxy.com/project/xiaoshuo/book/mix-toc.php?_id=%@",self.model._id];
    [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"http://chapter2.qvodxy.com/project/xiaoshuo/book/createapi.php?primaryKey=chapters&url=%@",url];
    [[YCAHttpRequetTool shareTool] get:urlStr params:nil success:^(id responseObj) {
        [self requestDataWithUrl:responseObj];
    } failure:^(NSError *error) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}

#pragma mark - 请求章节数据
-(void)requestDataWithUrl:(NSString *)url{
    [[YCAHttpRequetTool shareTool] get:url params:nil success:^(id responseObj) {
        
        [self saveChapterInfo:responseObj];
    } failure:^(NSError *error) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}
#pragma mark - 保存章节信息
-(void)saveChapterInfo:(NSDictionary *)dic{
    NSArray *chapterArr = dic[@"mixToc"][@"chapters"];
    chapters = [BookChapterModel mj_objectArrayWithKeyValuesArray:chapterArr];
    [self requestNovelInfo];
    NSString *key = [NSString stringWithFormat:@"%@%@",BOOKCHAPTERS_KEY,dic[@"mixToc"][@"_id"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSArciverManager shareManager] saveArchiver:chapters WithAPIKey:key WithBlock:^(BOOL state) {
            if (state) {
                DLOG(@"ok")
            }else{
                DLOG(@"失败");
            }
        }];
    });
}

#pragma mark - 获取小说内容
-(void)requestNovelInfo{
   // http://chapter2.zhuishushenqi.com/chapter/http%3A%2F%2Fbook.zongheng.com%2Fchapter%2F411993%2F6936451.html
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理方法
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    return nil;
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    return nil;
}



#pragma mark - 懒加载

-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}

-(UIView *)topView{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _topView.backgroundColor = [UIColor colorWithHexString:@"0x000000" alpha:.8];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 5, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backBtn];
    return _topView;
}


#pragma mark - 关闭
-(void)closeAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
