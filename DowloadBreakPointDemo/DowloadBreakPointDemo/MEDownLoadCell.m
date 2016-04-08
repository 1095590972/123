//
//  MEDownLoadCell.m
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/9.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "MEDownLoadCell.h"
#import "VideoModel.h"
@implementation MEDownLoadCell

- (void)awakeFromNib {
    self.headerImageView.layer.cornerRadius = 10;
    self.headerImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellDataWithModel:(VideoModel *)model
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.big] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", model.progressValue * 100];
    self.progressView.progress = model.progressValue;
    if (model.isDownFinished) {
        self.palseAndPlayButton.userInteractionEnabled = NO;
    }else{
        self.palseAndPlayButton.userInteractionEnabled = YES;
    }
}

#pragma mark 更新下载进度
-(void)updateDownLoadProgress:(VideoModel *)model
{
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", model.progressValue * 100];
    self.progressView.progress = model.progressValue;
}
#pragma mark 播放或者暂停按钮被点击
- (IBAction)palseAndPlayButtonDidClicked:(id)sender {

    if (self.palseAndPlayButton.isSelected) {
        [self.palseAndPlayButton setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
    }else{
        [self.palseAndPlayButton setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
    }
    self.palseAndPlayButton.selected = ! self.palseAndPlayButton.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(MEDownLoadCellpalseAndPlayButtonDidClicked:withIsPlay:)]) {
        [self.delegate MEDownLoadCellpalseAndPlayButtonDidClicked:self withIsPlay:self.palseAndPlayButton.selected];
    }

}

@end
