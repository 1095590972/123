//
//  VideoTableViewCell.m
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "VideoModel.h"
@implementation VideoTableViewCell

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
    self.titleLable.text = model.title;
    self.authorLable.text = [NSString stringWithFormat:@"上传者：       %@",model.nickname];
    self.messageLable.text = model.adwords;
}
@end
