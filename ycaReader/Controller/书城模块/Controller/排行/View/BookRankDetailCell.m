//
//  BookRankDetailCell.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "BookRankDetailCell.h"

@implementation BookRankDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.novelTitle.font = [UIFont boldSystemFontOfSize:14];
    self.novelUpdate.v_cornerRadius = 6;
    // Initialization code
}

-(void)createCellWithModel:(BookRankDetailModel *)model{
    NSString *cover;
    if ([model.cover hasPrefix:@"/agent/"])  {
        cover = [model.cover stringByReplacingOccurrencesOfString:@"/agent/" withString:@""];
    }else{
        cover = [NSString stringWithFormat:@"http://api.zhuishushenqi.com%@",model.cover];
    }
    
    [self.novelImg sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:[UIImage imageNamed:@""]];
    
    self.novelTitle.text = model.title;
    self.novelAuthor.text = model.author;
    self.novelCategory.text = model.cat;
    
    NSString *tempStr = [model.updated stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSArray *tempArr = [tempStr componentsSeparatedByString:@"."];
    NSString *temp = tempArr[0];
    
    
    NSString *str;
    if (model.updated) {
        str = [self getDifferenceByDate:temp];
    }
    if (model.lastChapter) {
        self.novelDetail.text = [NSString stringWithFormat:@"%@%@",str,model.lastChapter];
    }else{
        self.novelDetail.text = model.shortIntro;
    }
    
    
    if (model.addTime) {
        if ([self compareOneDay:temp withAnotherDay:model.addTime]>0) {
            self.novelUpdate.hidden = NO;
        }else{
            self.novelUpdate.hidden = YES;
        }
    }
    
}

/**
 *  计算剩余时间
 *
 *  @param endTime   结束日期
 *
 *  @return 剩余时间
 */
- (NSString *)getDifferenceByDate:(NSString *)date {
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitMinute;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    NSString *str ;
    
    if ([comps minute]) {
        NSInteger minute = [comps minute];
        if (minute<60) {
            str = [NSString stringWithFormat:@"%ld分钟前前更新：",minute];
        }else{
            NSInteger hour = minute/60;
            if (hour<24) {
                str = [NSString stringWithFormat:@"%ld小时前更新：",hour];
            }else{
                NSInteger day = hour/24;
                str = [NSString stringWithFormat:@"%ld天前更新：",day];
            }
        }
       

    }
    
    return str;
}


-(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
//    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result ==NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
