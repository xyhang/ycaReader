//
//  BookshelfViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/13.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookshelfViewController.h"
#import "FooterView.h"
#import "BookRankDetailCell.h"
#import "BookRankDetailModel.h"
@interface BookshelfViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) UITableView *myTableView;

@end

@implementation BookshelfViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataArray = [[NSArciverManager shareManager] archiverObjWithAPIKey:BOOKSHELF_KEY];

    if (_myTableView) {
        [_myTableView reloadData];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkUpdate];
    });
    DLOG(@"ssf");
}

#pragma mark - 检测更新状况
-(void)checkUpdate{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (BookRankDetailModel *model in _dataArray) {
        [tempArr addObject:model._id];
    }
    NSString *idStr = [tempArr componentsJoinedByString:@","];
    [[YCAHttpRequetTool shareTool] get:[NSString stringWithFormat:@"http://api.zhuishushenqi.com/book?view=updated&id=%@",idStr] params:nil success:^(id responseObj) {
        NSArray *arr = responseObj;
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *tempDic = arr[i];
            BookRankDetailModel *model = _dataArray[i];
            model.lastChapter = tempDic[@"lastChapter"];
            model.updated = tempDic[@"updated"];
        }
        
        [[NSArciverManager shareManager] saveArchiver:_dataArray WithAPIKey:BOOKSHELF_KEY WithBlock:^(BOOL state) {
            
        }];
        [_myTableView reloadData];
    } failure:^(NSError *error) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"书架";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"Category"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    // Do any additional setup after loading the view.
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"BookRankDetailCell" bundle:nil] forCellReuseIdentifier:@"bookRankDetailCell"];
    _myTableView.rowHeight = 80;
    
    FooterView *fv = [[[NSBundle mainBundle]loadNibNamed:@"FooterView" owner:nil options:nil]lastObject];
    
    _myTableView.tableFooterView = fv;
    [self.view addSubview:_myTableView];
    
}

-(void)leftBtnClick{
    
}

#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookRankDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookRankDetailCell"];
    BookRankDetailModel *model = _dataArray[indexPath.row];
    [cell createCellWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BookRankDetailModel *model = _dataArray[indexPath.row];
    model.addTime = [NSString formatDateAndTime:[[NSDate date] timeIntervalSince1970]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[NSArciverManager shareManager] saveArchiver:_dataArray WithAPIKey:BOOKSHELF_KEY WithBlock:^(BOOL state) {
            
        }];
    });
}

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//执行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_myTableView reloadData];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[NSArciverManager shareManager] saveArchiver:_dataArray WithAPIKey:BOOKSHELF_KEY WithBlock:^(BOOL state) {
            
        }];
    });
}


//侧滑出现的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 50;
//}

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
