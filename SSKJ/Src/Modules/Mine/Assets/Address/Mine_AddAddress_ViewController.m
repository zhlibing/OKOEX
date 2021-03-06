//
//  Mine_AddAddress_ViewController.m
//  SSKJ
//
//  Created by 刘小雨 on 2020/4/15.
//  Copyright © 2020 刘小雨. All rights reserved.
//

#import "Mine_AddAddress_ViewController.h"
#import "Mine_QRScan_ViewController.h"
#import "Mine_TitleAndInput_View.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>//相册

@interface Mine_AddAddress_ViewController ()


@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) Mine_TitleAndInput_View *addressView;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) Mine_TitleAndInput_View *remarkView;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation Mine_AddAddress_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = SSKJLocalized(@"添加地址", nil);
    
    [self setUI];
}

#pragma mark - UI


-(void)setUI
{
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.addressView];
    [self.addressView addSubview:self.scanButton];
    [self.view addSubview:self.remarkView];
    [self.view addSubview:self.addButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.remarkView.mas_bottom).offset(ScaleW(100));
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(ScaleW(45)));
        
    }];
}





-(UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, 10)];
        [_lineView setBackgroundColor:kLineColor];
    }
    return _lineView;
}


-(Mine_TitleAndInput_View *)addressView
{
    if (nil == _addressView)
    {
        _addressView = [[Mine_TitleAndInput_View alloc]initWithFrame:CGRectMake(0,self.lineView.bottom, ScreenWidth, ScaleW(80)) title:SSKJLocalized(@"提币地址", nil) placeHolder:SSKJLocalized(@"请输入钱包地址", nil) keyBoardType:UIKeyboardTypeDefault isSecure:NO];
        _addressView.backgroundColor = kBgColor;
    }
    return _addressView;
}

-(UIButton *)scanButton
{
    if (!_scanButton) {
        _scanButton = [[UIButton alloc]initWithFrame:CGRectMake(self.addressView.width - ScaleW(15) - ScaleW(40), 0, ScaleW(40), ScaleW(40))];
        [_scanButton setImage:[UIImage imageNamed:@"扫描"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(scanEvent) forControlEvents:UIControlEventTouchUpInside];
        _scanButton.centerY = self.addressView.textField.centerY;
        _addressView.textField.width = _scanButton.x - ScaleW(10) - _addressView.textField.x;
    }
    return _scanButton;
}

-(Mine_TitleAndInput_View *)remarkView
{
    if (nil == _remarkView)
    {
        _remarkView = [[Mine_TitleAndInput_View alloc]initWithFrame:CGRectMake(0, self.addressView.bottom, ScreenWidth, ScaleW(80)) title:SSKJLocalized(@"备注", nil) placeHolder:SSKJLocalized(@"请填写备注信息", nil) keyBoardType:UIKeyboardTypeDefault isSecure:NO];
        _remarkView.backgroundColor = kBgColor;
    }
    return _remarkView;
}


- (UIButton *)addButton
{
    if (_addButton == nil)
    {
        _addButton = [WLTools allocButton:SSKJLanguage(@"确定") textColor:kWhiteColor nom_bg:nil hei_bg:nil frame:CGRectZero];
        _addButton.titleLabel.font = kFont(15);
        [_addButton addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
        _addButton.layer.masksToBounds = YES;
        _addButton.layer.cornerRadius = ScaleW(5);
        _addButton.backgroundColor = kBlueColor;
        [self.view addSubview:_addButton];
    }
    return _addButton;
}


#pragma mark - 用户操作

-(void)scanEvent
{
    [self videoAuthAction];

       
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
       //NSString *tips = @"您没有权限访问相机,请去设置中开启！";
       if(status == AVAuthorizationStatusAuthorized)
       {
           Mine_QRScan_ViewController *scan = [[Mine_QRScan_ViewController alloc]init];
           WS(weakSelf);
           scan.codeScaningString = ^(NSString *string) {
               weakSelf.addressView.textField.text = string;
           };
           [self.navigationController pushViewController:scan animated:YES];
       }
}


//授权相机
- (void)videoAuthAction
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        SSLog(@"%@",granted ? @"相机准许":@"相机不准许");
        [self checkVideoStatus];
    }];
}

//检查相机权限
- (void)checkVideoStatus
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启相机
            //self.videoStatus = @"AVAuthorizationStatusNotDetermined";
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            //self.videoStatus = @"AVAuthorizationStatusRestricted";
            break;
        case AVAuthorizationStatusDenied:
            //未授权
           // self.videoStatus = @"AVAuthorizationStatusDenied";
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
           // self.videoStatus = @"AVAuthorizationStatusAuthorized";
            break;
        default:
            break;
    }
    
}

-(void)addAddress
{
    if (self.addressView.valueString.length == 0) {
        [MBProgressHUD showError:SSKJLocalized(@"请输入钱包地址", nil)];
        return;
    }
    
    if (self.remarkView.valueString.length == 0) {
        [MBProgressHUD showError:SSKJLocalized(@"请填写备注信息", nil)];
        return;
    }
    
    [self requestAddaddress];
    
}


-(void)requestAddaddress
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSDictionary *params = @{
                            @"address":self.addressView.valueString,
                            @"notes":self.remarkView.valueString,
                            @"type":@"2"
                            };
    
    WS(weakSelf);
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_AddAddress_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (netModel.status.integerValue == SUCCESSED) {
            [MBProgressHUD showSuccess:netModel.msg];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:netModel.msg];
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
