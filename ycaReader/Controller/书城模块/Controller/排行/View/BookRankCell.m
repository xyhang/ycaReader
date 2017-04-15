//
//  BookRankCell.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookRankCell.h"



@implementation BookRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)createCellWithModel:(BookRankModel *)model{
    self.rankTitle.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
