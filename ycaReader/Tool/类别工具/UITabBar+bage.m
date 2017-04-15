//
//  UITabBar+bage.m
//  Ihere
//
//  Created by 那位科技 on 2016/12/15.
//  Copyright © 2016年 haierwenhua. All rights reserved.
//

#import "UITabBar+bage.h"


#define TabbarItemNums 3.0

@implementation UITabBar (bage)


-(void)showBadgeOnItemIndex:(NSInteger)index{
    // 移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    // 新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 100+index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    /// 确定小红点位置
    float percentX = (index + .6)/TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(.1*tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
    
}

-(void)hideBadgeOnItemIndex:(NSInteger)index{
    [self removeBadgeOnItemIndex:index];
}

-(void)removeBadgeOnItemIndex:(NSInteger)index{
    
}


@end
