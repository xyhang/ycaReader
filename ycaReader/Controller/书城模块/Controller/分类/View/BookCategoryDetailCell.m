//
//  BookCategoryDetailCell.m
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookCategoryDetailCell.h"

@implementation BookCategoryDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.novelTitle.font = [UIFont boldSystemFontOfSize:14];
    // Initialization code
}

-(void)createCellWithModel:(BookRankDetailModel *)model{
    NSString *cover;
    if ([model.cover hasPrefix:@"/agent/"])  {
        cover = [model.cover stringByReplacingOccurrencesOfString:@"/agent/" withString:@""];
    }else{
        cover = [NSString stringWithFormat:@"http://api.zhuishushenqi.com%@",model.cover];
    }
    
    [self.novelImg sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:[UIImage imageNamed:@""]];
    
    self.novelTitle.text = model.title;
    self.novelAuthor.text = model.author;
    self.novelCategory.text = model.majorCate;
    self.novelDetail.text = model.shortIntro;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
