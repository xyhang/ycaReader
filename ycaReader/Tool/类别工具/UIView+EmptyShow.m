//
//  UIView+EmptyShow.h
//  常用类别工具
//
//  Created by yan on 16/7/13.
//  Copyright © 2016年 nawei. All rights reserved.
//

#import "UIView+EmptyShow.h"

#import "Masonry.h"
#import <objc/runtime.h>

static char WarningViewKey;

@implementation UIView (EmptyShow)

//利用runtime给类别添加属性
- (void)setWarningView:(CustomerWarnView *)warningView{
    [self willChangeValueForKey:@"WarningViewKey"];
    objc_setAssociatedObject(self, &WarningViewKey, warningView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"WarningViewKey"];
}

- (CustomerWarnView *)warningView{
    return objc_getAssociatedObject(self, &WarningViewKey);
}

- (void)emptyDataCheckWithType:(ViewDataType)dataType andHaveData:(BOOL)haveData andReloadBlock:(ReloadDataBlock)block{
    if (self.warningView) {
        [self.warningView removeFromSuperview];
    }
    if (!haveData) {
        self.warningView = [CustomerWarnView initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andType:dataType];
       
        if (!block || dataType == ViewDataTypeShoping || dataType == ViewDataTypeAttention || dataType == ViewDataTypeDetail) {
            self.warningView.loadBtn.hidden = YES;
        }
        self.warningView.reloadBlock = block;
        [self addSubview:self.warningView];
        [self bringSubviewToFront:self.warningView];
    }
}

@end



@implementation CustomerWarnView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = [UIFont systemFontOfSize:15.0];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        
        _loadBtn = [[UIButton alloc]init];
//        [_loadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _loadBtn.layer.borderColor = [UIColor grayColor].CGColor;
//        _loadBtn.layer.borderWidth = 1;
//        _loadBtn.layer.cornerRadius = 2.0;
//        _loadBtn.layer.masksToBounds = YES;
        [_loadBtn setImage:[UIImage imageNamed:@"blank_btn_retry"] forState:UIControlStateNormal];
//        [_loadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_loadBtn addTarget:self action:@selector(loadClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loadBtn];
        self.backgroundColor = [UIColor colorWithHexString:@"0xf1f1f1"];
        [self prepareSubView];
    }
    return self;
}

- (void)loadClick{
    
    if (_reloadBlock) {
        _reloadBlock();
    }
    //淡出，不喜可去
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

//布局
- (void)prepareSubView{
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-120);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(_imageView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
    }];
    
    [_loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(_tipLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
}

+ (CustomerWarnView *)initWithFrame:(CGRect)frame andType:(ViewDataType)type{
    CustomerWarnView *warningView = [[CustomerWarnView alloc]initWithFrame:frame];
    NSString *imageName,*tip;
    switch (type) {
        case ViewDataTypeHomePage:
            imageName = @"blank_page_logo";
            tip = @"列表空空如也,请刷新试试";
            break;
        case ViewDataTypeShoping:
            imageName = @"blank_collectionError";
            tip = @"还未添加收藏哦";
            break;
        case ViewDataTypeArticle:
            imageName = @"blank_collectionError";
            tip = @"还未添加收藏哦";
            break;
        case ViewDataTypeDetail:
            imageName = @"blank_detail";
            tip = @"暂无明细记录";
            break;
        case ViewDataTypeAttention:
            imageName = @"blank_attentionError";
            tip = @"您还未关注任何企业哦";
            break;
        case ViewDataTypeLoadFail:
            imageName = @"blank_networkError";
            tip = @"网络连接失败";
            break;
        default:
            break;
    }
    [warningView.imageView setImage:[UIImage imageNamed:imageName]];
    warningView.tipLabel.text = tip;
   
    return warningView;
}

@end

