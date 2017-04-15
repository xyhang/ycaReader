//
//  YCAHttpRequetTool.h
//  网络请求类
//
//  Created by yan on 16/7/4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  网络监测block
 */
typedef void(^CheackNetStateBlock)(BOOL isWifi);

/**
 *  请求成功block
 */
typedef void(^requestSuccessBlock)(id responseObj);

/**
 *  请求失败block
 */
typedef void(^requestFaildBlock)(NSError *error);

/**
 *  请求相应block
 */
typedef void(^responseBlock)(id dataObj, NSError *error);

/**
 *  监听进度block
 */
typedef void(^progressBlock)(NSProgress *progress);

typedef NS_ENUM(NSInteger , YCANetWorkState)
{
    YCANetworkUnknown = -1,
    YCANetworkNotReachable = 0,
    YCANetworkReachableWWAN = 1,
    YCANetworkWIFI = 2,
};


typedef NS_ENUM(NSInteger, YCAHttpRequestCachePolicy)
{
    /** 有缓存就返回缓存,并且继续请求数据 **/
    YCAHttpReturnCacheDataThenLoad = 0,
    /** 忽略缓存,重新请求 **/
    YCAHttpIgnoreCache,
    /** 有缓存就返回缓存数据,没有就请求数据 **/
    YCAHttpReturnCacheDataElseLoad,
    /** 有缓存就返回缓存数据,没有不请求数据,返回空 **/
    YCAHttpReturnCacheDataThenDontLoad
};

@interface YCAHttpRequetTool : NSObject

/**
 *  超时
 */
@property (nonatomic,assign) NSTimeInterval *timeOutInterval;
@property (nonatomic , copy) CheackNetStateBlock checkNetStateBlock;

/// 创建单利
+(YCAHttpRequetTool *)shareTool;


//+(void)startNetworkingCheackWithTarget:(id)target withCheackBlock:(CheackNetStateBlock)cheackBlock;

//+(void)startNetworkingCheackWithTarget:(id)target withCheackBlock:(CheackNetStateBlock)cheackBlock;


-(void)get:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock;


/**
 *  POST 请求 默认 YCAHttpReturnCacheDataThenLoad
 */
-(void)post:(NSString *)url params:(NSDictionary *)params sucess:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock;
/**
 *  delete请求
 *
 *  @param url           请求URL
 *  @param params        参数
 *  @param successBlock  成功block
 *  @param faildBlock    失败block
 *  @param progressBlock 进度block
 */
-(void)delete:(NSString *)url params:(NSDictionary *)params sucess:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock;

//  post上传图片
-(void)uploadAvatarImgWithUrl:(NSString *)url WithParams:(NSDictionary *)parmas WithImg:(UIImage *)avatarImg fileName:(NSString *)fileName imgParams:(NSString *)imgParams success:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock;

// post上传多张图片
-(void)uploadImgWithUrl:(NSString *)url WithParams:(NSDictionary *)parmas WithImgArr:(NSArray *)imgArr fileName:(NSArray *)fileNameArr imgArrParams:(NSArray *)imgParamsArray success:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock;


/**
 *  PUT 请求
 */

-(void)put:(NSString *)url params:(NSDictionary *)params sucess:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock;

@end
