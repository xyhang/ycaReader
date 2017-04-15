//
//  BookDetailViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookReaderPageViewController.h"
@interface BookDetailViewController ()

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addBookBtn.v_cornerRadius = 15;
    self.onLineViewBtn.v_cornerRadius = 15;
    
    
    self.navigationItem.title = self.model.title;
    self.novelTitle.text = self.model.title;
    self.novelAuthor.text = [NSString stringWithFormat:@"作者：%@",self.model.author];
    if (self.model.cat) {
        self.novelCat.text = [NSString stringWithFormat:@"风格：%@",self.model.cat];
    }else{
        self.novelCat.text = [NSString stringWithFormat:@"风格：%@",self.model.majorCate];
    }
    NSString *cover;
    if ([self.model.cover hasPrefix:@"/agent/"])  {
        cover = [self.model.cover stringByReplacingOccurrencesOfString:@"/agent/" withString:@""];
    }else{
        cover = [NSString stringWithFormat:@"http://api.zhuishushenqi.com%@",self.model.cover];
    }
    
    [self.novelImg sd_setImageWithURL:[NSURL URLWithString:cover]];
    self.novelIntroduce.text = self.model.shortIntro;
    
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)addBookAction:(id)sender {
    NSArray *arr = [[NSArciverManager shareManager] archiverObjWithAPIKey:BOOKSHELF_KEY];
    
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
    if (arr) {
        if (arr.count>0) {
            [[BookShelfManager shareModel].dataArray addObjectsFromArray:arr];
            for (BookRankDetailModel *tempM in arr) {
                if ([tempM._id isEqualToString:self.model._id]) {
                    DLOG(@"已经加入书架");
                    return;
                }
            }
        }
    }
    
        
    [muArr addObject:self.model];

    self.model.addTime = [NSString formatDateAndTime:[[NSDate date] timeIntervalSince1970]];
    [[NSArciverManager shareManager] saveArchiver:muArr WithAPIKey:BOOKSHELF_KEY WithBlock:^(BOOL state) {
        if (state) {
            DLOG(@"加入书架");
        }else{
            DLOG(@"加入书架失败");
        }
    }];
}

- (IBAction)novelViewAction:(id)sender {
    BookReaderPageViewController *pvc = [[BookReaderPageViewController alloc]init];
    pvc.model = self.model;
    [self presentViewController:pvc animated:YES completion:nil];
    
}
@end
