//
//  My_GoogleVerify_ViewController.m
//  ZYW_MIT
//
//  Created by 刘小雨 on 2019/3/28.
//  Copyright © 2019年 Wang. All rights reserved.
//

#import "My_GoogleVerify_ViewController.h"
#import "My_BindGoogle_AlertView.h"

#import "My_Google_Model.h"

@interface My_GoogleVerify_ViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UIButton *copyButton;
@property (nonatomic, strong) UILabel *googleCodeTipLabel;
@property (nonatomic, strong) UITextField *googleTextField;
@property (nonatomic, strong) UILabel *phoneTipLabel;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIView *codeLineView;
@property (nonatomic, strong) UIButton *smsButton;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) My_BindGoogle_AlertView *alertView;

@property (nonatomic, strong) My_Google_Model *googleModel;


@end

@implementation My_GoogleVerify_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = SSKJLocalized(@"绑定谷歌验证器", nil);
    
    self.view.backgroundColor = kBgColor;
    
    [self requestGoogle];
}


-(void)addSubViews:(BOOL)views
{
    if (views)
    {
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.warningLabel];
        [self.scrollView addSubview:self.titleLabel];
        [self.scrollView addSubview:self.qrCodeImageView];
        [self.scrollView addSubview:self.codeLabel];
        [self.scrollView addSubview:self.copyButton];
        [self.scrollView addSubview:self.googleCodeTipLabel];
        [self.scrollView addSubview:self.googleTextField];
        [self.scrollView addSubview:self.phoneTipLabel];
        [self.scrollView addSubview:self.codeTextField];
        [self.scrollView addSubview:self.codeLineView];
        [self.scrollView addSubview:self.smsButton];
        [self.scrollView addSubview:self.nextButton];
        
        
        
        [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
           
           
            make.top.equalTo(self.scrollView.mas_top).offset(ScaleW(30)); make.left.equalTo(self.view.mas_left).offset(ScaleW(15));
            make.right.equalTo(self.view.mas_right).offset(-ScaleW(15));
            
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.warningLabel.mas_bottom).offset(ScaleW(50));
            make.centerX.equalTo(self.scrollView.mas_centerX);
            
        }];
        
        [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleW(30));
            make.width.height.equalTo(@(ScaleW(120)));
            make.centerX.equalTo(self.titleLabel.mas_centerX);
            
        }];
        
        [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.qrCodeImageView.mas_bottom).offset(ScaleW(40));
            make.centerX.equalTo(self.qrCodeImageView.mas_centerX);
            
        }];
        
        [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.codeLabel.mas_right).offset(ScaleW(5));
            make.centerY.equalTo(self.codeLabel.mas_centerY);
            
        }];
        
        [self.googleCodeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.codeLabel.mas_bottom).offset(ScaleW(40));
            make.left.equalTo(self.scrollView.mas_left).offset(ScaleW(15));
            
        }];
        
        [self.googleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.googleCodeTipLabel.mas_bottom).offset(ScaleW(10));
           
            make.left.right.equalTo(self.warningLabel);
            make.height.equalTo(@(ScaleW(45)));
            
        }];
        
        [self.phoneTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.googleTextField.mas_bottom).offset(ScaleW(20));
            make.left.equalTo(self.googleCodeTipLabel.mas_left);
            
        }];
        
        [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.phoneTipLabel.mas_bottom).offset(ScaleW(10));
            make.left.right.height.equalTo(self.googleTextField);
            
            
        }];
        
        [self.codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.codeTextField.mas_bottom).offset(ScaleW(5));
            make.left.right.equalTo(self.codeTextField);
            make.height.equalTo(@(ScaleW(0.5)));
        }];
        
        
        [self.smsButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(self.codeTextField.mas_right);
            make.centerY.equalTo(self.codeTextField.mas_centerY);
            
        }];
        
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.codeLineView.mas_bottom).offset(ScaleW(60));
            make.left.right.equalTo(self.googleTextField);
            make.height.equalTo(@(ScaleW(45)));
            make.bottom.equalTo(self.scrollView.mas_bottom).offset(-ScaleW(50));
            
        }];
        
        
        
         if ([RegularExpression validateMobile:kAccount])
           {
//               [self.phoneTipLabel setText:[NSString stringWithFormat:@"%@ :%@",SSKJLanguage(@"手机号"),[RegularExpression mobilebyReplacingInRange:kAccount]]];
           }
           else
           {
//               [self.phoneTipLabel setText:[NSString stringWithFormat:@"%@ :%@",SSKJLanguage(@"邮箱"),kAccount]];
           }
    }
}





-(UIScrollView *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScaleW(10), ScreenWidth, ScreenHeight - Height_NavBar  - ScaleW(10))];
        _scrollView.backgroundColor = kBgColor;
    }
    return _scrollView;
}

-(UILabel *)warningLabel
{
    if (nil == _warningLabel)
    {
        NSString *string = SSKJLocalized(@"打开谷歌验证器，扫描下方二维码或手动输入下述秘钥添加验证令牌。秘钥用户邮寄更换或遗失时找回谷歌验证器，绑定前请务必将下述秘钥备份保存。", nil);
        _warningLabel = [WLTools allocLabel:string font:systemFont(ScaleW(12)) textColor:UIColorFromRGB(0xFF5E66) frame:CGRectZero textAlignment:NSTextAlignmentLeft];
        _warningLabel.numberOfLines = 0;
    }
    return _warningLabel;
}


-(UILabel *)titleLabel
{
    if (nil == _titleLabel)
    {
        _titleLabel = [WLTools allocLabel:SSKJLocalized(@"请妥善备份秘钥以防遗失",nil) font:systemFont(ScaleW(15)) textColor:kSubTitleColor frame:CGRectZero textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

-(UIImageView *)qrCodeImageView
{
    if (nil == _qrCodeImageView)
    {
        _qrCodeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _qrCodeImageView.backgroundColor = [UIColor whiteColor];
    }
    return _qrCodeImageView;
}

-(UILabel *)codeLabel
{
    if (nil == _codeLabel)
    {
        _codeLabel = [WLTools allocLabel:@"HDFLJDADF" font:systemFont(ScaleW(15)) textColor:kSubTitleColor frame:CGRectZero textAlignment:NSTextAlignmentCenter];
    }
    return _codeLabel;
}

-(UIButton *)copyButton
{
    if (nil == _copyButton)
    {
        _copyButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_copyButton setTitle:SSKJLocalized(@"复制",nil) forState:UIControlStateNormal];
        [_copyButton setTitleColor:kBlueColor forState:UIControlStateNormal];
        _copyButton.titleLabel.font = systemFont(ScaleW(16));
        [_copyButton addTarget:self action:@selector(copyButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyButton;
}


- (UILabel *)googleCodeTipLabel
{
    if (nil == _googleCodeTipLabel)
    {
        _googleCodeTipLabel = [[UILabel alloc]init];
        [_googleCodeTipLabel setFont:systemFont(ScaleW(14))];
        [_googleCodeTipLabel setText:SSKJLanguage(@"谷歌验证码")];
        [_googleCodeTipLabel setTextColor:kTitleColor];
    }
    return _googleCodeTipLabel;
}

-(UITextField *)googleTextField
{
    if (!_googleTextField)
    {
        _googleTextField = [[UITextField alloc]init];
        [_googleTextField setTextColor:kSubTitleColor];
        [_googleTextField setPlaceholder:SSKJLanguage(@"请输入6位验证码")];
        [_googleTextField setBorderWithWidth:ScaleW(0.5) andColor:kSubTitleColor];
    }
    return _googleTextField;
}


-(UILabel *)phoneTipLabel
{
    if (!_phoneTipLabel)
    {
        _phoneTipLabel = [[UILabel alloc]init];
        [_phoneTipLabel setFont:systemFont(ScaleW(14))];
        [_phoneTipLabel setTextColor:kSubTitleColor];
    }
    return _phoneTipLabel;
}


-(UITextField *)codeTextField
{
    if (!_codeTextField)
    {
        _codeTextField = [[UITextField alloc]init];
        [_codeTextField setTextColor:kSubTitleColor];
        [_codeTextField setPlaceholder:SSKJLanguage(@"请输入验证码")];
    }
    return _codeTextField;
}


-(UIView *)codeLineView
{
    if (!_codeLineView)
    {
        _codeLineView = [[UIView alloc]init];
        [_codeLineView setBackgroundColor:kSubBgColor];
    }
    return _codeLineView;
}

-(UIButton *)smsButton
{
    if (nil == _smsButton)
    {
        _smsButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_smsButton setTitle:SSKJLocalized(@"发送验证码",nil) forState:UIControlStateNormal];
        [_smsButton setTitleColor:kBlueColor forState:UIControlStateNormal];
        _smsButton.titleLabel.font = systemFont(ScaleW(14));
        [_smsButton addTarget:self action:@selector(smsButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsButton;
}




-(UIButton *)nextButton
{
    if (nil == _nextButton)
    {
        _nextButton = [[UIButton alloc]initWithFrame:CGRectZero];
        _nextButton.layer.cornerRadius = ScaleW(3);
        _nextButton.backgroundColor = kTitleColor;
        [_nextButton setTitle:SSKJLocalized(@"立即开启",nil) forState:UIControlStateNormal];
        [_nextButton setTitleColor:kSubTitleColor forState:UIControlStateNormal];
        _nextButton.titleLabel.font = systemFont(ScaleW(16));
        [_nextButton addTarget:self action:@selector(nextEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

-(My_BindGoogle_AlertView *)alertView
{
    if (nil == _alertView)
    {
        _alertView = [[My_BindGoogle_AlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        WS(weakSelf);
        _alertView.submitBlock = ^(NSString * _Nonnull googleCode, NSString * _Nonnull smsCode,NSString *type)
        {
            [weakSelf requestGoogleCommandWithCode:smsCode withGoogleCode:googleCode];
        };
    }
    return _alertView;
}

#pragma mark - Private Method
#pragma mark 获取验证码逻辑处理
-(void)smsButtonEvent
{
    if ([RegularExpression validateMobile:kAccount])
    {
        [self requestSMSCode];
    }
    else
    {
        [self requestEmailCode];
    }
}


#pragma mark 短信验证码
- (void)requestSMSCode
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"phone":kAccount,@"area_code":[SSKJ_User_Tool sharedUserTool].userInfoModel.area_code};
    
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:BI_GetSmsCode_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        
        [hud hideAnimated:YES];
        
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (netModel.status.integerValue == 200)
        {
            [MBProgressHUD showError:netModel.msg];
            WS(weakSelf);
            [weakSelf changeCheckcodeButtonState];
        }
        else
        {
            [MBProgressHUD showError:netModel.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark 邮箱验证码
- (void)requestEmailCode
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"email":kAccount};
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:BI_GetEmailCode_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        
        [hud hideAnimated:YES];
        
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (netModel.status.integerValue == 200)
        {
            [self changeCheckcodeButtonState];
        }
        else
        {
            [MBProgressHUD showError:netModel.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [hud hideAnimated:YES];
    }];
}



#pragma mark 倒计时
- (void)changeCheckcodeButtonState
{
    [WLTools countDownWithButton:self.smsButton];
}


#pragma mark 绑定谷歌验证器
-(void)nextEvent
{

    [self requestGoogleCommandWithCode:self.codeTextField.text withGoogleCode:self.googleTextField.text];
    
//    if (self.googleModel == nil)
//    {
//        [MBProgressHUD showError:SSKJLocalized(@"数据异常", nil)];
//        return;
//    }
//    [self.alertView setShowWithType:GOOGLETYPEADD];
}

// 复制
-(void)dumplcationEvent
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.googleModel.secret;
    [MBProgressHUD showSuccess:SSKJLocalized(@"复制成功",nil)];
}


#pragma mark - 网络请求
#pragma mark 请求谷歌二维码图片和私钥
-(void)requestGoogle
{
    WS(weakSelf);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:CreateGoogleCommand RequestType:RequestTypePost Parameters:nil Success:^(NSInteger statusCode, id responseObject)
    {
        [hud hideAnimated:YES];
        
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (netModel.status.integerValue == 200)
        {
            My_Google_Model *googleModel = [My_Google_Model mj_objectWithKeyValues:[netModel.data objectForKey:@"createSecret"]];
            [weakSelf setViewWithGoogleModel:googleModel];
        }
        else
        {
            [MBProgressHUD showError:netModel.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [hud hideAnimated:YES];
    }];
    
}


#pragma mark 绑定谷歌验证器
-(void)requestGoogleCommandWithCode:(NSString *)code withGoogleCode:(NSString *)googleCode
{
    if (googleCode.length == 0)
    {
        [MBProgressHUD showError:SSKJLocalized(@"请输入谷歌验证码", nil)];
        return;
    }
    else if (code.length == 0)
    {
       [MBProgressHUD showError:SSKJLocalized(@"请输入验证码", nil)];
       return;
        
    }
    
    NSDictionary *params = @{@"google_code":googleCode,
                             @"code":code,
                             @"google_secret":self.googleModel.secret
                             };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WS(weakSelf);
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:CheckGoogleCommand RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject)
    {
        [hud hideAnimated:YES];
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (netModel.status.integerValue == 200)
        {
            if (weakSelf.addGoogleBlock)
            {
                weakSelf.addGoogleBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:netModel.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject)
    {
        [hud hideAnimated:YES];
    }];
    
}

-(void)setViewWithGoogleModel:(My_Google_Model *)googleModel
{
    self.googleModel = googleModel;
    
    [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:googleModel.codeurl ]];
    self.codeLabel.text = googleModel.secret;
}



@end
