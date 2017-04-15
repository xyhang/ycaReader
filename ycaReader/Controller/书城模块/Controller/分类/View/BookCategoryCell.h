//
//  BookCategoryCell.h
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookCategoryModel.h"
@interface BookCategoryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *novelTitle;

@property (weak, nonatomic) IBOutlet UILabel *novelCount;


-(void)createCellWithModel:(BookCategoryModel *)model;

@end
