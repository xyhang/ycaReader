//
//  BookCategoryModel.m
//  ycaReader
//
//  Created by yan on 2017/4/15.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookCategoryModel.h"

@implementation BookCategoryModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.bookCount forKey:@"bookCount"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.bookCount = [aDecoder decodeObjectForKey:@"bookCount"];
    }
    return self;
}


@end
