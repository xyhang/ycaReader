//
//  BookShelfModel.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookShelfManager.h"

@implementation BookShelfManager

+(instancetype)shareModel{
    static BookShelfManager *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[BookShelfManager alloc]init];
        model.dataArray = [[NSMutableArray array] mutableCopy];
    });
    return model;
}

@end
