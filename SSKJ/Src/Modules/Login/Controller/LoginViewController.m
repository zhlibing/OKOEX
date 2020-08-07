//
//  LoginViewController.m
//  SSKJ
//
//  Created by zpz on 2019/8/21.
//  Copyright © 2019 刘小雨. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextFieldView.h"
#import "RegisterViewController.h"
#import "Login_Google_AlertView.h"
#import "AESCrypt.h"

#import "AppDelegate.h"
#import "Login_Type_Option.h"
#import "SSKJ_TabbarController.h"

#import "Lion_Forget_ViewController.h"

@interface LoginViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)LoginTextFieldView *accountView;

@property(nonatomic, strong)LoginTextFieldView *pwdView;

@property(nonatomic, strong)UIButton *forgetBtn;

@property(nonatomic, strong)UIButton *commitBtn;

@property (nonatomic, strong) SSKJ_Login_Model *loginModel;

@property (nonatomic, strong) Login_Google_AlertView *googleAlertView;

@property(nonatomic, strong)SSKJ_AreaCode_View *areaView;


@property(nonatomic, strong)Login_Type_Option *segmentControl;

@end

@implementation LoginViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTopView];
    
    [self setupUI];
    
    

//    [kNotifyCenter addObserver:self selector:@selector(textValueChanged) name:UITextFieldTextDidChangeNotification object:_accountTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:UITextFieldTextDidBeginEditingNotification object:self.accountView.field];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:UITextFieldTextDidBeginEditingNotification object:self.pwdView.field];
}

-(void)leftBtnAction:(id)sender
{
    [self goHome];
}

- (void)textValueChanged:(NSNotification *)fd {
    if (fd.object == self.accountView.field) {
        self.accountView.lineView.backgroundColor = kBlueColor;
        self.pwdView.lineView.backgroundColor = kLineColor;
    } else {
        self.accountView.lineView.backgroundColor = kLineColor;
        self.pwdView.lineView.backgroundColor = kBlueColor;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self addLeftNavItemWithImage:[UIImage imageNamed:@"root_back_w"]];

}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
////    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.navigationController.navigationBar.hidden = NO;

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

- (void)backBtnAction{
    
    if (self.isLoginOut) {
        
        [self goHome];
        
    }else{

        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)goHome
{    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[SSKJ_TabbarController class]] && self.isLoginOut)
    {
        SSKJ_TabbarController *tabbVc = (SSKJ_TabbarController *)vc;
        tabbVc.selectedIndex = 0;
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark - 注册
- (void)topButtonClick{
//    RegisterViewController *vc = [RegisterViewController new];
    RegisterViewController *vc = [RegisterViewController new];
    WS(weakSelf);
    vc.registerSuccessBlock = ^(NSString * _Nonnull account) {
        weakSelf.accountView.field.text = account;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 忘记密码
- (void)forgetBtnAction{
    Lion_Forget_ViewController *vc = [Lion_Forget_ViewController new];

    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 提交登录
- (void)commitBtnAction{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    
    if (!self.accountView.field.text.length) {
        [MBProgressHUD showError:self.accountView.field.placeholder];
        return;
    }
    
    if (![WLTools validateEmail:self.accountView.field.text] && ![RegularExpression validateMobile:self.accountView.field.text]) {
        [MBProgressHUD showError:SSKJLanguage(@"手机号或邮箱格式错误")];
        return;
    }
    
    if (self.pwdView.field.text.length == 0) {
        [MBProgressHUD showError:SSKJLocalized(@"请输入8-20位字母与数字组合", nil)];
        return;
    }
    
    if (![RegularExpression validatePassword:self.pwdView.field.text]) {
        [MBProgressHUD showError:SSKJLocalized(@"密码格式错误", nil)];
        return;
    }
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"username"] = self.accountView.field.text;
        
        params[@"password"] = self.pwdView.field.text;
        
//        params[@"areaCode"] = self.areaView.getCode;
//        params[@"areaCode"] = self.areaCode;
        WS(weakSelf);
        
        
        [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_Login_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
            
            [hud hideAnimated:YES];
            
            WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
            
            if (netModel.status.integerValue == SUCCESSED)                    {
                //                    weakSelf.login_dic = json;
                [weakSelf.view endEditing:YES];
                SSKJ_Login_Model *loginModel = [SSKJ_Login_Model mj_objectWithKeyValues:netModel.data];
                
                weakSelf.loginModel = loginModel;
                [weakSelf handleLoginData:loginModel];
                
            }
            else
            {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
        } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
            [hud hideAnimated:YES];
            
            [MBProgressHUD showError:SSKJLocalized(@"服务器请求异常", nil)];
            
        }];
        
        
    

}

-(void)handleLoginData:(SSKJ_Login_Model *)loginModel
{
    
    // 登录的账号（手机或邮箱）
    [kUserDefaults setObject:self.accountView.field.text forKey:@"kAccount"];
    [kUserDefaults setObject:@(1) forKey:@"kLogin"];
    
    [[SSKJ_User_Tool sharedUserTool]saveLoginInfoWithLoginModel:loginModel];
    
    [self goHome];
}


#pragma mark - 图形验证后的最终登录
// 通知后台安全验证成功
-(void)requestVerifySuccessed
{
    
    [[SSKJ_User_Tool sharedUserTool]saveLoginInfoWithLoginModel:self.loginModel];
    
    NSDictionary *params = @{
                             @"account":self.accountView.field.text,
                             @"id":self.loginModel.uid,
                             };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WS(weakSelf);
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_LoginSuccess_URL RequestType:RequestTypeGet Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *net_model = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (net_model.status.integerValue == SUCCESSED) {
            //登录以后全部返回到首页
            
//            if (self.navigationController.viewControllers.firstObject == self) {
//                [self dismissViewControllerAnimated:NO completion:nil];
//            }else{
//                [self.navigationController popToRootViewControllerAnimated:NO];
//            }
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            UITabBarController *tabbarController = (UITabBarController *)window.rootViewController;
//            [tabbarController setSelectedIndex:0];
            [kUserDefaults setObject:@(1) forKey:@"kLogin"];
            [self goHome];
            
        } else {
            [MBProgressHUD showError:net_model.msg];
        }
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:SSKJLocalized(@"服务器请求异常", nil)];
        
    }];
    
    
}


#pragma mark - 谷歌验证

-(void)requestGoogleWith:(NSString *)code
{
    
    NSDictionary *prams = @{
                            @"code":code,
                            @"stockUserId":self.loginModel.uid
                            };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WS(weakSelf);
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_GoginGoogleAuthVerify_URL RequestType:RequestTypePost Parameters:prams Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *net_model = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (net_model.status.integerValue == SUCCESSED) {
            // 保存登录数据
            [weakSelf.googleAlertView hide];
            [weakSelf requestVerifySuccessed];
            
        }
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        [MBProgressHUD showError:net_model.msg];
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:SSKJLocalized(@"服务器请求异常", nil)];
        
    }];
}


//- (void)leftBtnAction:(id)sender{
//    
//}



#pragma mark - topView
- (void)setupTopView{
    UIView *topV = [UIView new];
    [self.view addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@(ScaleW(155) + Height_StatusBar));
    }];
    
    
    UIButton *button = [WLTools allocButton:nil textColor:nil nom_bg:nil hei_bg:nil frame:CGRectZero];
    [button setImage:[UIImage imageNamed:@"mine-close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [topV addSubview:button];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(ScaleW(5) + Height_StatusBar));
//        make.left.equalTo(@(ScaleW(20)));
        make.right.equalTo(@(-ScaleW(15)));
        make.height.equalTo(@(ScaleW(44)));
        make.width.equalTo(@(ScaleW(64)));
    }];
    
    
    
    UILabel *label = [WLTools allocLabel:SSKJLanguage(@"登录 ATEX") font:kBoldFont(24) textColor:kTitleColor frame:CGRectZero textAlignment:(NSTextAlignmentLeft)];
    [topV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ScaleW(20)));
        make.right.equalTo(@(ScaleW(-25)));
        make.top.mas_equalTo(ScaleW(125));
//        make.bottom.equalTo(button.mas_bottom).offset(ScaleW(35));
    }];
    
    UILabel *label1 = [WLTools allocLabel:SSKJLanguage(@"欢迎回来") font:kFont(14) textColor:kSubTitleColor frame:CGRectZero textAlignment:(NSTextAlignmentLeft)];
    [topV addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label).offset(ScaleW(5));
        make.top.equalTo(label.mas_bottom).offset(ScaleW(11));
    }];
    
    self.segmentControl = [[Login_Type_Option alloc] initWithTitles:@[SSKJLanguage(@"手机"), SSKJLanguage(@"邮箱")]];
    [topV addSubview:self.segmentControl];
    WS(weakSelf);
    self.segmentControl.selectBlock = ^(BOOL isPhone) {
        [weakSelf selectType:isPhone];
    };
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ScaleW(50)));
        make.right.equalTo(@(ScaleW(-50)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@(ScaleW(35)));
    }];
    
    //changed
    self.segmentControl.hidden = YES;

    self.topView = topV;
}

- (void)selectType:(BOOL)isPhone{
    self.accountView.field.placeholder = SSKJLanguage(@"手机号或邮箱");
    
    [self.accountView.field setPlaceHolderColor:kSubTitleColor];

    self.accountView.field.text = @"";
    
    [self areaViewShow:isPhone];
}

- (void)areaViewShow:(BOOL)show{
    
    if (show) {
        [_areaView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ScaleW(50)));
        }];
        _areaView.hidden = NO;
    }else{
        [_areaView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ScaleW(0.01)));
        }];
        _areaView.hidden = YES;
    }
    
}

#pragma mark - UI
- (void)setupUI{
    
    [self areaView];
    
    //changed
    [self selectType:NO];

    [self accountView];
    [self pwdView];
    [self commitBtn];
    [self forgetBtn];
    
    
    UILabel *title = [UILabel createWithText:SSKJLanguage(@"没有账号?") textColor:kSubTitleColor font:kFont(14)];
    [self.view addSubview:title];
//    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.commitBtn);
//        make.bottom.equalTo(@(ScaleW(-50)));
//    }];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commitBtn);
        make.top.equalTo(self.commitBtn.mas_bottom).offset(ScaleW(25));
    }];
    
    UIButton *button = [WLTools allocButton:SSKJLanguage(@"马上注册") textColor:kBlueColor nom_bg:nil hei_bg:nil frame:CGRectZero];
    button.titleLabel.font = kFont(14);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(topButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(ScaleW(2));
        make.centerY.equalTo(title);
    }];

}


- (UIButton *)forgetBtn{
    if (_forgetBtn == nil) {
        _forgetBtn = [WLTools allocButton:SSKJLanguage(@"忘记密码?") textColor:kBlueColor nom_bg:nil hei_bg:nil frame:CGRectZero];
        _forgetBtn.titleLabel.font = kFont(14);
        [_forgetBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetBtn];
        [_forgetBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.commitBtn);
//            make.top.equalTo(self.commitBtn.mas_bottom).offset(ScaleW(25));
//        }];
        [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commitBtn);
            make.bottom.equalTo(self.commitBtn.mas_top).offset(-ScaleW(15));
        }];
    }
    return _forgetBtn;
}

- (UIButton *)commitBtn{
    if (_commitBtn == nil) {
        _commitBtn = [WLTools allocButton:SSKJLanguage(@"登录") textColor:kWhiteColor nom_bg:nil hei_bg:nil frame:CGRectZero];
        _commitBtn.backgroundColor = kBlueColor;
        _commitBtn.titleLabel.font = kFont(16);
        [_commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.masksToBounds = YES;
        _commitBtn.layer.cornerRadius = ScaleW(5);
//        _commitBtn.backgroundColor = kBlueColor;
        [self.view addSubview:_commitBtn];
        
        [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(ScaleW(15)));
            make.right.equalTo(@(ScaleW(-15)));
            make.top.equalTo(self.pwdView.mas_bottom).offset(ScaleW(55));
            make.height.equalTo(@(ScaleW(44)));
        }];
    }
    return _commitBtn;
}

- (SSKJ_AreaCode_View *)areaView{
    if (!_areaView) {
        _areaView = [[SSKJ_AreaCode_View alloc] initWithColor:kTitleColor];
        _areaView.hidden = ![SSTool isInternationalization];
        [self.view addSubview:_areaView];

        [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset(ScaleW(15));
            make.height.equalTo(@(ScaleW(50)));
            make.left.equalTo(@(ScaleW(30)));
            make.right.equalTo(@(ScaleW(-30)));
        }];
    }
    return _areaView;
}

- (LoginTextFieldView *)accountView{
    if (_accountView == nil) {
        _accountView = [[LoginTextFieldView alloc] initWithImageName:@"login_account" placeholder:SSKJLanguage(@"邮箱") rightBtn:NO];
        [self.view addSubview:_accountView];
        
        [_accountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset(ScaleW(45));
            make.height.equalTo(@(ScaleW(60)));
            make.left.equalTo(@(ScaleW(15)));
            make.right.equalTo(@(ScaleW(-30)));
            
        }];
    }
    return _accountView;
}

- (LoginTextFieldView *)pwdView{
    if (_pwdView == nil) {
        _pwdView = [[LoginTextFieldView alloc] initWithImageName:@"login_pwd" placeholder:SSKJLanguage(@"请输入密码") rightBtn:YES];
        [self.view addSubview:_pwdView];
        
        [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountView.mas_bottom).offset(ScaleW(10));
            make.height.equalTo(@(ScaleW(60)));
            make.left.equalTo(@(ScaleW(15)));
            make.right.equalTo(@(ScaleW(-30)));
            
        }];
    }
    return _pwdView;
}


-(Login_Google_AlertView *)googleAlertView
{
    if (nil == _googleAlertView) {
        _googleAlertView = [[Login_Google_AlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        WS(weakSelf);
        _googleAlertView.confirmBlock = ^(NSString * _Nonnull code) {
            [weakSelf requestGoogleWith:code];
        };
    }
    return _googleAlertView;
}


- (void)showGoogleView{
    [self.view addSubview:self.googleAlertView];
}


@end
