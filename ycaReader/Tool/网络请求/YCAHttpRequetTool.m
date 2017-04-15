//
//  YCAHttpRequetTool.m
//  网络请求类
//
//  Created by yan on 16/7/4.
//
//

#import "YCAHttpRequetTool.h"
#import "AFNetworking.h"
#import "netdb.h"
#import "AppDelegate.h"
//#import "CRSA.h"
//#import "Base64.h"



typedef NS_ENUM(NSInteger, YCAReuestType) {
    YCARequest_Get = 0,
    YCARequest_Post,
    YCARequest_Delete,
    YCARequest_Put
};

@interface YCAHttpRequetTool()

@property (nonatomic , strong)AFHTTPSessionManager *manager;

//@property (nonatomic , strong)NSString *hostUrl;

@end

@implementation YCAHttpRequetTool

+(YCAHttpRequetTool *)shareTool{
    static YCAHttpRequetTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YCAHttpRequetTool alloc]init];
    });
    return instance;
}

-(id)init{
    if (self = [super init]) {
//        _hostUrl = [[NSBundle mainBundle] pathForResource:@"Ihere" ofType:@"plist"];

        // 创建请求管理者
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 请求参数序列化类型
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer ];
        // 请求超时设定
        self.manager.requestSerializer.timeoutInterval = 10;
        // 设置请求类型
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"gzip",nil];
    }
    return self;
}

    
-(void)get:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock{
    
    [YCAHttpRequetTool requestMethod:YCARequest_Get WithUrl:url params:params success:successBlock faild:faildBlock progress:progressBlock];
}

-(void)post:(NSString *)url params:(NSDictionary *)params sucess:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock{
    [YCAHttpRequetTool requestMethod:YCARequest_Post WithUrl:url params:params success:successBlock faild:faildBlock progress:progressBlock];
}

-(void)delete:(NSString *)url params:(NSDictionary *)params sucess:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock{
    [YCAHttpRequetTool requestMethod:YCARequest_Delete WithUrl:url params:params success:successBlock faild:faildBlock progress:progressBlock];
}

-(void)uploadAvatarImgWithUrl:(NSString *)url WithParams:(NSDictionary *)parmas WithImg:(UIImage *)avatarImg fileName:(NSString *)fileName imgParams:(NSString *)imgParams success:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock{
    NSData *imgData = UIImageJPEGRepresentation(avatarImg, 0.5);
    BOOL isConnect = [YCAHttpRequetTool isConnectionAvailable];
    if (!isConnect) {
        faildBlock(nil);
        successBlock(nil);
        NSLog(@"网络错误");
        return;
    }
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"fabo_config" ofType:@"plist"];
//    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
//    NSString *baseUrl = dic2[@"baseURL"];
//    NSString *urlStr;
//    if ([url hasPrefix:@"http://"]) {
//        urlStr = url;
//    }else{
//       urlStr = [NSString stringWithFormat:@"%@%@",baseUrl,url];
//    }

    [[YCAHttpRequetTool shareTool].manager POST:url parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imgData name:imgParams fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        successBlock(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faildBlock(error);
    }];
    
}

-(void)uploadImgWithUrl:(NSString *)url WithParams:(NSDictionary *)parmas WithImgArr:(NSArray *)imgArr fileName:(NSArray *)fileNameArr imgArrParams:(NSArray *)imgParamsArray success:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock{
    BOOL isConnect = [YCAHttpRequetTool isConnectionAvailable];
    if (!isConnect) {
        faildBlock(nil);
        successBlock(nil);
        NSLog(@"网络错误");
        return;
    }
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"fabo_config" ofType:@"plist"];
//    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
//    NSString *baseUrl = dic2[@"baseURL"];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    [[YCAHttpRequetTool shareTool].manager POST:url parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imgArr.count; i++) {
            
            UIImage *image = imgArr[i];
            NSString *name = imgParamsArray[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        successBlock(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faildBlock(error);

    }];
    
}



#pragma mark -- put
-(void)put:(NSString *)url params:(NSDictionary *)params sucess:(requestSuccessBlock)successBlock failure:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock{
    [YCAHttpRequetTool requestMethod:YCARequest_Put WithUrl:url params:params success:successBlock faild:faildBlock progress:progressBlock];

}

#pragma mark  私有方法
+(void)requestMethod:(YCAReuestType)type WithUrl:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successBlock faild:(requestFaildBlock)faildBlock progress:(progressBlock)progressBlock{

    BOOL isConnect = [YCAHttpRequetTool isConnectionAvailable];
    if (!isConnect) {
//        NSError *error = @"网络错误";
//        faildBlock(@"网络错误");
        
        NSLog(@"网络错误");
        return;
    }
      switch (type) {
          case YCARequest_Get:{
              // get
              // 发送请
              [[YCAHttpRequetTool shareTool].manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                  progressBlock(downloadProgress);
              } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  BOOL isGzip = [responseObject isGzippedData];
//                  NSData *data = [responseObject gzipUnpack];
//                  if (data) {
//                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                  }
                  if (isGzip) {
                      NSData *data = [responseObject gunzippedData];
                      
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      if (dic) {
                          successBlock(dic);
                      }

                  }else{
                      
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                      
                      if (dic) {
                          successBlock(dic);
                      }else{
                          NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                          successBlock(str);
                      }
                      
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  faildBlock(error);
              }];
              break;
          }
          case YCARequest_Post:{
              [[YCAHttpRequetTool shareTool].manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

              } progress:^(NSProgress * _Nonnull uploadProgress) {
                  progressBlock(uploadProgress);

              } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  if (dic) {
                      successBlock(dic);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  faildBlock(error);

              }];

              break;
          }
          case YCARequest_Delete:{
              [[YCAHttpRequetTool shareTool].manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  successBlock(dic);
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  faildBlock(error);
              }];

              break;
          }
          case YCARequest_Put:{
              [[YCAHttpRequetTool shareTool].manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  successBlock(dic);
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  faildBlock(error);
              }];
          }
      }
}


// 查看网络状态是否给力
+ (BOOL)isConnectionAvailable
{
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    /**
     *  SCNetworkReachabilityRef: 用来保存创建测试连接返回的引用
     *
     *  SCNetworkReachabilityCreateWithAddress: 根据传入的地址测试连接.
     *  第一个参数可以为NULL或kCFAllocatorDefault
     *  第二个参数为需要测试连接的IP地址,当为0.0.0.0时则可以查询本机的网络连接状态.
     *  同时返回一个引用必须在用完后释放.
     *  PS: SCNetworkReachabilityCreateWithName: 这个是根据传入的网址测试连接,
     *  第二个参数比如为"www.apple.com",其他和上一个一样.
     *
     *  SCNetworkReachabilityGetFlags: 这个函数用来获得测试连接的状态,
     *  第一个参数为之前建立的测试连接的引用,
     *  第二个参数用来保存获得的状态,
     *  如果能获得状态则返回TRUE，否则返回FALSE
     *
     */
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     *
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}





@end
