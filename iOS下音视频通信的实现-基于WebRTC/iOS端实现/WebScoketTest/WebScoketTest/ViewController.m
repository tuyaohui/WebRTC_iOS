//
//  ViewController.m
//  WebScoketTest
//
//  Created by 涂耀辉 on 16/12/28.
//  Copyright © 2016年 涂耀辉. All rights reserved.
//

#import "ViewController.h"
#import "VideoChatViewController.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIButton *connectBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_connectBtn addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
    
}


//连接
- (void)chatAction
{
    VideoChatViewController *chatVC = [[VideoChatViewController alloc]init];
    [self presentViewController:chatVC animated:YES completion:nil];
}




@end
