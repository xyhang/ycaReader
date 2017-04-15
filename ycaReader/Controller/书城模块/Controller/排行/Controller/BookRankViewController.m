//
//  BookRankViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/13.
//  Copyright © 2017年 yca. All rights reserved.
//

// http://chapter2.qvodxy.com/project/xiaoshuo/book/createapi.php?primaryKey=rank&url=http%3A%2F%2Fchapter2.qvodxy.com%2Fproject%2Fxiaoshuo%2Franking%2Fgender.php

#import "BookRankViewController.h"
#import "BookRankModel.h"
#import "BookRankCell.h"
#import "BookRankDetailViewController.h"
@interface BookRankViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic , strong) NSMutableArray * femaleData;

@property (nonatomic , strong) NSMutableArray * maleData;

@end

@implementation BookRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    self.femaleData = [[NSMutableArray array] mutableCopy];
    self.maleData = [[NSMutableArray array] mutableCopy];
    
    [self loadLocalData];
    
    
    
    [self initTableView];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 初始化ui
-(void)initTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:@"BookRankCell" bundle:nil] forCellReuseIdentifier:@"bookRankCell"];
    self.myTableView.rowHeight = 50;
}

#pragma mark - 加载本地数据
-(void)loadLocalData{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"bookrank.plist"];

    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSDictionary *dic = [unArchiver decodeObjectForKey:BOOKRANK_KEY];
    
    NSArray *femaleArr = dic[@"female"];
    self.femaleData = [BookRankModel mj_objectArrayWithKeyValuesArray:femaleArr];
    
    NSArray *maleArr = dic[@"male"];
    self.maleData = [BookRankModel mj_objectArrayWithKeyValuesArray:maleArr];
    
    
}

#pragma mark - 请求数据
-(void)loadData{
    [[YCAHttpRequetTool shareTool] get:@"http://chapter2.qvodxy.com/project/xiaoshuo/book/createapi.php?primaryKey=rank&url=http%3A%2F%2Fchapter2.qvodxy.com%2Fproject%2Fxiaoshuo%2Franking%2Fgender.php" params:nil success:^(id responseObj) {
        [self requestWithUrl:responseObj];
    } failure:^(NSError *error) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}

-(void)requestWithUrl:(NSString *)url{
    [[YCAHttpRequetTool shareTool] get:url params:nil success:^(id responseObj) {
        DLOG(@"%@",responseObj);
        
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        // 编码
        [archiver encodeObject:responseObj forKey:BOOKRANK_KEY];
        
        [archiver finishEncoding];
        
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"bookrank.plist"];
        [data writeToFile:filePath atomically:YES];
        
        NSArray *femaleArr = responseObj[@"female"];
        self.femaleData = [BookRankModel mj_objectArrayWithKeyValuesArray:femaleArr];
        
        NSArray *maleArr = responseObj[@"male"];
        self.maleData = [BookRankModel mj_objectArrayWithKeyValuesArray:maleArr];
        
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}

#pragma mark - 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.maleData.count;
    }else{
        return self.femaleData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookRankCell"];

    if (cell) {
        if (indexPath.section == 0) {
            BookRankModel *model = self.maleData[indexPath.row];
            [cell createCellWithModel:model];
            return cell;
        }else{
            BookRankModel *model = self.femaleData[indexPath.row];
            [cell createCellWithModel:model];
            return cell;
        }
    }
    
    return nil;
}

//重新分组头部函数
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"男生";
    }else{
        return @"女生";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // http://api.zhuishushenqi.com/ranking
    BookRankDetailViewController *dvc = [[BookRankDetailViewController alloc]initWithDefaultNibName];
    NSString * _id;
    if (indexPath.section == 0) {
        BookRankModel *model = self.maleData[indexPath.row];
        _id = model._id;
    }else{
        BookRankModel *model = self.femaleData[indexPath.row];
        _id = model._id;
    }
    
    dvc._id = _id;
    dvc.url = [NSString stringWithFormat:@"http://api.zhuishushenqi.com/ranking/%@",_id];
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
