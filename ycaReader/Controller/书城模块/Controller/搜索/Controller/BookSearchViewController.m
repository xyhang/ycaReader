//
//  BookSearchViewController.m
//  ycaReader
//
//  Created by yan on 2017/4/13.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookSearchViewController.h"
#import "PYSearch.h"
#import "BookCategoryDetailViewController.h"
#import "YCANavigationController.h"
@interface BookSearchViewController ()<PYSearchViewControllerDelegate>

@property (nonatomic , strong) NSArray *hotArr;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapClick;

- (IBAction)tapClickAction:(id)sender;

@end

@implementation BookSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHotData];
    _hotArr = [[NSArciverManager shareManager] archiverObjWithAPIKey:@"HotSearch"];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 请求热门搜索
-(void)loadHotData{
    [[YCAHttpRequetTool shareTool] get:@"http://api.zhuishushenqi.com/book/hot-word" params:nil success:^(id responseObj) {
        _hotArr = responseObj[@"hotWords"];
        [[NSArciverManager shareManager] saveArchiver:_hotArr WithAPIKey:@"HotSearch" WithBlock:^(BOOL state) {
            
        }];
    } failure:^(NSError *error) {
        
    } progress:^(NSProgress *progress) {
        
    }];
}

#pragma mark - 构建搜索视图
-(void)createSearchUI{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:_hotArr searchBarPlaceholder:NSLocalizedString(@"search", @"功法搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        BookCategoryDetailViewController *cvc = [[BookCategoryDetailViewController alloc]initWithDefaultNibName];
        NSString *encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)searchText,
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));
        cvc.url = [NSString stringWithFormat:@"http://api.zhuishushenqi.com/book/fuzzy-search?start=0&limit=100&query=%@",encodedString];
        cvc.type = BookSerachType;
        cvc.navigationItem.title = @"搜索";
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:cvc animated:YES];
    }];
    
    searchViewController.hotSearchStyle = 1;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    searchViewController.delegate = self;

    YCANavigationController *nav = [[YCANavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
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

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *encodedString = (NSString *)
            CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                      
                                                                      (CFStringRef)searchText,
                                                                      
                                                                      (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                      
                                                                      NULL,
                                                                      
                                                                      kCFStringEncodingUTF8));

            NSString *url = [NSString stringWithFormat:@"http://api.zhuishushenqi.com/book/auto-complete?query=%@",encodedString];
            [[YCAHttpRequetTool shareTool] get:url params:nil success:^(id responseObj) {
                searchViewController.searchSuggestions = responseObj[@"keywords"];
            } failure:^(NSError *error) {
                
            } progress:^(NSProgress *progress) {
                
            }];
//            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
//                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
//                [searchSuggestionsM addObject:searchSuggestion];
//            }
            // Refresh and display the search suggustions

        });
    }
}




- (IBAction)tapClickAction:(id)sender {
    if (_hotArr) {
        [self createSearchUI];
    }
}
@end
