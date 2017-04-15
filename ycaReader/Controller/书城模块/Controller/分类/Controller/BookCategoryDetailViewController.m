//
//  BookCategoryDetailViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookCategoryDetailViewController.h"
#import "BookRankDetailModel.h"
#import "BookCategoryDetailCell.h"
#import "BookDetailViewController.h"
@interface BookCategoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , assign) NSInteger index;

@end

@implementation BookCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [[NSMutableArray array] mutableCopy];
    
    [self loadData];
    [self createRefresh];
    self.myTableView.rowHeight = 80;
    [self.myTableView registerNib:[UINib nibWithNibName:@"BookCategoryDetailCell" bundle:nil] forCellReuseIdentifier:@"bookCategoryDetailCell"];
}

#pragma mark - 构建刷新
-(void)createRefresh{
    WEAKSELF(weakSelf);
    
    if (_type == BookCategoryType) {
        __block NSInteger count = 0;
        _index = 54;
        self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSString *tempUrl;
            if (count==0) {
                NSString *str = @"start=0";
                NSString *str1 = [NSString stringWithFormat:@"start=%ld",weakSelf.index];
                tempUrl = [weakSelf.url stringByReplacingOccurrencesOfString:str withString:str1];
                count++;
            }else{
                NSString *str = [NSString stringWithFormat:@"start=%ld",weakSelf.index];
                weakSelf.index += 50;
                NSString *str1 = [NSString stringWithFormat:@"start=%ld",weakSelf.index];
                tempUrl = [weakSelf.url stringByReplacingOccurrencesOfString:str withString:str1];
            }
            
            weakSelf.url = tempUrl;
            [weakSelf loadData];
        }];

    }else{
        _index = 0;
        self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSString *tempUrl;
            NSString *str = [NSString stringWithFormat:@"start=%ld",weakSelf.index];
            weakSelf.index += 100;
            NSString *str1 = [NSString stringWithFormat:@"start=%ld",weakSelf.index];
            tempUrl = [weakSelf.url stringByReplacingOccurrencesOfString:str withString:str1];

                
            weakSelf.url = tempUrl;
            [weakSelf loadData];
        }];

    }
}


#pragma mark - 加载数据
-(void)loadData{
    [[YCAHttpRequetTool shareTool] get:_url params:nil success:^(id responseObj) {
        NSArray *books = responseObj[@"books"];
        
        NSMutableArray *arr = [BookRankDetailModel mj_objectArrayWithKeyValuesArray:books];
        [self.dataArray addObjectsFromArray:arr];
        [self.myTableView reloadData];
        
        if (_type == BookCategoryType) {
            if (books.count<50) {
                // 没有更多数据
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.myTableView.mj_footer endRefreshing];
            }
        }else{
            if (books.count<100) {
                // 没有更多数据
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.myTableView.mj_footer endRefreshing];
            }
        }
        
        
        
    } failure:^(NSError *error) {
        [self.myTableView.mj_footer endRefreshing];

    } progress:^(NSProgress *progress) {
        
    }];
}


#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCategoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCategoryDetailCell"];
    
    BookRankDetailModel *model = _dataArray[indexPath.row];
    [cell createCellWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookDetailViewController *dvc = [[BookDetailViewController alloc]initWithDefaultNibName];
    BookRankDetailModel *model = self.dataArray[indexPath.row];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];
    
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
