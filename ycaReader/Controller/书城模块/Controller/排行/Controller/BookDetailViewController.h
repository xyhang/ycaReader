//
//  BookDetailViewController.h
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BaseViewController.h"
#import "BookRankDetailModel.h"
@interface BookDetailViewController : BaseViewController

@property (nonatomic , strong) BookRankDetailModel *model;


@property (weak, nonatomic) IBOutlet UIImageView *novelImg;
@property (weak, nonatomic) IBOutlet UILabel *novelTitle;

@property (weak, nonatomic) IBOutlet UILabel *novelAuthor;

@property (weak, nonatomic) IBOutlet UILabel *novelCat;

@property (weak, nonatomic) IBOutlet UIButton *addBookBtn;

@property (weak, nonatomic) IBOutlet UIButton *onLineViewBtn;


- (IBAction)addBookAction:(id)sender;

- (IBAction)novelViewAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *novelIntroduce;


@end
