//
//  BookCategoryDetailCell.h
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookRankDetailModel.h"
@interface BookCategoryDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *novelImg;
@property (weak, nonatomic) IBOutlet UILabel *novelTitle;

@property (weak, nonatomic) IBOutlet UILabel *novelAuthor;
@property (weak, nonatomic) IBOutlet UILabel *novelCategory;

@property (weak, nonatomic) IBOutlet UILabel *novelDetail;


-(void)createCellWithModel:(BookRankDetailModel *)model;

@end
