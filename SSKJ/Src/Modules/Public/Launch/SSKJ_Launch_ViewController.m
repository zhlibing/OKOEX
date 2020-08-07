//
//  WL_Launch_ViewController.m
//  ZYW_MIT
//
//  Created by James on 2018/8/9.
//  Copyright © 2018年 Wang. All rights reserved.
//

#import "SSKJ_Launch_ViewController.h"

#import "AppDelegate.h"
#import "YYWebImage.h"



@interface SSKJ_Launch_ViewController ()
@property (nonatomic, strong) YYAnimatedImageView *backImageView;


@end

@implementation SSKJ_Launch_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSString *gifName = @"750X1334";
    if (kiPhone6Plus) {
        gifName = @"1242X2208";
    }else if (IS_IPHONE_X_ALL){
        gifName = @"1242X2688";
    }
    
    NSURL *imgUrl = [[NSBundle mainBundle] URLForResource:gifName withExtension:@"gif"];
    [self.view addSubview:self.backImageView];
    self.backImageView.yy_imageURL = imgUrl;
        
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [appDelegate performSelector:@selector(gotoMain) withObject:nil afterDelay:2.5];
}





-(YYAnimatedImageView *)backImageView
{
    if (nil == _backImageView) {
        _backImageView = [[YYAnimatedImageView alloc]initWithFrame:self.view.bounds];
    }
    return _backImageView;
}


@end
