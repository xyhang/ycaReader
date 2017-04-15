//
//  BookReadModel.h
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookChapterModel.h"
#import "BookNovelModel.h"
#import "BookRecordModel.h"
@interface BookReadModel : NSObject<NSCoding>

@property (nonatomic , strong) NSMutableArray <BookChapterModel*> *chapters;

@property (nonatomic , strong) NSMutableArray <BookNovelModel *> *novels;

@property (nonatomic , strong) BookRecordModel *recoder;


@end
