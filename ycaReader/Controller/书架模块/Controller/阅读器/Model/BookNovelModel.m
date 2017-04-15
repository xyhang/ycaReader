//
//  BookNovelModel.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookNovelModel.h"

@implementation BookNovelModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.body forKey:@"body"];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [aDecoder decodeObjectForKey:@"body"];
    }
    return self;
}

@end
