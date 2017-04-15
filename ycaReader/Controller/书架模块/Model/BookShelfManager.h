//
//  BookShelfModel.h
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookShelfManager : NSObject

+(instancetype)shareModel;

@property (nonatomic , strong) NSMutableArray *dataArray;

@end
