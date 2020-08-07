//
//  MineSafeCenterHeaderView.m
//  SSKJ
//
//  Created by SSKJ on 2020/2/21.
//  Copyright © 2020 刘小雨. All rights reserved.
//

#import "MineSafeCenterHeaderView.h"

@interface MineSafeCenterHeaderView ()

@property (nonatomic, strong) UILabel *safeTipLabel; //!< 安全提示标签
@property (nonatomic, strong) UILabel *safeLevelLabel; //!< 安全级别标签
@property (nonatomic, strong) UIView *safelowLevelView; //!< 安全低级别标签
@property (nonatomic, strong) UIView *safemiddLevelView; //!< 安全中级别标签

@property (nonatomic, strong) UIView *safeheightLevelView; //!< 安全级别标签

@property (nonatomic, strong) UILabel *moreTipLabel; //!< 多重验证提示标签
@property (nonatomic, strong) UILabel *moreTitleLabel; //!< 多重验证提示标签

@end


@implementation MineSafeCenterHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self addSubview:self.safeTipLabel];
        [self addSubview:self.safeLevelLabel];
        [self addSubview:self.safelowLevelView];
        [self addSubview:self.safemiddLevelView];
        [self addSubview:self.safeheightLevelView];
        [self addSubview:self.moreTipLabel];
        [self addSubview:self.moreTitleLabel];
        
        [self.safeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.mas_top).offset(ScaleW(ScaleW(30)));
            make.left.equalTo(self.mas_left).offset(ScaleW(15));

        }];
        
        
        [self.safeLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.safeTipLabel.mas_top);
            make.left.equalTo(self.safeTipLabel.mas_right).offset(ScaleW(10));
            
        }];
        
        
        [self.safelowLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.safeTipLabel.mas_bottom).offset(ScaleW(10));
            make.left.equalTo(self.safeTipLabel.mas_left);
            make.width.equalTo(@(ScaleW(45)));
            make.height.equalTo(@(ScaleW(13)));
            
        }];
        
        [self.safemiddLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.safelowLevelView.mas_right).offset(ScaleW(10));
            make.height.width.equalTo(self.safelowLevelView);
            make.centerY.equalTo(self.safelowLevelView);
            
        }];
        
        [self.safeheightLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.safemiddLevelView.mas_right).offset(ScaleW(10));
            make.height.width.equalTo(self.safelowLevelView);
            make.centerY.equalTo(self.safelowLevelView);
            
        }];
        
        [self.moreTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.safelowLevelView.mas_bottom).offset(ScaleW(18));
            make.left.equalTo(self.safeTipLabel.mas_left);
            
        }];
        
        [self.moreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            
            make.centerY.equalTo(self.moreTipLabel.mas_centerY); make.right.equalTo(self.mas_right).offset(-ScaleW(15));
            
            
        }];
        
        
    }
    return self;
}


/// 设置用户信息
/// @param userinfo SSKJ_UserInfo_Model 用户对象
-(void)setUserInfo:(SSKJ_UserInfo_Model*)userinfo
{
    switch ([userinfo.config.security_level intValue])
    {
        case 1:
        {
            [self.safeLevelLabel setText:SSKJLanguage(@"低")];
            [self.safelowLevelView setBackgroundColor:RED_HEX_COLOR];
            
        }
            break;
        case 2:
        {
            [self.safeLevelLabel setText:SSKJLanguage(@"中")];
            [self.safelowLevelView setBackgroundColor:kBlueColor];
            [self.safemiddLevelView setBackgroundColor:kBlueColor];
        }
            break;
        case 3:
        {
            [self.safeLevelLabel setText:SSKJLanguage(@"高")];
            [self.safelowLevelView setBackgroundColor:kBlueColor];
            [self.safemiddLevelView setBackgroundColor:kBlueColor];
            [self.safeheightLevelView setBackgroundColor:kBlueColor];
        }
            break;
    }
    
}


#pragma mark - Getter / Setter
-(UILabel *)safeTipLabel
{
    if (!_safeTipLabel)
    {
        _safeTipLabel  = [FactoryUI createLabelWithFrame:CGRectZero text:SSKJLanguage(@"安全级别") textColor:kBlueColor font:systemFont(ScaleW(14))];
    }
    return _safeTipLabel;
}

-(UILabel *)safeLevelLabel
{
    if (!_safeLevelLabel)
    {
        _safeLevelLabel  = [FactoryUI createLabelWithFrame:CGRectZero text:@"中" textColor:UIColorFromRGB(0x2FE091) font:systemFont(ScaleW(14))];
    }
    return _safeLevelLabel;
}

-(UIView *)safelowLevelView
{
    if (!_safelowLevelView)
    {
        _safelowLevelView = [[UIView alloc]init];
        [_safelowLevelView setBackgroundColor:kBlueColor];
    }
    return _safelowLevelView;
}

-(UIView *)safemiddLevelView
{
    if (!_safemiddLevelView)
    {
        _safemiddLevelView = [[UIView alloc]init];
        [_safemiddLevelView setBackgroundColor:kBlueColor];
    }
    return _safemiddLevelView;
}


-(UIView *)safeheightLevelView
{
    if (!_safeheightLevelView)
    {
        _safeheightLevelView = [[UIView alloc]init];
        [_safeheightLevelView setBackgroundColor:kBlueColor];
    }
    return _safeheightLevelView;
}


-(UILabel *)moreTipLabel
{
    if (!_moreTipLabel)
    {
        _moreTipLabel  = [FactoryUI createLabelWithFrame:CGRectZero text:SSKJLanguage(@"多重验证") textColor:kBlueColor font:systemFont(ScaleW(14))];
    }
    return _moreTipLabel;
}

-(UILabel *)moreTitleLabel
{
    if (!_moreTitleLabel)
    {
        _moreTitleLabel  = [FactoryUI createLabelWithFrame:CGRectZero text:SSKJLanguage(@"以下三种验证方式至少开启一种") textColor:kBlueColor font:systemFont(ScaleW(14))];
    }
    return _moreTitleLabel;
}

@end
