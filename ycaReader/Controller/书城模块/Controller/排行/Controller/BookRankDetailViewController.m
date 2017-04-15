//
//  BookRankDetailViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookRankDetailViewController.h"
#import "BookRankDetailModel.h"
#import "BookRankDetailCell.h"
#import "BookDetailViewController.h"
@interface BookRankDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray * dataArray;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation BookRankDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self loadLocalData];
    [self initTableView];
    [self loadData];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 初始化ui
-(void)initTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:@"BookRankDetailCell" bundle:nil] forCellReuseIdentifier:@"bookRankDetailCell"];
    self.myTableView.rowHeight = 80;
}

#pragma mark - 加载本地数据
-(void)loadLocalData{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",self._id]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSArray *books = [unArchiver decodeObjectForKey:self._id];
    self.dataArray = [BookRankDetailModel mj_objectArrayWithKeyValuesArray:books];

}


#pragma mark - 请求数据
-(void)loadData{
    [[YCAHttpRequetTool shareTool] get:_url params:nil success:^(id responseObj) {
        DLOG(@"%@",responseObj);
        NSArray *books = responseObj[@"ranking"][@"books"];
        [self saveDataWithArray:responseObj[@"ranking"]];
        
        self.dataArray = [BookRankDetailModel mj_objectArrayWithKeyValuesArray:books];
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}

#pragma mark - 保存临时数据
-(void)saveDataWithArray:(NSDictionary *)dic{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:dic[@"books"] forKey:[NSString stringWithFormat:@"%@",dic[@"_id"]]];
        [archiver finishEncoding];
        
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",dic[@"_id"]]];
        
        [data writeToFile:filePath atomically:YES];
        
    });
}


#pragma mark - 代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookRankDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookRankDetailCell"];
    BookRankDetailModel *model = self.dataArray[indexPath.row];
    [cell createCellWithModel:model];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // http://api.zhuishushenqi.com/ranking
   
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
