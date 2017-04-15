//
//  BookChapterModel.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookChapterModel.h"

@implementation BookChapterModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.link forKey:@"link"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.unreadble forKey:@"unreadble"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.link = [aDecoder decodeObjectForKey:@"link"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.unreadble = [aDecoder decodeIntegerForKey:@"unreadble"];
    }
    return self;
}

@end
