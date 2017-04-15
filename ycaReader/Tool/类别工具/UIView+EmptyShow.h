//
//  UIView+EmptyShow.h
//  常用类别工具
//
//  Created by yan on 16/7/13.
//  Copyright © 2016年 nawei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReloadDataBlock)();

typedef NS_ENUM(NSInteger, ViewDataType)
{
    ViewDataTypeHomePage = 0,
    ViewDataTypeShoping,
    ViewDataTypeAttention,
    ViewDataTypeDetail,
    ViewDataTypeArticle,
    ViewDataTypeLoadFail//web页加载失败
    
};

@interface CustomerWarnView : UIView
//提示图
@property (nonatomic, strong) UIImageView     *imageView;
//提示文字
@property (nonatomic, strong) UILabel         *tipLabel;
//刷新按钮
@property (nonatomic, strong) UIButton        *loadBtn;
//用于回调
@property (nonatomic, copy) ReloadDataBlock reloadBlock;
//初始化
+ (CustomerWarnView *)initWithFrame:(CGRect)frame andType:(ViewDataType)type;


@end

@interface UIView (EmptyShow)

@property (strong, nonatomic) CustomerWarnView *warningView;

- (void)emptyDataCheckWithType:(ViewDataType)emptyType
                   andHaveData:(BOOL)haveData
                andReloadBlock:(ReloadDataBlock)block;

@end



