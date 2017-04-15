//
//  LCESwitch.m
//  LCESwitch
//
//  Created by juziwl on 15/6/25.
//  Copyright (c) 2015年 juziwl. All rights reserved.
//

#import "LCESwitch.h"
@interface LCESwitch ()


@end


@implementation LCESwitch


+ (instancetype)lceSwitchCGRect:(CGRect)frame masks:(BOOL)masks;
{
    
    LCESwitch *headerView = [[LCESwitch alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMidY(frame), CGRectGetWidth(frame), 40)];
    if (masks) {
        headerView.layer.masksToBounds=YES;
        headerView.layer.cornerRadius=20.0f;
    }
    
    return headerView;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    UIView *sliderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/titleArray.count, 40)];
    sliderView.layer.cornerRadius=18.0f;
    sliderView.layer.masksToBounds=YES;
    sliderView.backgroundColor=[UIColor blueColor];
    [self addSubview:sliderView];
    self.sliderView=sliderView;
    
    [titleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=775566+idx;
        btn.frame=CGRectMake((self.frame.size.width/titleArray.count)*idx, 5, self.frame.size.width/titleArray.count, 30);
        [btn setExclusiveTouch:YES];
        btn.titleLabel.font=[UIFont systemFontOfSize:12.0f];
        [btn setTitle:obj forState:UIControlStateNormal];
        
        if (idx==0) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn.layer.cornerRadius=15.0f;
        [btn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
    
    
}

    
-(void)clickEvent:(UIButton *)sender
{
    UIButton *button=(UIButton *)[self viewWithTag:sender.tag];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    NSInteger index=sender.tag-775566;
    
    if(index==self.currentIndex)
    {
        return;
    }else
    {
        UIButton *button=(UIButton *)[self viewWithTag:(NSInteger)(self.currentIndex+775566)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
//    NSLog(@"123");

    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.sliderView.frame= CGRectMake(sender.frame.origin.x, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
    }completion:^(BOOL finished) {
        
    }];
    
    self.currentIndex=index;
    
    self.switchBlock(self.currentIndex);

}






@end
