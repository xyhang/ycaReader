//
//  BookRankDetailModel.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookRankDetailModel.h"

@implementation BookRankDetailModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self._id forKey:@"_id"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.shortIntro forKey:@"shortIntro"];
    [aCoder encodeObject:self.cat forKey:@"cat"];
    [aCoder encodeObject:self.majorCate forKey:@"majorCate"];
    [aCoder encodeObject:self.site forKey:@"site"];
    [aCoder encodeObject:self.retentionRatio forKey:@"retentionRatio"];
    [aCoder encodeInteger:self.banned forKey:@"banned"];
    [aCoder encodeInteger:self.latelyFollower forKey:@"latelyFollower"];
    [aCoder encodeObject:self.lastChapter forKey:@"lastChapter"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    [aCoder encodeObject:self.updated forKey:@"updated"];
    [aCoder encodeObject:self.addTime forKey:@"addTime"];


}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self._id = [aDecoder decodeObjectForKey:@"_id"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.shortIntro = [aDecoder decodeObjectForKey:@"shortIntro"];
        self.cat = [aDecoder decodeObjectForKey:@"cat"];
        self.majorCate = [aDecoder decodeObjectForKey:@"majorCate"];
        self.site = [aDecoder decodeObjectForKey:@"site"];
        self.retentionRatio = [aDecoder decodeObjectForKey:@"retentionRatio"];
        self.banned = [aDecoder decodeIntegerForKey:@"banned"];
        self.latelyFollower = [aDecoder decodeIntegerForKey:@"latelyFollower"];
        self.lastChapter = [aDecoder decodeObjectForKey:@"lastChapter"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"];
        self.updated = [aDecoder decodeObjectForKey:@"updated"];
        self.addTime = [aDecoder decodeObjectForKey:@"addTime"];


    }
    return self;
}


@end
