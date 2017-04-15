//
//  NSArciverManager.h
//  ycaReader
//
//  Created by yan on 2017/4/14.
//  Copyright © 2017年 yca. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef BOOL(^SaveStateBlock)();

@interface NSArciverManager : NSObject

/// 单利模式
+(instancetype)shareManager;



/// 保存到本地
-(void)saveArchiver:(id)obj WithAPIKey:(NSString *)key WithBlock:(void (^)(BOOL state))SaveStateBlock;

/// 获取数据
-(id)archiverObjWithAPIKey:(NSString *)key;


@end
