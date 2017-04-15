//
//  UIImage+tool.h
//  常用类别工具
//
//  Created by yan on 16/7/13.
//  Copyright © 2016年 nawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (tool)

/**
 *  等比缩放
 *
 *  @param size 设置尺寸
 *
 *  @return image
 */
-(UIImage *)scaleImageToSize:(CGSize)size;
/**
 *  自定长宽
 *
 *  @param reSize 设置尺寸
 *
 *  @return image
 */
-(UIImage *)imageReSize:(CGSize)reSize;
/**
 *  剪切
 *
 *  @param cutRect 选取截取部分
 *
 *  @return image
 */
-(UIImage *)cutImageWithRect:(CGRect)cutRect;
/**
 *  压缩
 *
 *  @param image 待压缩的图片
 *
 *  @return image
 */
+ (UIImage *)smallTheImage:(UIImage *)image;
/**
 *  压缩（上传）
 *
 *  @param image 待压缩图片
 *
 *  @return 图片的二进制文件
 */
+ (NSData *)smallTheImageBackData:(UIImage *)image;
/**
 *  view转位图（一般用于截图）
 *
 *  @param view 需要转化的view
 *
 *  @return image
 */
+ (UIImage *)imageFromView:(UIView*)view;

@end
