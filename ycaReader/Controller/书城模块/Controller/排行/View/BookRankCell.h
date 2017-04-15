//
//  BookRankCell.h
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BookRankModel.h"

@interface BookRankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *rankBackView;

@property (weak, nonatomic) IBOutlet UILabel *rankTitle;


-(void)createCellWithModel:(BookRankModel *)model;

@end
