//
//  BookChapterModel.h
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookChapterModel : NSObject<NSCoding>

@property (nonatomic , copy) NSString *link;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , assign) NSInteger unreadble;

@end
