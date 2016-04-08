//
//  VideoDownLoadManager.m
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "VideoDownLoadManager.h"
#import "VideoModel.h"
#import "VideoDownLoadOperation.h"

@interface VideoDownLoadOperation ()

@end

static VideoDownLoadManager *manager;
@implementation VideoDownLoadManager
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[VideoDownLoadManager alloc] init];
            manager.httpOperationDict = [NSMutableDictionary dictionary];
            manager.downVideoArray = [NSMutableArray array];

        }
    });

    return manager;
}
/*
#pragma mark 开始下载
-(void)startAVideoWithVideoModel:(VideoModel *)downLoadVideo
{

    // 创建请求管理 （AFHTTPRequestOperation继承自AFURLConnectionOperation使用 GCD 会去开辟线程）
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:downLoadVideo.flv]]];
    // 把请求添加到字典里面
    [self.httpOperationDict setObject:operation forKey:downLoadVideo.flv];
    NSLog(@"%@", CachesPath);
    // 添加下载请求（获取服务器的输出流）
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.mp4", CachesPath, downLoadVideo.title];
    // 输出流写入文件
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
    // 设置下载进度
//      bytesRead                      当前一次读取的字节数
//      totalBytesRead                 已经下载的字节数
//      totalBytesExpectedToRead       文件总大小(5M)
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        // 下载进度
        CGFloat progress = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        downLoadVideo.progressValue = progress;
        // 代理执行（更新下载列表的进度）
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoDidUpdatedProgressWithVideoModel:)]) {
            [self.delegate videoDidUpdatedProgressWithVideoModel:downLoadVideo];
        }
    }];
    //开始下载
    [operation start];
    [self.downVideoArray addObject:downLoadVideo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:k_newVideoDidStartDown object:nil];
}
*/
/*经过研究，AFN 的继续和暂停下载不是线程安全的，使用会经常出错*/
/*
#pragma mark 暂停下载
-(void)downloadPausewithModel:(VideoModel *)pauseModel
{
    AFHTTPRequestOperation *operation = [self.httpOperationDict objectForKey:pauseModel.flv];
    if (![operation isFinished]) {
        [operation pause];
    }
}

#pragma mark 断点继续下载
-(void)downloadResumeWithModel:(VideoModel *)resumeModel
{
    AFHTTPRequestOperation *operation = [self.httpOperationDict objectForKey:resumeModel.flv];
    if (![operation isFinished]) {
        [operation resume];
    }
}
 */
#pragma mark 开始下载
-(void)startAVideoWithVideoModel:(VideoModel *)downLoadVideo
{
    NSLog(@"........%@", CachesPath);
    if (!self.downLoadQueue) {
        self.downLoadQueue = [[NSOperationQueue alloc] init];
        self.downLoadQueue.maxConcurrentOperationCount = 3;
    }

    VideoDownLoadOperation *ope = [[VideoDownLoadOperation alloc] initWithDownLoadVideoModel:downLoadVideo];



    ope.updateBlock = ^(VideoModel *model){
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoDidUpdatedProgressWithVideoModel:)]) {
            [self.delegate videoDidUpdatedProgressWithVideoModel:model];
        }
    };

    [self.httpOperationDict setObject:ope forKey:downLoadVideo.flv];

    [self.downLoadQueue addOperation:ope];


    [self.downVideoArray addObject:downLoadVideo];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_newVideoDidStartDown object:nil];
}

#pragma mark 暂停下载
-(void)downloadPausewithModel:(VideoModel *)pauseModel
{

    
    VideoDownLoadOperation *ope = [self.httpOperationDict objectForKey:pauseModel.flv];
    if (!ope.isFinished) {
        [ope downLoadPause];
    }

}

#pragma mark 断点继续下载
-(void)downloadResumeWithModel:(VideoModel *)resumeModel
{
    VideoDownLoadOperation *ope = [self.httpOperationDict objectForKey:resumeModel.flv];
    if (!ope.isFinished) {
        [ope downLoadResume];
    }
}

@end
