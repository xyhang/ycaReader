//
//  BookCategoryCell.m
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookCategoryCell.h"

@implementation BookCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _novelTitle.font = [UIFont boldSystemFontOfSize:14];
    
}

-(void)createCellWithModel:(BookCategoryModel *)model{
    _novelTitle.text = model.name;
    _novelCount.text = [NSString stringWithFormat:@"%@本",model.bookCount];
}


@end
