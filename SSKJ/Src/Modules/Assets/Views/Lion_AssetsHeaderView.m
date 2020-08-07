
//
//  Lion_AssetsHeaderView.m
//  SSKJ
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 刘小雨. All rights reserved.
//

#import "Lion_AssetsHeaderView.h"


@interface Lion_AssetsHeaderView ()
@property (nonatomic ,strong) UIView *topView;
@property (nonatomic ,strong) UIImageView *bgImgV;
@property (nonatomic ,strong) UILabel *assetsTitleLb;
@property (nonatomic ,strong) UILabel *assetsLb;
@property (nonatomic ,strong) UILabel *moneyLb;
@property (nonatomic ,strong) UILabel *freeLb;
@property (nonatomic ,strong) UILabel *frozenLb;
@property (nonatomic ,strong) UIButton *eyeBtn;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UIButton *cbButton;
@property (nonatomic ,strong) UIButton *tbButton;
@property (nonatomic ,strong) UIButton *czButton;//充值
@property (nonatomic ,strong) UIView *horLineView;//竖线
@property (nonatomic ,strong) UIView *horLineView2;//竖线
@property (nonatomic ,strong) UIView *bottomLineView;
@property (nonatomic ,strong) UIView *shadowView;//阴影

@property (nonatomic, strong)UILabel *securetLb1;
@property (nonatomic, strong)UILabel *securetLb2;
 


@end




@implementation Lion_AssetsHeaderView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (void)clearData{
    self.assetsLb.text = @"0";
    self.moneyLb.text  = @"0";
    self.freeLb.text  =self.frozenLb.text = @"0";
    self.model = nil;
}

- (void)setModel:(Lion_Assets_new_Model *)model{
    _model = model;
//    self.assetsLb.text = [WLTools noroundingStringWith:model.allFund.doubleValue afterPointNumber:8];
    self.assetsLb.text = [WLTools noroundingStringWith:model.balance.doubleValue + model.frost.doubleValue afterPointNumber:[SSTool MarketNum:@""]];
    self.moneyLb.text = [NSString stringWithFormat:@"≈ %@ CNY", [WLTools noroundingStringWith:model.total_rmb.doubleValue afterPointNumber:2]];
       
    self.freeLb.text = [NSString stringWithFormat:SSKJLocalized(@"可用 %@", nil), [WLTools noroundingStringWith:model.balance.doubleValue afterPointNumber:[SSTool MarketNum:@""]]];
    self.frozenLb.text =  [NSString stringWithFormat:SSKJLocalized(@"冻结 %@", nil), [WLTools noroundingStringWith:model.frost.doubleValue afterPointNumber:[SSTool MarketNum:@""]]];
}


- (void)addChildrenViews{
    self.backgroundColor = kBgColor;
    self.topView = [UIView new];
    
    self.bgImgV = [UIImageView new];
    self.assetsTitleLb = [UILabel new];
    self.assetsLb = [UILabel new];
    self.moneyLb = [UILabel new];
    self.freeLb = [UILabel new];
    self.frozenLb = [UILabel new];
    self.bottomView = [UIView new];
    self.eyeBtn = [UIButton new];
    self.cbButton = [UIButton new];
    self.tbButton = [UIButton new];
    self.czButton = [UIButton new];
    self.horLineView = [UIView new];
    self.horLineView2 = [UIView new];
    self.bottomLineView = [UIView new];
    self.securetLb1 = [UILabel new];
    self.securetLb2 = [UILabel new];
    self.shadowView = [UIView new];
    
    [self addSubview:self.topView];
    [self addSubview:self.shadowView];
    [self addSubview:self.bottomView];
    [self addSubview:self.bottomLineView];
    
    [self.topView addSubview:self.bgImgV];
    [self.topView addSubview:self.assetsTitleLb];
    [self.topView addSubview:self.assetsLb];
    [self.topView addSubview:self.moneyLb];
    [self.topView addSubview:self.freeLb];
    [self.topView addSubview:self.frozenLb];
    [self.topView addSubview:self.eyeBtn];
    
    [self.bottomView addSubview:self.tbButton];
    [self.bottomView addSubview:self.cbButton];
    [self.bottomView addSubview:self.czButton];
    [self.bottomView addSubview:self.horLineView];
    [self.bottomView addSubview:self.horLineView2];
    [self.topView addSubview:self.securetLb1];
    [self.topView addSubview:self.securetLb2];
    
    self.bgImgV.image = MyImage(@"资产账户");
    self.assetsTitleLb.text = SSKJLocalized(@"总资产折合（USDT）", nil);
    self.securetLb2.text = self.securetLb1.text = @"******";
    self.assetsLb.text = @"0.00000000";
    self.moneyLb.text = @"≈0.00";
    self.freeLb.text = @"可用 00.00000000";
    self.frozenLb.text = @"冻结 0.00000000";
    [self.eyeBtn setImage:MyImage(@"资产-显示") forState:UIControlStateNormal];
    self.eyeBtn.backgroundColor = [UIColor clearColor];
    [self.cbButton setTitle:SSKJLocalized(@"   充币   ", nil) forState:UIControlStateNormal];
    [self.tbButton setTitle:SSKJLocalized(@"   提币   ", nil) forState:UIControlStateNormal];
    [self.czButton setTitle:SSKJLocalized(@"   充值   ", nil) forState:UIControlStateNormal];
    [self.tbButton setImage:MyImage(@"资产-提币") forState:UIControlStateNormal];
    [self.cbButton setImage:MyImage(@"资产-充币") forState:UIControlStateNormal];
    [self.czButton setImage:MyImage(@"充值") forState:UIControlStateNormal];
    [self.cbButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    [self.tbButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    [self.czButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.tbButton.backgroundColor = self.cbButton.backgroundColor = self.czButton.backgroundColor = [UIColor clearColor];
    for (UILabel *la in self.topView.subviews) {
        if ([la isKindOfClass:[UILabel class]]) {
            la.textColor = kWhiteColor;
            la.font = systemFont(15);
            if (la == self.assetsLb) {
                la.font = systemBoldFont(26);
            }
        }
    }
//    self.shadowView.backgroundColor = [UIColor whiteColor];
    
    self.securetLb1.hidden = self.securetLb2.hidden = YES;
    self.securetLb1.font = self.assetsLb.font;
    self.securetLb2.font = self.moneyLb.font;
//    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.horLineView.backgroundColor = self.horLineView2.backgroundColor = self.bottomLineView.backgroundColor = kLightLineColor;
    
    [self.eyeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.cbButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.tbButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.czButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    _czButton.hidden = _horLineView2.hidden = YES;
    
}
- (void)clickBtn:(UIButton *)sender{
    if (sender == self.eyeBtn) {
        //小眼睛
        sender.selected = !sender.selected;
        self.securetLb1.hidden = self.securetLb2.hidden = !sender.selected;
        self.assetsLb.hidden = self.moneyLb.hidden = sender.selected;
        if (sender.selected) {
            self.freeLb.text = [NSString stringWithFormat:@"%@ ******",SSKJLocalized(@"可用", nil)];
            self.frozenLb.text = [NSString stringWithFormat:@"%@ ******",SSKJLocalized(@"冻结", nil)];
        }else{
            self.freeLb.text = [NSString stringWithFormat:SSKJLocalized(@"可用 %@", nil), [WLTools noroundingStringWith:self.model.balance.doubleValue afterPointNumber:[SSTool MarketNum:@""]]];
            self.frozenLb.text =  [NSString stringWithFormat:SSKJLocalized(@"冻结 %@", nil), [WLTools noroundingStringWith:self.model.frost.doubleValue afterPointNumber:[SSTool MarketNum:@""]]];
        }
        [self.eyeBtn setImage:MyImage(sender.selected ? @"资产-隐藏" : @"资产-显示") forState:UIControlStateNormal];
    }else if (sender == self.cbButton){
        !self.actionBlock? : self.actionBlock(0);
    }else if(sender == self.tbButton){
        !self.actionBlock? : self.actionBlock(1);
    }else{
        !self.actionBlock? : self.actionBlock(2);
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(self).offset(ScaleW(15));
        make.right.mas_equalTo(self).offset(ScaleW(-15));
//        make.height.mas_equalTo(ScaleW(230));
    }];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.top).insets(UIEdgeInsetsZero);
    }];
    [self.assetsTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.topView).offset(ScaleW(20));
    }];
    [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView).offset(ScaleW(-15));
        make.centerY.mas_equalTo(self.assetsTitleLb);
        make.width.height.mas_equalTo(ScaleW(20));
    }];
    [self.assetsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.assetsTitleLb);
        make.top.mas_equalTo(self.assetsTitleLb.mas_bottom).offset(ScaleW(20));
    }];
    [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.assetsLb.mas_left);
        make.top.mas_equalTo(self.assetsLb.mas_bottom).offset(ScaleW(5));
    }];
    
    
    
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(ScaleW(80));
        make.bottom.mas_equalTo(self.mas_bottom).offset(ScaleW(-5));
    }];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bottomView).insets(UIEdgeInsetsZero);
    }];
    [self.cbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.bottomView);
//        make.right.mas_equalTo(self.bottomView.mas_centerX);
        make.width.mas_equalTo(self.bottomView.mas_width).multipliedBy(0.5);
    }];
    
    [self.tbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cbButton.mas_right);
        make.bottom.top.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(self.cbButton);
    }];
    
    [self.czButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tbButton.mas_right);
        make.bottom.top.mas_equalTo(self.bottomView);
        make.right.mas_equalTo(self.bottomView);
    }];
    
    [self.horLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tbButton.mas_centerY);
        make.left.mas_equalTo(self.cbButton.mas_right);
        make.height.mas_equalTo(ScaleW(30));
        make.width.mas_equalTo(ScaleW(1));
    }];
    
    [self.horLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tbButton.mas_centerY);
        make.left.mas_equalTo(self.tbButton.mas_right);
        make.height.mas_equalTo(ScaleW(30));
        make.width.mas_equalTo(ScaleW(1));
    }];
    
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(ScaleW(5));
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    
    [self.freeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moneyLb);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(ScaleW(-17));
    }];
    [self.frozenLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgImgV.mas_right).offset(ScaleW(-15));
        make.centerY.mas_equalTo(self.freeLb);
    }];
    
    
    
    
    
    [self.securetLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.assetsLb).insets(UIEdgeInsetsZero);
    }];
    [self.securetLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.moneyLb).insets(UIEdgeInsetsZero);
    }];
    [self layoutIfNeeded];
//    self.bottomView.backgroundColor = [UIColor greenColor];
//    self.shadowView.backgroundColor = [UIColor redColor];
    [self.bottomView setCornerRadius:10 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    self.bottomView.layer.masksToBounds = NO;
    self.shadowView.layer.masksToBounds = NO;
    self.shadowView.layer.cornerRadius = ScaleW(10);
    self.shadowView.layer.shadowColor = kBlueColor.CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(-5, 0);
    self.shadowView.layer.shadowRadius = ScaleW(5);
    self.shadowView.layer.shadowOpacity = 0.5;
    self.shadowView.layer.masksToBounds = NO;
}






@end
