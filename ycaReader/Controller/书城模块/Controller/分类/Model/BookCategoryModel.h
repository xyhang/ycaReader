//
//  BookCategoryModel.h
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCategoryModel : NSObject<NSCoding>

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *bookCount;

@end
