//
//  NSArciverManager.m
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import "NSArciverManager.h"

@implementation NSArciverManager

+(instancetype)shareManager{
    static NSArciverManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NSArciverManager alloc]init];
    });
    return manager;
}

-(void)saveArchiver:(id)obj WithAPIKey:(NSString *)key WithBlock:(void (^)(BOOL))SaveStateBlock{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:obj forKey:key];
    [archiver finishEncoding];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    BOOL suc = [data writeToFile:filePath atomically:YES];
    SaveStateBlock(suc);
    if (suc) {
        DLOG(@"\n ******成功******* \n");
    }else{
        DLOG(@"\n ******失败******* \n");
    }
}

-(id)archiverObjWithAPIKey:(NSString *)key{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    return [unArchiver decodeObjectForKey:key];
}

-(void)clearArchiverWithKey:(NSString *)key{
    
}

@end
