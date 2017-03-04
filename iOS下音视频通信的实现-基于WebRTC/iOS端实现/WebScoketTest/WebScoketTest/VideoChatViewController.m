//
//  VideoChatViewController.m
//  WebScoketTest
//
//  Created by 涂耀辉 on 17/3/3.
//  Copyright © 2017年 涂耀辉. All rights reserved.
//

#import "VideoChatViewController.h"
#import "WebRTCHelper.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define KVedioWidth KScreenWidth/3.0
#define KVedioHeight KVedioWidth*320/240

@interface VideoChatViewController ()<WebRTCHelperDelegate>
{
    //本地摄像头追踪
    RTCVideoTrack *_localVideoTrack;
    //远程的视频追踪
    NSMutableDictionary *_remoteVideoTracks;
    
}


@end

@implementation VideoChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _remoteVideoTracks = [NSMutableDictionary dictionary];
    
    [WebRTCHelper sharedInstance].delegate = self;
    [self connectAction];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(KScreenWidth - 130, KScreenHeight - 70, 100, 40);
    btn.backgroundColor = [UIColor blackColor];
    btn.tag = 123;
    [btn setTitle:@"关闭" forState:0];
    [btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[WebRTCHelper sharedInstance] exitRoom];
    }];
}

//连接
- (void)connectAction
{
    [[WebRTCHelper sharedInstance]connectServer:@"192.168.0.7" port:@"3000" room:@"100"];
    
 
}
//断开连接
- (void)disConnectAction
{
    [[WebRTCHelper sharedInstance] exitRoom];
    
}


- (void)webRTCHelper:(WebRTCHelper *)webRTChelper setLocalStream:(RTCMediaStream *)stream userId:(NSString *)userId
{
    RTCEAGLVideoView *localVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, KVedioWidth, KVedioHeight)];
    //标记本地的摄像头
    localVideoView.tag = 100;
    _localVideoTrack = [stream.videoTracks lastObject];
    [_localVideoTrack addRenderer:localVideoView];
    
    [self.view addSubview:localVideoView];
    
    NSLog(@"setLocalStream");
}
- (void)webRTCHelper:(WebRTCHelper *)webRTChelper addRemoteStream:(RTCMediaStream *)stream userId:(NSString *)userId
{
    //缓存起来
    [_remoteVideoTracks setObject:[stream.videoTracks lastObject] forKey:userId];
    [self _refreshRemoteView];
    NSLog(@"addRemoteStream");
    
}
- (void)webRTCHelper:(WebRTCHelper *)webRTChelper closeWithUserId:(NSString *)userId
{
    //移除对方视频追踪
    [_remoteVideoTracks removeObjectForKey:userId];
    [self _refreshRemoteView];
    NSLog(@"closeWithUserId");
}

- (void)_refreshRemoteView
{
    for (RTCEAGLVideoView *videoView in self.view.subviews) {
        //本地的视频View和关闭按钮不做处理
        if (videoView.tag == 100 ||videoView.tag == 123) {
            continue;
        }
        //其他的移除
        [videoView removeFromSuperview];
    }
    __block int column = 1;
    __block int row = 0;
    //再去添加
    [_remoteVideoTracks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, RTCVideoTrack *remoteTrack, BOOL * _Nonnull stop) {
        
        RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(column * KVedioWidth, 0, KVedioWidth, KVedioHeight)];
        [remoteTrack addRenderer:remoteVideoView];
        [self.view addSubview:remoteVideoView];
        
        //列加1
        column++;
        //一行多余3个在起一行
        if (column > 3) {
            row++;
            column = 0;
        }
    }];
}






@end
