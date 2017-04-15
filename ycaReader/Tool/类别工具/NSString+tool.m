//
//  NSString+tool.m
//  常用类别工具
//
//  Created by yan on 16/7/13.
//  Copyright © 2016年 nawei. All rights reserved.
//

#import "NSString+tool.h"

@implementation NSString (tool)

+ (NSString *) getDeviceIdentifierForVendor{
    return  [[UIDevice currentDevice].identifierForVendor UUIDString];
}


+ (NSString*) format:(NSTimeInterval) time;
{
    if (time < 0)
    {
        return @"";
    }
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    return [formatter stringFromDate:date];
}

+ (NSString*) formatTime:(NSTimeInterval) time;
{
    if (time < 0)
    {
        return @"";
    }
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    return [formatter stringFromDate:date];
}

+ (NSString *) formatDateAndTime:(NSTimeInterval)time;{
    if (time < 0) {
        return @"";
    }
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [formatter stringFromDate:date];
}

+(NSString *)formatTimeInterval:(NSTimeInterval)time{
    if (time<0) {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeInterval:time sinceDate:[NSDate date]];
    return [formatter stringFromDate:date];
}

+(NSString *)stringWithNowDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [formatter setDateFormat:@"HH:mm a"];
    return [formatter stringFromDate:date];
}

- (RangeFormatType)checkRange:(NSRange)range{
    NSInteger loc = range.location;
    NSInteger len = range.length;
    if (loc>=0 && len>0) {
        if (range.location + range.length <= self.length) {
            return RangeCorrect;
        }
        else{
            NSLog(@"The range out-of-bounds!");
            return RangeOut;
        }
    }
    else{
        NSLog(@"The range format is wrong: NSMakeRange(a,b) (a>=0,b>0). ");
        return RangeError;
    }
}

- (NSMutableAttributedString *)changeColor:(UIColor *)color
                                  andRange:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if ([self checkRange:range] == RangeCorrect) {
        if (color) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        else{
            NSLog(@"color is nil");
        }
        
    }
    return attributedStr;
}


- (NSMutableAttributedString *)changeFont:(UIFont *)font
                                 andRange:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if ([self checkRange:range] == RangeCorrect) {
        if (font) {
            [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        }
        else{
            NSLog(@"font is nil...");
        }
    }
    return attributedStr;
}


- (NSMutableAttributedString *)changeColor:(UIColor *)color
                              andColorRang:(NSRange)colorRange
                                   andFont:(UIFont *)font
                              andFontRange:(NSRange)fontRange{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if ([self checkRange:colorRange] == RangeCorrect) {
        if (color) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
        }
        else{
            NSLog(@"color is nil");
        }
    }
    if ([self checkRange:fontRange] == RangeCorrect) {
        if (font) {
            [attributedStr addAttribute:NSFontAttributeName value:font range:fontRange];
        }
        else{
            NSLog(@"font is nil...");
        }
    }
    return attributedStr;
}

- (NSMutableAttributedString *)changeColor:(UIColor *)color andRanges:(NSArray<NSValue *> *)ranges{
    __block NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if (color) {
        [ranges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [(NSValue *)obj rangeValue];
            if ([self checkRange:range] == RangeCorrect) {
                [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            }
            else{
                NSLog(@"index:%ld",idx);
            }
            
        }];
    }
    else{
        NSLog(@"color is nil...");
    }
    return attributedStr;
}

- (NSMutableAttributedString *)changeFont:(UIFont *)font andRanges:(NSArray<NSValue *> *)ranges{
    __block NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if (font) {
        [ranges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [(NSValue *)obj rangeValue];
            if ([self checkRange:range] == RangeCorrect) {
                [attributedStr addAttribute:NSFontAttributeName value:font range:range];
            }
            else{
                NSLog(@"index:%ld",idx);
            }
            
        }];
    }
    else{
        NSLog(@"font is nil...");
    }
    return attributedStr;
}

+ (NSString *)calculateTimeWithTimeFormatter:(long long)timeSecond {
    NSString * theLastTime = nil;
    if (timeSecond < 60) {
        theLastTime = [NSString stringWithFormat:@"00:%.2lld", timeSecond];
    }else if(timeSecond >= 60 && timeSecond < 3600){
        theLastTime = [NSString stringWithFormat:@"%.2lld:%.2lld", timeSecond/60, timeSecond%60];
    }else if(timeSecond >= 3600){
        theLastTime = [NSString stringWithFormat:@"%.2lld:%.2lld:%.2lld", timeSecond/3600, timeSecond%3600/60, timeSecond%60];
    }
    return theLastTime;
}


//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


@end
