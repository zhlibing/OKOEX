//
//  SY_InviteViewController.m
//  SSKJ
//
//  Created by zpz on 2019/11/25.
//  Copyright © 2019 刘小雨. All rights reserved.
//

#import "SY_InviteViewController.h"
#import "ImaginaryLineView.h"
@interface SY_InviteViewController ()



@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *leftTopLabel;
@property (nonatomic, strong) UILabel *leftBottomLabel;
@property (nonatomic, strong) UILabel *middleTopLabel;
@property (nonatomic, strong) UILabel *middleBootomLabel;
@property (nonatomic, strong) UILabel *rightTopLabel;
@property (nonatomic, strong) UILabel *rightBootomLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *tipLabel; //!< 加入经纪人享更多收益，详情联系平台客服


@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *bottomTipLabel; //!< 我的邀请链接
@property (nonatomic, strong) UILabel *invitationAddressLabel; //!< 邀请注册地址
@property (nonatomic, strong) UILabel *invitationTipLabel; //!< 我的邀请提示
@property (nonatomic, strong) UILabel *invitationCodeLabel; //!< 我的邀请码

@property (nonatomic, strong) UIButton *submitBtn; //!< 生产海报按钮



@property (nonatomic, strong) UIImageView *qrImageV;
@property (nonatomic, strong) UILabel *qrLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *dumplainButton;
@end

@implementation SY_InviteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kSubBgColor];
    
    self.title = SSKJLocalized(@"推广海报", nil);
//    [self setupViews];
//    [self getinfo];
    
//    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
//    self.qrImageV.userInteractionEnabled = YES;
//    [self.qrImageV addGestureRecognizer:longPress];
    
    
    [self unit:YES];
}












- (void)getinfo
{
    [MBHUD showHUDAddedTo:self.view];
    WS(weakSelf);
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_Qrcode_URL RequestType:RequestTypeGet Parameters:nil Success:^(NSInteger statusCode, id responseObject) {
        [MBHUD hideHUDForView:self.view];

        WL_Network_Model *network_Model=[WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (network_Model.status.integerValue == SUCCESSED)
        {
            weakSelf.qrLabel.text = network_Model.data[@"account"];
            [weakSelf.qrImageV sd_setImageWithURL:[NSURL URLWithString:network_Model.data[@"qrcode"]]];
            
//            self.qrImageV.image = [self creatCIQRCodeImageWithString:network_Model.data[@"url"]];
            
        }else{
            [MBProgressHUD showError:network_Model.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [MBHUD hideHUDForView:self.view];
        [MBHUD showError:SSKJLocalized(@"网错出错", nil)];
    }];
    
    
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:URL_Invite_Rule RequestType:RequestTypeGet Parameters:@{} Success:^(NSInteger statusCode, id responseObject)
    {
        
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if (netWorkModel.status.integerValue == SUCCESSED )
        {
           
            
        }
        else
        {
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject)
    {
        
    }];
}


- (NSAttributedString *)disposeContent:(NSString *)sender{
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",ScreenWidth -ScaleW(50),sender];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:kTitleColor, NSFontAttributeName:kFont(13)} range:NSMakeRange(0, attrStr.length - 1)];
    return attrStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setNavgationBackgroundColor:kSubBgColor alpha:0];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setNavgationBackgroundColor:kSubBgColor alpha:1];

}
#pragma mark - 用户操作
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inviteClick{
    [self copyEvent];
}

#pragma mark - UI

- (void)setupViews{
    
    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    self.backImageView = [UIImageView new];
           //中文
    self.backImageView.image = MyImage(SSKJLocalized(@"tghb", nil));

    self.backImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight) ;
    [self.view addSubview:self.backImageView];
    
    [self qrImageV];
    [self titleLabel];
    [self qrLabel];
    [self dumplainButton];
    
    
}

-(UIImageView *)qrImageV
{
    if (nil == _qrImageV) {
        _qrImageV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _qrImageV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_qrImageV];
        CGFloat startY = -ScaleW(130);
        if (!IS_IPHONE_X_ALL) {
            startY = -ScaleW(97);
        }
        
        [_qrImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(80));
            make.bottom.mas_equalTo(startY);
            make.width.height.mas_equalTo(ScaleW(100));
        }];
    }
    return _qrImageV;
}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [WLTools allocLabel:SSKJLocalized(@"邀请码", nil) font:systemFont(ScaleW(13)) textColor:kSubTitleColor frame:CGRectZero textAlignment:NSTextAlignmentLeft];
        [self.view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.qrImageV.mas_right).offset(ScaleW(20));
            make.top.equalTo(self.qrImageV.mas_top).offset(ScaleW(3));
        }];
    }
    return _titleLabel;
}


- (UILabel *)qrLabel
{
    if (nil == _qrLabel) {
        _qrLabel = [WLTools allocLabel:SSKJLocalized(@"", nil) font:systemBoldFont(ScaleW(15)) textColor:kBlueColor frame:CGRectZero textAlignment:NSTextAlignmentLeft];
        [self.view addSubview:_qrLabel];
        [_qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(ScaleW(10));
        }];
    }
    return _qrLabel;
}
- (UIButton *)dumplainButton
{
    if (nil == _dumplainButton) {
        _dumplainButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_dumplainButton setTitle:SSKJLocalized(@"复制", nil) forState:UIControlStateNormal];
        [_dumplainButton setTitleColor:kTitleColor forState:UIControlStateNormal];
        _dumplainButton.titleLabel.font = systemFont(ScaleW(15));
        _dumplainButton.backgroundColor = kBlueColor;
        _dumplainButton.layer.cornerRadius = ScaleW(18);
        [_dumplainButton addTarget:self action:@selector(copyEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_dumplainButton];
        
        [_dumplainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.width.mas_equalTo(ScaleW(100));
            make.height.mas_equalTo(ScaleW(36));
            make.bottom.equalTo(self.qrImageV.mas_bottom);
        }];
    }
    return _dumplainButton;
}


-(void)saveImage:(UILongPressGestureRecognizer *)longPress
{
    if (!self.qrImageV.image) {
        return;
    }
    if (longPress.state == UIGestureRecognizerStateBegan) {
        WS(weakSelf);
        [SSKJ_Default_AlertView showWithTitle:SSKJLocalized(@"保存二维码", nil)  message:SSKJLocalized(@"保存二维码到相册", nil) cancleTitle:SSKJLocalized(@"取消", nil) confirmTitle:SSKJLocalized(@"保存", nil) confirmBlock:^{
            UIImage *img = weakSelf.qrImageV.image;
            UIImageWriteToSavedPhotosAlbum(img, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:),nil);
        }];
    }
}

// 需要实现下面的方法,或者传入三个参数即可
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:SSKJLocalized(@"保存失败", nil)];
    } else {
        [MBProgressHUD showError:SSKJLocalized(@"保存成功", nil)];
    }
}


-(void)copyEvent
{
    if (!self.qrLabel.text.length) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.qrLabel.text;
    [MBProgressHUD showError:SSKJLocalized(@"复制成功", nil)];
}

/**
 *  生成二维码
 */
- (UIImage *)creatCIQRCodeImageWithString:(NSString *)string
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认设置
    [filter setDefaults];
    // 3. 给过滤器添加数据
    NSString *dataString = string;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    // 5. 显示二维码
    // 该方法生成的图片较模糊
    //    self.codeImg.image = [UIImage imageWithCIImage:outputImage];
    // 使用该方法生成高清图
    return [self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:self.qrImageV.width];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成高清的UIImage
 */
- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}


#pragma mark - Private Method
#pragma mark UI布局
-(void)unit:(BOOL)unit
{
    [self.view addSubview:self.backImageView];
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.leftTopLabel];
    [self.topView addSubview:self.leftBottomLabel];
    [self.topView addSubview:self.middleTopLabel];
    [self.topView addSubview:self.middleBootomLabel];
    [self.topView addSubview:self.rightTopLabel];
    [self.topView addSubview:self.rightBootomLabel];
    [self.topView addSubview:self.leftImageView];
    [self.topView addSubview:self.rightImageView];
    
    
    [self.view addSubview:self.tipLabel];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomTipLabel];
    [self.bottomView addSubview:self.invitationAddressLabel];
    [self.bottomView addSubview:self.invitationTipLabel];
    [self.bottomView addSubview:self.invitationCodeLabel];

    
    [self.view addSubview:self.submitBtn];

    
    
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(@(Height_NavBar));
        make.left.right.equalTo(@(0));
        make.height.equalTo(@(ScaleW(266)));
    }];
    
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.backImageView.mas_bottom).offset(-ScaleW(47));
        make.left.equalTo(self.view).offset(ScaleW(15));
        make.right.equalTo(self.view).offset(-ScaleW(15));
        make.height.equalTo(@(ScaleW(72)));
    }];
    
    [self.leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.left.equalTo(self.topView.mas_left).offset(ScaleW(15));
        make.bottom.equalTo(self.topView.mas_centerY);
        make.width.equalTo(@(ScaleW(60)));
    }];
    
    [self.leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.leftTopLabel.mas_left);
        make.width.equalTo(self.leftTopLabel);
    }];
    
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.leftTopLabel.mas_right).offset(ScaleW(10));
        make.width.equalTo(@(ScaleW(44)));
    }];
    
    
    [self.middleTopLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.centerX.equalTo(self.topView.mas_centerX);
        make.bottom.equalTo(self.topView.mas_centerY);
    }];
    
    [self.middleBootomLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.topView.mas_centerY);
        make.centerX.equalTo(self.topView.mas_centerX);
    }];
    
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.topView.mas_centerX).offset(ScaleW(53));
        make.width.equalTo(@(ScaleW(44)));
    }];
    
    [self.rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.right.equalTo(self.topView.mas_right).offset(-ScaleW(13));
        make.bottom.equalTo(self.topView.mas_centerY);
    }];
    
    [self.rightBootomLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.topView.mas_centerY);
        make.right.equalTo(self.leftTopLabel);
    }];
    
    
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.topView.mas_bottom);
        make.height.equalTo(@(40));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.tipLabel.mas_bottom);
        make.left.right.equalTo(self.topView);
        make.height.equalTo(@(165));
    }];
    
    
    [self.bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bottomView.mas_top).offset(ScaleW(19));
        make.left.equalTo(self.bottomView.mas_left).offset(ScaleW(15));
    }];
    
    [self.invitationAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bottomTipLabel.mas_bottom).offset(ScaleW(5));
        make.left.equalTo(self.bottomTipLabel);
    }];
    
    
    [self.invitationTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bottomView.mas_centerY).offset(ScaleW(5));
        make.left.equalTo(self.bottomTipLabel);
    }];
    
    
    [self.invitationCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.invitationTipLabel.mas_bottom).offset(ScaleW(10));
        make.left.equalTo(self.bottomTipLabel);
    }];
    
    
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        
        make.top.equalTo(self.bottomView.mas_bottom).offset(ScaleW(50));
        make.left.right.equalTo(self.bottomView);
        make.height.equalTo(@(ScaleW(45)));
    }];
    
    
    
    
    
}




#pragma mark - Getter / Setter
-(UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc]init];
        [_backImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_backImageView setImage:[UIImage imageNamed:@"invitationbg"]];
    }
    return _backImageView;
}

-(UIView *)topView
{
    if (!_topView)
    {
        _topView = [[UIView alloc]init];
        [_topView setBackgroundColor:kWhiteColor];
        [_topView setCornerRadius:ScaleW(5)];
    }
    return _topView;
}


-(UILabel *)leftTopLabel
{
    if (!_leftTopLabel)
    {
        _leftTopLabel = [[UILabel alloc]init];
        [_leftTopLabel setFont:systemFont(ScaleW(13))];
        [_leftTopLabel setTextColor:kSubTitleColor];
        [_leftTopLabel setText:SSKJLanguage(@"发送邀请")];
    }
    return _leftTopLabel;
}


-(UILabel *)leftBottomLabel
{
    if (!_leftBottomLabel)
    {
        _leftBottomLabel = [[UILabel alloc]init];
        [_leftBottomLabel setFont:systemFont(ScaleW(13))];
        [_leftBottomLabel setTextColor:kSubTitleColor];
        [_leftBottomLabel setText:SSKJLanguage(@"给好友")];
    }
    return _leftBottomLabel;
}

-(UILabel *)middleTopLabel
{
    if (!_middleTopLabel)
    {
        _middleTopLabel = [[UILabel alloc]init];
        [_middleTopLabel setFont:systemFont(ScaleW(13))];
        [_middleTopLabel setTextColor:kSubTitleColor];
        [_middleTopLabel setText:SSKJLanguage(@"好友完成注册")];
    }
    return _middleTopLabel;
}


-(UILabel *)middleBootomLabel
{
    if (!_middleBootomLabel)
    {
        _middleBootomLabel = [[UILabel alloc]init];
        [_middleBootomLabel setFont:systemFont(ScaleW(13))];
        [_middleBootomLabel setTextColor:kSubTitleColor];
        [_middleBootomLabel setText:SSKJLanguage(@"成为你的下级")];
    }
    return _middleBootomLabel;
}


-(UILabel *)rightTopLabel
{
    if (!_rightTopLabel)
    {
        _rightTopLabel = [[UILabel alloc]init];
        [_rightTopLabel setFont:systemFont(ScaleW(13))];
        [_rightTopLabel setTextColor:kSubTitleColor];
        [_rightTopLabel setText:SSKJLanguage(@"获得相应")];
    }
    return _rightTopLabel;
}


-(UILabel *)rightBootomLabel
{
    if (!_rightBootomLabel)
    {
        _rightBootomLabel = [[UILabel alloc]init];
        [_rightBootomLabel setFont:systemFont(ScaleW(13))];
        [_rightBootomLabel setTextColor:kSubTitleColor];
        [_rightBootomLabel setText:SSKJLanguage(@"比例佣金")];
    }
    return _rightBootomLabel;
}


-(UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc]init];
        [_tipLabel setFont:systemFont(ScaleW(13))];
        [_tipLabel setTextColor:kSubTitleColor];
        [_tipLabel setText:SSKJLanguage(@"加入经纪人享更多收益，详情联系平台客服")];
    }
    return _tipLabel;
}



-(UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc]init];
        [_bottomView setBackgroundColor:kWhiteColor];
        [_bottomView setCornerRadius:ScaleW(5)];
    }
    return _bottomView;
}

-(UILabel *)bottomTipLabel
{
    if (!_bottomTipLabel)
    {
        _bottomTipLabel = [[UILabel alloc]init];
        [_bottomTipLabel setFont:systemFont(ScaleW(13))];
        [_bottomTipLabel setTextColor:kSubTitleColor];
        [_bottomTipLabel setText:SSKJLanguage(@"我的邀请链接")];
    }
    return _bottomTipLabel;
}


-(UILabel *)invitationAddressLabel
{
    if (!_invitationAddressLabel)
    {
        _invitationAddressLabel = [[UILabel alloc]init];
        [_invitationAddressLabel setFont:systemFont(ScaleW(16))];
        [_invitationAddressLabel setTextColor:kSubTitleColor];
        [_invitationAddressLabel setText:@"https://www.SKPEX.io/"];
    }
    return _invitationAddressLabel;
}





-(UILabel *)invitationTipLabel
{
    if (!_invitationTipLabel)
    {
        _invitationTipLabel = [[UILabel alloc]init];
        [_invitationTipLabel setFont:systemFont(ScaleW(13))];
        [_invitationTipLabel setTextColor:kSubTitleColor];
        [_invitationTipLabel setText:SSKJLanguage(@"我的邀请码")];
    }
    return _invitationTipLabel;
}


-(UILabel *)invitationCodeLabel
{
    if (!_invitationCodeLabel)
    {
        _invitationCodeLabel = [[UILabel alloc]init];
        [_invitationCodeLabel setFont:systemBoldFont(ScaleW(24))];
        [_invitationCodeLabel setTextColor:kTitleColor];
        [_invitationCodeLabel setText:@"123456"];
    }
    return _invitationCodeLabel;
}


-(UIButton *)submitBtn
{
    if (!_submitBtn)
    {
        _submitBtn = [[UIButton alloc]init];
        [_submitBtn setTitle:SSKJLanguage(@"生成邀请海报") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:kBlueColor];
        [_submitBtn setCornerRadius:ScaleW(5)];
    }
    return _submitBtn;
}


- (UIImageView *)leftImageView
{
    if (!_leftImageView)
    {
        _leftImageView = [[UIImageView alloc]init];
        [_leftImageView setImage:[UIImage imageNamed:@"duijie"]];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView)
    {
        _rightImageView = [[UIImageView alloc]init];
        [_rightImageView setImage:[UIImage imageNamed:@"duijie"]];
    }
    return _rightImageView;
}







@end
