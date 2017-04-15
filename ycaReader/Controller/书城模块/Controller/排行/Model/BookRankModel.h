//
//  BookRankModel.h
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookRankModel : NSObject

@property (nonatomic , copy) NSString * _id;

@property (nonatomic , assign) NSInteger collapse;

@property (nonatomic , copy) NSString * monthRank;

@property (nonatomic , copy) NSString * totalRank;

@property (nonatomic , copy) NSString *cover;

@property (nonatomic , copy) NSString *title;

@end
