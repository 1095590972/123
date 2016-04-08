//
//  VideoDownLoadManager.h
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VideoModel;


@protocol VideoDownLoadManagerDelegate <NSObject>

-(void)videoDidUpdatedProgressWithVideoModel:(VideoModel *)model;

@end

@interface VideoDownLoadManager : NSObject

@property(nonatomic, weak)id<VideoDownLoadManagerDelegate>delegate;

+(instancetype)sharedInstance;

@property(nonatomic, strong)NSOperationQueue *downLoadQueue;

//  用来保存创建的下载管理类，方面以后的对应管理
@property(nonatomic, strong)NSMutableDictionary *httpOperationDict;

@property(nonatomic, strong)NSMutableArray *downVideoArray;
#pragma mark 开始下载
-(void)startAVideoWithVideoModel:(VideoModel *)downLoadVideo;

#pragma mark 暂停下载
-(void)downloadPausewithModel:(VideoModel *)pauseModel;

#pragma mark 断点继续下载
-(void)downloadResumeWithModel:(VideoModel *)resumeModel;
@end
