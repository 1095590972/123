//
//  ViewController.m
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "ViewController.h"
#import "VideoModel.h"
#import "VideoTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoDownLoadManager.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    AFHTTPRequestOperation *_videoListOperation;
    MPMoviePlayerViewController *_moviePlayVC;
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
// 存取 tableView 里面展示视频列表的页面
@property(nonatomic, strong)NSMutableArray *dataSourceArray;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = [NSMutableArray array];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self getVideoListDataFromNetWork];

}

#pragma mark netWork 视频列表网路请求
-(void)getVideoListDataFromNetWork
{

//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

//    _videoListOperation = [mgr GET:K_videoBaseURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSArray *array = [responseObject objectForKey:@"video"];
//        for (NSDictionary *dict in array) {
//            VideoModel *model = [[VideoModel alloc] init];
//            [model setValuesForKeysWithDictionary:dict];
//            [self.dataSourceArray addObject:model];
//        }
//        [self.mainTableView reloadData];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        ITAlertView(error.localizedDescription);
//    }];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:K_videoBaseURL];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        
        NSArray *array = [dic objectForKey:@"video"];
        for (NSDictionary *dict in array) {
            VideoModel *model = [[VideoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataSourceArray addObject:model];
        }
        [self.mainTableView reloadData];
    }];
    [task resume];

}
-(void)cancleVideoListDataFrkAlertTitleomNetWork
{
    [_videoListOperation cancel];
    _videoListOperation = nil;
}
#pragma mark dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell"];
    [cell setCellDataWithModel:self.dataSourceArray[indexPath.row]];
    return cell;

}

#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoModel *model = self.dataSourceArray[indexPath.row];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *playMovieAction = [UIAlertAction actionWithTitle:@"播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self playMoviewWithURLString:model.flv];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];


    UIAlertAction *downMovieAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // 单例实现下载
        [[VideoDownLoadManager sharedInstance] startAVideoWithVideoModel:self.dataSourceArray[indexPath.row]];
    }];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissMoviePlayerViewControllerAnimated];
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        // 取消 cell 的选择状态
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }];
    [alertVC addAction:playMovieAction];
    [alertVC addAction:downMovieAction];
    [alertVC addAction:cancleAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark 播放视频
-(void)playMoviewWithURLString:(NSString *)urlString
{
    @autoreleasepool {
        // 创建MPMoviePlayerViewController同时给定一个utl
        _moviePlayVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlString]];
        // 准备播放
        [_moviePlayVC.moviePlayer prepareToPlay];
        // 把视频播放器的播放页面添加到本视图
        [self.view addSubview:_moviePlayVC.view];
        // 设置播放器可以全屏
        [_moviePlayVC.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        // 设置播放器页面的大小
        _moviePlayVC.view.frame = self.view.frame;
        // 设置播放器页面背景透明
        _moviePlayVC.view.backgroundColor = [UIColor clearColor];
        // 设置自动播放
        _moviePlayVC.moviePlayer.shouldAutoplay = YES;
        // 模态推出播放视频的控制器
        [self presentMoviePlayerViewControllerAnimated:_moviePlayVC];


        MPMoviePlayerController *m;
    }


    // 添加通知，检测播放状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayVC.moviePlayer];

}

#pragma mark 视频播放完毕
-(void)movieDidFinish:(NSNotification *)sender
{
    MPMoviePlayerController *movieVC = [sender object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:movieVC];
    [self dismissMoviePlayerViewControllerAnimated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}

@end
