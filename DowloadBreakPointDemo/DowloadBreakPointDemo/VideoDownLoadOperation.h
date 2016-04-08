//
//  VideoDownLoadOperation.h
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/9.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VideoModel;
typedef void(^VIDEODidUpateBlcok)(VideoModel *);

@interface VideoDownLoadOperation : NSOperation
-(instancetype)initWithDownLoadVideoModel:(VideoModel *)videoModel;

@property(nonatomic, copy)VIDEODidUpateBlcok updateBlock;
// 暂停
-(void)downLoadPause;
// 恢复
-(void)downLoadResume;
@end
