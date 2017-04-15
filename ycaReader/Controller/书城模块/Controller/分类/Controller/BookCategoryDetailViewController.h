//
//  BookCategoryDetailViewController.h
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    BookCategoryType,
    BookSerachType,
} BookType;

@interface BookCategoryDetailViewController : BaseViewController

@property (nonatomic , copy) NSString *url;

@property (nonatomic , assign) BookType type;


@end
