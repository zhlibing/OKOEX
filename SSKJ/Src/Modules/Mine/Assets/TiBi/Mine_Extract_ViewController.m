//
//  Mine_Extract_ViewController.m
//  SSKJ
//
//  Created by 刘小雨 on 2020/4/15.
//  Copyright © 2020 刘小雨. All rights reserved.
//

#import "Mine_Extract_ViewController.h"
#import "Mine_AddressManager_ViewController.h"
#import "Mine_QRScan_ViewController.h"
#import "AddressManager_HeaderView.h"
#import <AVFoundation/AVFoundation.h>
#import "ATEX_AssetRecord_ViewController.h"
#import <Photos/Photos.h>//相册

#import "Mine_AssetTiBiInfo_Model.h"
#import "UITextField+Helper.h"
#import "LA_Extract_SafeVerify_AlertView.h"

@interface Mine_Extract_ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scorllView;
@property (nonatomic, strong) AddressManager_HeaderView *headerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIButton *addressButton;

@property (nonatomic, strong) UILabel *usableLabel;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UIButton *allButton;

@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, strong) UILabel *daozhangLabel;// 到账数量
@property (nonatomic, strong) UIButton *tibiButton;

@property (nonatomic, strong) LA_Extract_SafeVerify_AlertView *alertView;

@property (nonatomic, assign) WalletType walletType;

@property (nonatomic, strong) Mine_AssetTiBiInfo_Model *infoModel;
@end

@implementation Mine_Extract_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = SSKJLocalized(@"提币", nil);
    [self addRightNavgationItemWithImage:[UIImage imageNamed:@"充币--记录"]];
    self.walletType = WalletTypeOMNI;
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestExtractInfo];
    
}

- (void)rigthBtnAction:(id)sender{
    ATEX_AssetRecord_ViewController *vc = [ATEX_AssetRecord_ViewController new];
    vc.assetType = AssetTypeExtract;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setUI
{
    [self.view addSubview:self.scorllView];
    [self.scorllView addSubview:self.headerView];

    [self.scorllView addSubview:self.backView];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.addressTextField];
    [self.backView addSubview:self.addressButton];
    [self.backView addSubview:self.lineView1];
    [self.backView addSubview:self.scanButton];
    self.addressTextField.width = self.scanButton.x - ScaleW(15);
    [self.backView addSubview:self.usableLabel];
    [self.backView addSubview:self.numberTextField];
    [self.backView addSubview:self.allButton];
    [self.backView addSubview:self.lineView2];
    [self.backView addSubview:self.unitLabel];
    self.addressTextField.width = self.unitLabel.x - ScaleW(20);
    [self.backView addSubview:self.warningLabel];
    
    self.backView.height = self.warningLabel.bottom + ScaleW(20);

    [self.scorllView addSubview:self.tibiButton];
    [self.scorllView addSubview:self.daozhangLabel];

}


- (UIScrollView *)scorllView
{
    if (nil == _scorllView) {
        _scorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar)];
    }
    return _scorllView;
}

-(AddressManager_HeaderView *)headerView
{
    if (nil == _headerView) {
        _headerView = [[AddressManager_HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScaleW(70))];
        WS(weakSelf);
        _headerView.changeWalletTypeBlock = ^(WalletType walletType) {
            weakSelf.walletType = walletType;
        };
    }
    return _headerView;
}
-(UIView *)backView
{
    if (nil == _backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(ScaleW(15), self.headerView.bottom, self.scorllView.width - ScaleW(30), 0)];
        _backView.backgroundColor = kSubBgColor;
        _backView.layer.cornerRadius = ScaleW(5);
    }
    return _backView;
}



-(UILabel *)addressLabel
{
    if (nil == _addressLabel) {
        _addressLabel = [WLTools allocLabel:SSKJLocalized(@"提币地址", nil) font:systemFont(ScaleW(14)) textColor:kTitleColor frame:CGRectMake(ScaleW(15), ScaleW(24), ScaleW(200), ScaleW(14)) textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

-(UITextField *)addressTextField
{
    if (nil == _addressTextField) {
        _addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.addressLabel.x, self.addressLabel.bottom + ScaleW(5), ScaleW(200), ScaleW(30))];
        _addressTextField.textColor = kTitleColor;
        _addressTextField.placeholder = SSKJLocalized(@"输入或长按粘贴地址", nil);
        [_addressTextField setPlaceHolderColor:kSubTitleColor];
        _addressTextField.font = systemFont(ScaleW(14));
    }
    return _addressTextField;
}

-(UIButton *)addressButton
{
    if (nil == _addressButton) {
        _addressButton = [[UIButton alloc]initWithFrame:CGRectMake(self.backView.width - ScaleW(45), 0, ScaleW(45), ScaleW(30))];
        [_addressButton setImage:[UIImage imageNamed:@"mine_tibi_address"] forState:UIControlStateNormal];
        _addressButton.centerY = self.addressTextField.centerY;
        [_addressButton addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];

    }
    return _addressButton;
}

-(UIView *)lineView1
{
    if (nil == _lineView1) {
        _lineView1 = [[UIView alloc]initWithFrame:CGRectMake(self.addressButton.x - 0.5, 0, 0.5, ScaleW(15))];
        _lineView1.centerY = self.addressButton.centerY;
        _lineView1.backgroundColor = kSubTitleColor;
    }
    return _lineView1;
}

-(UIButton *)scanButton
{
    if (nil == _scanButton) {
        _scanButton = [[UIButton alloc]initWithFrame:CGRectMake(self.lineView1.x - ScaleW(45), 0, ScaleW(45), ScaleW(30))];
        [_scanButton setImage:[UIImage imageNamed:@"saoma_white"] forState:UIControlStateNormal];
        _scanButton.centerY = self.addressTextField.centerY;
        [_scanButton addTarget:self action:@selector(scanEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}



-(UILabel *)usableLabel
{
    if (nil == _usableLabel) {
        _usableLabel = [WLTools allocLabel:SSKJLocalized(@"可用 2222 USDT", nil) font:systemFont(ScaleW(14)) textColor:kTitleColor frame:CGRectMake(ScaleW(15), self.addressTextField.bottom + ScaleW(20), ScaleW(200), ScaleW(14)) textAlignment:NSTextAlignmentLeft];
    }
    return _usableLabel;
}

-(UITextField *)numberTextField
{
    if (nil == _numberTextField) {
        _numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.addressLabel.x, self.usableLabel.bottom + ScaleW(5), ScaleW(200), ScaleW(30))];
        _numberTextField.textColor = kTitleColor;
        _numberTextField.placeholder = SSKJLocalized(@"输入提币数量", nil);
        [_numberTextField setPlaceHolderColor:kSubTitleColor];
        _numberTextField.font = systemFont(ScaleW(14));
        _numberTextField.delegate = self;
        _numberTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_numberTextField addTarget:self action:@selector(inputChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _numberTextField;
}

-(UIButton *)allButton
{
    if (nil == _allButton) {
        _allButton = [[UIButton alloc]initWithFrame:CGRectMake(self.backView.width - ScaleW(45), 0, ScaleW(45), ScaleW(30))];
        [_allButton setTitle:SSKJLocalized(@"全部", nil) forState:UIControlStateNormal];
        [_allButton setTitleColor:kTitleColor forState:UIControlStateNormal];
        _allButton.titleLabel.font = systemFont(ScaleW(15));
        _allButton.centerY = self.numberTextField.centerY;
        [_allButton addTarget:self action:@selector(allEvent) forControlEvents:UIControlEventTouchUpInside];

    }
    return _allButton;
}

-(UIView *)lineView2
{
    if (nil == _lineView2) {
        _lineView2 = [[UIView alloc]initWithFrame:CGRectMake(self.allButton.x - 0.5, 0, 0.5, ScaleW(15))];
        _lineView2.centerY = self.allButton.centerY;
        _lineView2.backgroundColor = kSubTitleColor;
    }
    return _lineView2;
}

- (UILabel *)unitLabel
{
    if (nil == _unitLabel) {
        _unitLabel = [WLTools allocLabel:SSKJLocalized(@"USDT", nil) font:systemFont(ScaleW(14)) textColor:kTitleColor frame:CGRectMake(self.lineView2.x - ScaleW(50), 0, ScaleW(50), ScaleW(14)) textAlignment:NSTextAlignmentLeft];
        _unitLabel.centerY = self.lineView2.centerY;
    }
    return _unitLabel;
}

-(UILabel *)warningLabel
{
    if (nil == _warningLabel) {
        NSString *string = SSKJLocalized(@"", nil);
        _warningLabel = [WLTools allocLabel:string font:systemFont(ScaleW(11)) textColor:kSubTitleColor frame:CGRectMake(ScaleW(15), self.numberTextField.bottom + ScaleW(10), self.backView.width - ScaleW(30), ScaleW(100)) textAlignment:NSTextAlignmentLeft];
    }
    return _warningLabel;
}

- (UIButton *)tibiButton{
    if (_tibiButton == nil) {
        _tibiButton = [WLTools allocButton:SSKJLanguage(@"确定") textColor:kWhiteColor nom_bg:nil hei_bg:nil frame:CGRectMake(ScaleW(15), ScreenHeight - Height_NavBar - ScaleW(45) - ScaleW(20), ScreenWidth - ScaleW(30), ScaleW(45))];
        _tibiButton.titleLabel.font = kFont(15);
        [_tibiButton addTarget:self action:@selector(tibiEvent) forControlEvents:UIControlEventTouchUpInside];
        _tibiButton.layer.masksToBounds = YES;
        _tibiButton.layer.cornerRadius = ScaleW(5);
        _tibiButton.backgroundColor = kBlueColor;
        [self.view addSubview:_tibiButton];
    }
    return _tibiButton;
}


-(UILabel *)daozhangLabel
{
    if (nil == _daozhangLabel) {
        _daozhangLabel = [WLTools allocLabel:SSKJLocalized(@"到账数量:0.00 USDT", nil)  font:systemFont(ScaleW(16)) textColor:kTitleColor frame:CGRectMake(ScaleW(15), self.tibiButton.y - ScaleW(21) - ScaleW(15), self.tibiButton.width, ScaleW(16)) textAlignment:NSTextAlignmentLeft];
    }
    return _daozhangLabel;
}

-(LA_Extract_SafeVerify_AlertView *)alertView
{
    if (nil == _alertView) {
        WS(weakSelf);
        _alertView = [[LA_Extract_SafeVerify_AlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _alertView.confirmBlock = ^(NSString * _Nonnull pwd, NSString * _Nonnull googleCode, NSString * _Nonnull smsCode) {
            [weakSelf requestExtractWithPWD:pwd smsCode:smsCode];
        };
    }
    return _alertView;
}

#pragma mark - 用户操作

// 点击全部
-(void)allEvent
{
    double allTibi = self.infoModel.balance.doubleValue - self.infoModel.fee.doubleValue;
    
    if (allTibi < 0) {
        allTibi = 0;
    }
    
    self.numberTextField.text = [WLTools noroundingStringWith:allTibi afterPointNumber:2];
    
    [self inputChanged];
    
}

// 选择提币地址
-(void)selectAddress
{
    Mine_AddressManager_ViewController *vc = [[Mine_AddressManager_ViewController alloc]init];
    WS(weakSelf);
    vc.getAddressBlock = ^(ExtractAddress_IndexModel *addressModel) {
        weakSelf.addressTextField.text = addressModel.address;
    };
    vc.walletType = self.walletType;
    [self.navigationController pushViewController:vc animated:YES];
}

// 扫描
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
               weakSelf.addressTextField.text = string;
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


// 提币操作
-(void)tibiEvent
{
    if (self.addressTextField.text.length == 0) {
        [MBProgressHUD showError:SSKJLocalized(@"请输入或长按粘贴地址", nil)];
        return;
    }
    
    if (self.numberTextField.text.length == 0) {
        [MBProgressHUD showError:SSKJLocalized(@"请输入提币数量", nil)];
        return;
    }
    
    if (self.numberTextField.text.doubleValue < self.infoModel.min.doubleValue) {
        [MBProgressHUD showError:[NSString stringWithFormat:SSKJLocalized(@"最小提币数量%@ USDT", nil),[WLTools noroundingStringWith:self.infoModel.min.doubleValue afterPointNumber:2]]];
        return;
    }
    
    if (self.numberTextField.text.doubleValue > self.infoModel.max.doubleValue) {
        [MBProgressHUD showError:[NSString stringWithFormat:SSKJLocalized(@"最大提币数量%@ USDT", nil),[WLTools noroundingStringWith:self.infoModel.max.doubleValue afterPointNumber:2]]];
        return;
    }
    
    if (self.numberTextField.text.doubleValue + self.infoModel.fee.doubleValue > self.infoModel.balance.doubleValue) {
        [MBProgressHUD showError:SSKJLocalized(@"余额不足", nil)];
        return;
    }
    
    [self.alertView showWithIsGoogleOpen:NO isSmsOpen:YES];
    
}


#pragma mark - 网络请求

-(void)requestExtractInfo
{
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_ExtractInfo_URL RequestType:RequestTypeGet Parameters:nil Success:^(NSInteger statusCode, id responseObject)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        WL_Network_Model *net_model = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if (net_model.status.integerValue == SUCCESSED)
        {
            weakSelf.infoModel = [Mine_AssetTiBiInfo_Model mj_objectWithKeyValues:[net_model.data firstObject]];
            [weakSelf resetView];
        }
        else
        {
            [MBProgressHUD showError:net_model.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:SSKJLocalized(@"网络异常", nil)];
    }];
}

-(void)resetView
{
    self.usableLabel.text = [NSString stringWithFormat:SSKJLocalized(@"可用 %@ USDT", nil),[WLTools noroundingStringWith:self.infoModel.balance.doubleValue afterPointNumber:2]];
    
    self.warningLabel.text = [NSString stringWithFormat: SSKJLocalized(@"手续费:%@ USDT/次 最小提币数量为 %@ USDT 请确定目标提币地址是否存在且被激活，否则将会导致提币失败，且资产不可找回。", nil),[WLTools noroundingStringWith:self.infoModel.fee.doubleValue afterPointNumber:2],[WLTools noroundingStringWith:self.infoModel.min.doubleValue afterPointNumber:2]];
    
    CGFloat height = [self.warningLabel.text boundingRectWithSize:CGSizeMake(self.warningLabel.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.warningLabel.font} context:nil].size.height;
    self.warningLabel.height = height;
    self.backView.height = self.warningLabel.bottom + ScaleW(20);

    
}


#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.numberTextField)
    {
        return [textField textFieldShouldChangeCharactersInRange:range replacementString:string dotNumber:2];
    }
    else
    {
        return YES;
    }
}


-(void)inputChanged
{
    self.numberTextField.text = [self deleteFirstZero:self.numberTextField.text];
    
    double shijiNumber = (self.numberTextField.text.doubleValue - self.infoModel.fee.doubleValue);
    
    if (shijiNumber < 0)
    {
        shijiNumber = 0;
    }
    
    
    NSString *shijiString = [WLTools noroundingStringWith:shijiNumber afterPointNumber:2];
    
    NSString *string = [NSString stringWithFormat:SSKJLocalized(@"到账数量:%@ USDT", nil),shijiString];
    
    self.daozhangLabel.attributedText = [WLTools setAttributeTextWithString:string colorString:shijiString color:kBlueColor];
    
}

// 出去首位0
-(NSString *)deleteFirstZero:(NSString *)string
{
    if (![string hasPrefix:@"0"] || [string isEqualToString:@"0"] || [string hasPrefix:@"0."]) {
        
        return string;
    }else{
        return [self deleteFirstZero:[string substringFromIndex:1]];
    }
}




#pragma mark - 提币

-(void)requestExtractWithPWD:(NSString *)pwd smsCode:(NSString *)smsCode
{
    NSDictionary *params = @{
                            @"money":self.numberTextField.text,
                            @"payment_password":pwd,
                            @"code":smsCode,
                            @"address":self.addressTextField.text,
                            @"type":@"1"
                            };
    
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_ConfirmExtract_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        WL_Network_Model *net_model = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if (net_model.status.integerValue == SUCCESSED) {
            [weakSelf.alertView hide];
            [weakSelf clearView];
            [weakSelf rigthBtnAction:nil];
        }else{
            [MBProgressHUD showError:net_model.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:SSKJLocalized(@"网络异常", nil)];
    }];
}

-(void)clearView
{
    self.numberTextField.text = nil;
    self.addressTextField.text = nil;

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
