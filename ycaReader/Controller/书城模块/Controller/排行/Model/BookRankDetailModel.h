//
//  BookRankDetailModel.h
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookRankDetailModel : NSObject<NSCoding>

@property (nonatomic , copy) NSString* _id;


@property (nonatomic , copy) NSString *cover;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , copy) NSString *author;

@property (nonatomic , copy) NSString *shortIntro;

@property (nonatomic , copy) NSString *cat;
@property (nonatomic , copy) NSString *majorCate;


@property (nonatomic , copy) NSString *site;

@property (nonatomic , assign) NSInteger banned;

@property (nonatomic , assign) NSInteger latelyFollower;

@property (nonatomic , copy) NSString * retentionRatio;

@property (nonatomic , copy) NSString *lastChapter;

@property (nonatomic , strong) NSArray *tags;

@property (nonatomic , strong) NSString *updated;

@property (nonatomic , strong) NSString *addTime;

@end
