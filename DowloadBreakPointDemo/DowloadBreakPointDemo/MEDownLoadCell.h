//
//  MEDownLoadCell.h
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/9.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
@class MEDownLoadCell;
@protocol MEDownLoadCellDelegate <NSObject>

-(void)MEDownLoadCellpalseAndPlayButtonDidClicked:(MEDownLoadCell *)cell withIsPlay:(BOOL)isPlay;

@end

@interface MEDownLoadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) IBOutlet UIButton *palseAndPlayButton;

@property (strong, nonatomic) IBOutlet UILabel *progressLabel;

@property(nonatomic, weak)id<MEDownLoadCellDelegate>delegate;
#pragma mark 给 cell 赋值
-(void)setCellDataWithModel:(VideoModel *)model;

#pragma mark 更新下载进度
-(void)updateDownLoadProgress:(VideoModel *)model;
@end
