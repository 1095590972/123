//
//  VideoTableViewCell.h
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
@interface VideoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@property (strong, nonatomic) IBOutlet UILabel *authorLable;

@property (strong, nonatomic) IBOutlet UILabel *messageLable;

-(void)setCellDataWithModel:(VideoModel *)model;
@end
