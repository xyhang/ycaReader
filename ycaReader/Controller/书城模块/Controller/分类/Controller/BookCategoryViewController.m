//
//  BookCategoryViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/13.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookCategoryViewController.h"
#import "BookCategoryModel.h"
#import "BookCategoryCell.h"
#import "BookCategoryDetailViewController.h"
@interface BookCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionReusableView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic , strong) NSMutableArray *maleArray;

@property (nonatomic , strong) NSMutableArray *famelArray;

@property (nonatomic , strong) NSMutableArray *otherArray;


@end

@implementation BookCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _maleArray = [[NSMutableArray array] mutableCopy];
    _famelArray = [[NSMutableArray array] mutableCopy];
    _otherArray = [[NSMutableArray array] mutableCopy];
    
    [self getLocalData];
    
    [self loadData];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.myCollectionView.frame)/3, 50);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.myCollectionView.frame), 30);
    [self.myCollectionView setCollectionViewLayout:layout];

    [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    [_myCollectionView registerNib:[UINib nibWithNibName:@"BookCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"bookCategoryCell"];
}

#pragma mark - 先获取本地数据
-(void)getLocalData{
    NSDictionary *dic = [[NSArciverManager shareManager] archiverObjWithAPIKey:BOOKCATEGORY_KEY];
    NSArray *maleArr = dic[@"male"];
    NSArray *fameleArr = dic[@"female"];
    NSArray *otherArr = dic[@"press"];
    _maleArray = [BookCategoryModel mj_objectArrayWithKeyValuesArray:maleArr];
    _famelArray = [BookCategoryModel mj_objectArrayWithKeyValuesArray:fameleArr];
    _otherArray = [BookCategoryModel mj_objectArrayWithKeyValuesArray:otherArr];
}

#pragma mark - 请求网络数据
-(void)loadData{
    [[YCAHttpRequetTool shareTool] get:@"http://api.zhuishushenqi.com/cats/lv2/statistics" params:nil success:^(id responseObj) {
        NSArray *maleArr = responseObj[@"male"];
        NSArray *fameleArr = responseObj[@"female"];
        NSArray *otherArr = responseObj[@"press"];
        _maleArray = [BookCategoryModel mj_objectArrayWithKeyValuesArray:maleArr];
        _famelArray = [BookCategoryModel mj_objectArrayWithKeyValuesArray:fameleArr];
        _otherArray = [BookCategoryModel mj_objectArrayWithKeyValuesArray:otherArr];

        [_myCollectionView reloadData];
        [self saveDataWithObj:responseObj];
        
    } failure:^(NSError *error) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}

#pragma mark - 归档保存数据
-(void)saveDataWithObj:(id)obj{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSArciverManager shareManager] saveArchiver:obj WithAPIKey:BOOKCATEGORY_KEY WithBlock:^(BOOL state) {
            if (state) {
                DLOG(@"保存成功");
            }else{
                DLOG(@"保存失败");
            }
        }];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _maleArray.count;
    }else if (section == 1){
        return _famelArray.count;
    }else{
        return _otherArray.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BookCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCategoryCell" forIndexPath:indexPath];
    BookCategoryModel *model;
    if (indexPath.section == 0) {
        model = self.maleArray[indexPath.row];
    }else if (indexPath.section == 1){
        model = self.famelArray[indexPath.row];
    }else{
        model = self.otherArray[indexPath.row];
    }
    [cell createCellWithModel:model];
    return cell;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        label.textColor = [UIColor colorWithHexString:@"0x999999"];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        if (indexPath.section == 0) {
            label.text = @"男频";
        }else if (indexPath.section == 1){
            label.text = @"女频";
        }else{
            label.text = @"其他文学";
        }
        
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        } // 防止复用分区头
        [header addSubview:label];

        return header;
    } else {
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url;
    NSString *str;
    if (indexPath.section == 0) {
        // http://api.zhuishushenqi.com/book/by-categories?gender=female&type=hot&major=%E9%9D%92%E6%98%A5%E6%A0%A1%E5%9B%AD&start=0&limit=50
        BookCategoryModel *model = _maleArray[indexPath.row];
        str = model.name;
        NSString *encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)str,
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));
        url = [NSString stringWithFormat:@"http://api.zhuishushenqi.com/book/by-categories?gender=male&type=hot&major=%@&start=0&limit=50",encodedString];
    }else if(indexPath.section == 1){
        BookCategoryModel *model = _famelArray[indexPath.row];
        str = model.name;
        NSString *encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)str,
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));
//        [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSString stringWithFormat:@"http://api.zhuishushenqi.com/book/by-categories?gender=female&type=hot&major=%@&start=0&limit=50",encodedString];
    }else{
        BookCategoryModel *model = _otherArray[indexPath.row];
        str = model.name;
        NSString *encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)str,
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));
        url = [NSString stringWithFormat:@"http://api.zhuishushenqi.com/book/by-categories?gender=press&type=hot&major=%@&start=0&limit=50",encodedString];
    }
    
    
    BookCategoryDetailViewController *dvc = [[BookCategoryDetailViewController alloc]initWithDefaultNibName];
    dvc.type = BookCategoryType;
    dvc.navigationItem.title = str;
    dvc.url = url;
    [self.navigationController pushViewController:dvc animated:YES];
    
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
