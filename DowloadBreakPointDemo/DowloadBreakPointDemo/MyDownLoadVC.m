//
//  MyDownLoadVC.m
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "MyDownLoadVC.h"
#import "MEDownLoadCell.h"
#import "VideoDownLoadManager.h"
@interface MyDownLoadVC ()<UITableViewDataSource, UITableViewDelegate, VideoDownLoadManagerDelegate, MEDownLoadCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mianTableView;

@end

@implementation MyDownLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [VideoDownLoadManager sharedInstance].delegate = self;
    self.mianTableView.delegate = self;
    self.mianTableView.dataSource = self;
    // 注册新的下载通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMovieDidStatrtDownAction:) name:k_newVideoDidStartDown object:nil];
    //注册下载完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinishedSuccess:) name:k_videoDidDownedFinishedSuccess object:nil];
}

#pragma mark dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [VideoDownLoadManager sharedInstance].downVideoArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MEDownLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MEDownLoadCell"];
    VideoModel *model = [VideoDownLoadManager sharedInstance].downVideoArray[indexPath.row];
    [cell setCellDataWithModel:model];
    cell.delegate = self;
    return cell;

}

#pragma mark cell 的点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}

#pragma mark VideoDownLoadManagerDelegate
-(void)videoDidUpdatedProgressWithVideoModel:(VideoModel *)model
{
    NSMutableArray *mutableArray =[VideoDownLoadManager sharedInstance].downVideoArray;
    if ([mutableArray containsObject:model]) {
        NSInteger index = [mutableArray indexOfObject:model];
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
        MEDownLoadCell *cell = (MEDownLoadCell *)[self.mianTableView cellForRowAtIndexPath:indexpath];
        // 判断当前 cell 是否正在显示
        if ([[self.mianTableView visibleCells] containsObject:cell]) {
            [cell updateDownLoadProgress:model];
        }

    }
}
#pragma mark 新的电影开始下载通知
-(void)newMovieDidStatrtDownAction:(NSNotification *)sender
{
    [self.mianTableView reloadData];
}
#pragma mark 电影下载完成
-(void)videoDidFinishedSuccess:(NSNotification *)sender
{
    VideoModel *videoModel = sender.object;
    NSInteger index = [[VideoDownLoadManager sharedInstance].downVideoArray indexOfObject:videoModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    MEDownLoadCell *cell = (MEDownLoadCell *)[self.mianTableView cellForRowAtIndexPath:indexPath];
    // 设置 cell 上的下载按钮为完成状态
    cell.palseAndPlayButton.selected = NO;
    [cell.palseAndPlayButton setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
    cell.palseAndPlayButton.userInteractionEnabled = NO;



}
#pragma amrk MEDownLoadCellDelegate
-(void)MEDownLoadCellpalseAndPlayButtonDidClicked:(MEDownLoadCell *)cell withIsPlay:(BOOL)isPlay
{
    NSIndexPath *indexpath = [self.mianTableView indexPathForCell:cell];
    VideoModel *model = [VideoDownLoadManager sharedInstance].downVideoArray[indexpath.row];
    if (isPlay) {
        [[VideoDownLoadManager sharedInstance] downloadPausewithModel:model];
    }else{
        [[VideoDownLoadManager sharedInstance] downloadResumeWithModel:model];
    }

}
@end
