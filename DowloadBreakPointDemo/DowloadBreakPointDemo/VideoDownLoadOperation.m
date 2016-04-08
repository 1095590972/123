//
//  VideoDownLoadOperation.m
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/9.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "VideoDownLoadOperation.h"
#import "VideoModel.h"
@interface VideoDownLoadOperation ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>
{
    BOOL _isDownLoading;// 用于判断一个任务是否正在下载
}
@property(nonatomic, strong)VideoModel *downLoadVideoModel;
@property(nonatomic, strong)NSURLSession *currentSession;// 定义 session
@property(nonatomic, strong)NSData *partialData;// 用于可恢复的下载任务的数据
@property(nonatomic, strong)NSURLSessionDownloadTask *task;// 可恢复的下载任务
@end

@implementation VideoDownLoadOperation
-(instancetype)initWithDownLoadVideoModel:(VideoModel *)videoModel
{
    self = [super init];
    if (self) {
        self.downLoadVideoModel = videoModel;
    }
    return self;
}

-(void)main
{
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.currentSession = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:nil];
    self.currentSession.sessionDescription = self.downLoadVideoModel.flv;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downLoadVideoModel.flv]];
    self.task = [self.currentSession downloadTaskWithRequest:request];
    [self.task resume]; // 任务开始
    _isDownLoading = YES;
    while (_isDownLoading) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    }
    self.partialData = nil;
}
// 暂停
-(void)downLoadPause
{
    NSLog(@"暂停");
    [self.task suspend];
//    self.task = nil;
//    [self.task cancelByProducingResumeData:^(NSData *resumeData) {
//        self.partialData = resumeData;
////        [self.task suspend];
//////        self.task = nil;
//    }];

}
// 恢复
-(void)downLoadResume
{
    NSLog(@"恢复下载");
//    [self.task resume];
//    return;
//    self.task = [self.currentSession downloadTaskWithResumeData:self.partialData];
    [self.task resume];
//    return;


//    if (!self.partialData) {
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downLoadVideoModel.flv]];
//        self.task = [self.currentSession downloadTaskWithRequest:request];
//        [self.task resume];
//    }else{
//        self.task = [self.currentSession downloadTaskWithResumeData:self.partialData];
////        self.task = [self.currentSession downloadTaskWithResumeData:self.partialData completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
////
////
////        }];
//        NSLog(@"..................%lld", self.task.countOfBytesReceived);
//        [self.task resume];
//    }

}

#pragma mark delegate(task)
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{

    NSLog(@"path = %@", location.path);
    // 将临时文件剪切或者复制到 caches 文件夹
    NSFileManager *manager = [NSFileManager defaultManager];

    NSString *appendPath = [NSString stringWithFormat:@"/%@.mp4",self.downLoadVideoModel.title];
    NSString *file = [CachesPath stringByAppendingString:appendPath];

    [manager moveItemAtPath:location.path toPath:file error:nil];
    
    _isDownLoading = NO;

    // 下载完成发送通知
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:k_videoDidDownedFinishedSuccess object:self.downLoadVideoModel];
        self.downLoadVideoModel.isDownFinished = YES;
    });

}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"-----%f", bytesWritten  * 1.0 / totalBytesExpectedToWrite);
    self.downLoadVideoModel.progressValue = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.updateBlock) {
            self.updateBlock(self.downLoadVideoModel);
        }
    });
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%.0f", fileOffset /(CGFloat) expectedTotalBytes);
}


@end
