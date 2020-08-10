//
//  MineHeaderView.m
//  SSKJ
//
//  Created by 姚立志 on 2020/8/7.
//  Copyright © 2020 刘小雨. All rights reserved.
//

#import "MineHeaderView.h"


@interface MineHeaderView ()


@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *promoteImageView;
@property (nonatomic, strong) UILabel *promoteTitleLabel;
@property (nonatomic, strong) UILabel *promoteTipLabel;
@property (nonatomic, strong) UIButton *heaedrBtn;  //!< 头部按钮
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *uuidLabel;










@end



@implementation MineHeaderView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self addSubview:self.bgImageView];
        [self addSubview:self.heaedrBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.uuidLabel];
        [self addSubview:self.promoteBtn];
        [self addSubview:self.promoteImageView];
        [self.promoteImageView  addSubview:self.promoteTitleLabel];
        [self.promoteImageView addSubview:self.promoteTipLabel];
        
        
        [self.heaedrBtn mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.equalTo(self.mas_top).offset(ScaleW(42));
            make.left.equalTo(self.mas_left).offset(ScaleW(15));
            make.height.width.equalTo(@(ScaleW(50)));
        }];
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
            make.top.equalTo(self.heaedrBtn.mas_top);
            make.left.equalTo(self.heaedrBtn.mas_right).offset(ScaleW(10));
            make.height.equalTo(@(ScaleW(30)));
        }];
        
        [self.uuidLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.titleLabel.mas_left);
            make.height.equalTo(@(ScaleW(15)));
        }];
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
            make.left.top.right.equalTo(@(0));
            make.height.equalTo(@(ScaleW(208)));
        }];
        
        
        [self.promoteImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            
            make.top.equalTo(self.mas_top).offset(ScaleW(116));
            make.left.equalTo(self.mas_left).offset(ScaleW(15));
            make.right.equalTo(self.mas_right).offset(-ScaleW(15));
            make.height.equalTo(@(ScaleW(100)));
            
        }];
        
        
        [self.promoteBtn mas_makeConstraints:^(MASConstraintMaker *make)
         {
            make.top.equalTo(self.promoteImageView.mas_bottom).offset(-ScaleW(5));
            make.left.right.equalTo(self.promoteImageView);
            make.height.equalTo(@(ScaleW(35)));
        }];
        
        
        [self.promoteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
            make.top.equalTo(self.promoteImageView.mas_top).offset(ScaleW(25));
            make.left.equalTo(self.promoteImageView.mas_left).offset(ScaleW(20));
            
        }];
        
        
        
        [self.promoteTipLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
            make.top.equalTo(self.promoteTitleLabel.mas_bottom).offset(ScaleW(15));
            make.left.equalTo(self.promoteTitleLabel.mas_left);
        }];
        
        
        
        
        
    }
    return self;
}



-(void)setTitle:(NSString*)title uuid:(NSString*)uuid
{
    [self.titleLabel setText:title];
    [self.uuidLabel setText:[NSString stringWithFormat:@"UUID:%@",uuid]];
}


#pragma mark - Getter / Setter
-(UIImageView *)bgImageView
{
    if (!_bgImageView)
    {
        _bgImageView = [[UIImageView alloc]init];
        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_bgImageView setCornerRadius:ScaleW(4)];
        [_bgImageView setImage:[UIImage imageNamed:@"mineheaderbg"]];
    }
    return _bgImageView;
}





-(UIButton *)heaedrBtn
{
    if (!_heaedrBtn)
    {
        _heaedrBtn = [[UIButton alloc]init];
        [_heaedrBtn setBackgroundImage:[UIImage imageNamed:@"userheader"] forState:UIControlStateNormal];
    }
    return _heaedrBtn;
}


-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setTextColor:kWhiteColor];
        [_titleLabel setFont:systemFont(ScaleW(17))];
        [_titleLabel setText:SSKJLanguage(@"未登录")];
    }
    return _titleLabel;
}


-(UILabel *)uuidLabel
{
    if (!_uuidLabel)
    {
        _uuidLabel = [[UILabel alloc]init];
        [_uuidLabel setTextColor:kWhiteColor];
        [_uuidLabel setFont:systemFont(ScaleW(12))];
        [_uuidLabel setText:SSKJLanguage(@"立即登录/注册")];
    }
    return _uuidLabel;
}


-(UIImageView *)promoteImageView
{
    if (!_promoteImageView)
    {
        _promoteImageView = [[UIImageView alloc]init];
        [_promoteImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_promoteImageView setCornerRadius:ScaleW(4)];
        [_promoteImageView setImage:[UIImage imageNamed:@"yaoqing"]];
    }
    return _promoteImageView;
}


- (UIButton *)promoteBtn
{
    if (!_promoteBtn)
    {
        _promoteBtn = [[UIButton alloc]init];
        [_promoteBtn setTitle:SSKJLanguage(@"立即邀请") forState:UIControlStateNormal];
        [_promoteBtn setBackgroundColor:UIColorFromRGB(0xFFC924)];
        [_promoteBtn setCornerRadius:ScaleW(4)];
    }
    return _promoteBtn;
}


-(UILabel *)promoteTitleLabel
{
    if (!_promoteTitleLabel)
    {
        _promoteTitleLabel = [[UILabel alloc]init];
        [_promoteTitleLabel setTextColor:kWhiteColor];
        [_promoteTitleLabel setFont:systemBoldFont(ScaleW(21))];
        [_promoteTitleLabel setText:SSKJLanguage(@"邀请好友拿收益")];
    }
    return _promoteTitleLabel;
}


-(UILabel *)promoteTipLabel
{
    if (!_promoteTipLabel)
    {
        _promoteTipLabel = [[UILabel alloc]init];
        [_promoteTipLabel setTextColor:kWhiteColor];
        [_promoteTipLabel setFont:systemFont(ScaleW(13))];
        [_promoteTipLabel setText:SSKJLanguage(@"海量资产天天等你拿")];
    }
    return _promoteTipLabel;
}







@end
