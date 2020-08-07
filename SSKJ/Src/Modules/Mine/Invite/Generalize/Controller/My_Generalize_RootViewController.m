
//
//  My_Generalize_RootViewController.m
//  ZYW_MIT
//
//  Created by 刘小雨 on 2019/3/29.
//  Copyright © 2019年 Wang. All rights reserved.
//

#import "My_Generalize_RootViewController.h"
#import "My_Generalize_Cell.h"
#import "My_PromoteDetail_ViewController.h"
#import "SSKJ_Protocol_ViewController.h"
#import "My_Yuanli_ViewController.h"
#import "SSKJ_Protocol_ViewController.h"
#import "My_PromoteDetail_Model.h"

#import "SY_InviteViewController.h"
#pragma mark 推广邀请

@interface My_Generalize_RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *tableHeadView;
@property (nonatomic ,strong) UIView *topItemsView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic ,strong) UILabel *totalPeopleLb;
@property (nonatomic ,strong) UILabel *totalMoneyLb;

@property (nonatomic, strong) My_PromoteDetail_Model *detailModel;

@end

@implementation My_Generalize_RootViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = SSKJLanguage(@"邀请返佣");
    
    self.view.backgroundColor = kSubBgColor;
    [self setUI];
    
    [self requestGenerialInfo];
}

#pragma mark - 用户操作

-(NSArray *)dataSource
{
    if (nil == _dataSource)
    {
        _dataSource = [NSMutableArray arrayWithArray:@[SSKJLanguage(@"我的团队"),SSKJLanguage(@"佣金明细"),SSKJLanguage(@"推广海报")]];
    }
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];//
    [self setNavgationBackgroundColor:[UIColor clearColor] alpha:0];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark - ui
-(void)setUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@(ScaleW(290) + Height_StatusBar));
    }];
    [self configHeadView];
//    UILabel *titleLb = [UILabel new];
//    titleLb.text = SSKJLocalized(@"邀请返佣", nil);
//    titleLb.textColor =  kWhiteColor;
//    titleLb.font = systemFont(ScaleW(18));
//    [self.view addSubview:titleLb];
//    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view).offset(Height_StatusBar);
//        make.centerX.mas_equalTo(self.tableView.mas_centerX);
//        make.height.mas_equalTo(44);
//    }];
//    UIButton *backBtn = [[UIButton alloc] init];
//    [backBtn setImage:MyImage(@"邀请-返回") forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(titleLb);
//        make.left.mas_equalTo(self.view).offset(ScaleW(15));
//    }];
        
    UIButton *guizeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScaleW(80), ScaleW(40))];
    [guizeButton setImage:[UIImage imageNamed:@"rule"] forState:UIControlStateNormal];
    [guizeButton setTitle:SSKJLocalized(@"规则", nil) forState:UIControlStateNormal];
    guizeButton.titleLabel.font = systemFont(ScaleW(18));
    [guizeButton setTitleColor:kTitleColor forState:UIControlStateNormal];
    [guizeButton addTarget:self action:@selector(ruleEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:guizeButton];
    // 取出 titleLabel 的宽度
    CGFloat labelWidth02 = [WLTools getWidthWithText:SSKJLocalized(@"规则", nil) font:systemFont(ScaleW(18))] + ScaleW(5);
    // 取出 imageView 的宽度
    CGFloat imageWidth02 = guizeButton.imageView.bounds.size.width;
    // 设置 titleLabel 的内边距
    guizeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth02, 0, imageWidth02);
    // 设置 imageView 的内边距
    guizeButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth02, 0, -labelWidth02);
    
//    [guizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-ScaleW(15));
//        make.centerY.equalTo(backBtn);
//    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:guizeButton];
        
}
- (void) backBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ruleEvent
{
    SSKJ_Protocol_ViewController *vc = [[SSKJ_Protocol_ViewController alloc]init];
    vc.type = @"15";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)configHeadView{
    
    self.tableHeadView = [[UIView alloc] init];
    [self.view addSubview:self.tableHeadView];
    self.tableHeadView.backgroundColor = kSubBgColor;
    [self.tableHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@(ScaleW(300) + Height_StatusBar));
    }];
    UIImageView * topImgView=[UIImageView new];
    topImgView.image = [UIImage imageNamed:@"推广-bg"];
    topImgView.userInteractionEnabled = YES;
    [self.tableHeadView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@(ScaleW(277) + Height_StatusBar));
    }];
    
    self.topItemsView = [UIView new];
    [self.tableHeadView addSubview:self.topItemsView];
    self.topItemsView.backgroundColor = kSubBgColor;
    self.topItemsView.layer.cornerRadius = ScaleW(10);
    self.topItemsView.layer.masksToBounds = NO;
    [self.topItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableHeadView).offset(ScaleW(15));
        make.right.mas_equalTo(self.tableHeadView).offset(ScaleW(-15));
        make.bottom.mas_equalTo(self.tableHeadView.mas_bottom).offset(ScaleW(0));
        make.height.mas_equalTo(ScaleW(128));
    }];
    
    self.topItemsView.layer.cornerRadius = ScaleW(10);
    self.topItemsView.layer.shadowColor = kTitleColor.CGColor;
    self.topItemsView.layer.shadowOffset = CGSizeMake(0, 0);
    self.topItemsView.layer.shadowRadius = ScaleW(10);
    self.topItemsView.layer.shadowOpacity = 0.2;
    
    
    
    UILabel *countLb = [UILabel new];
    UILabel *countTitleLb = [UILabel new];
    UILabel *moneyLb = [UILabel new];
    UILabel *moneyTitleLb = [UILabel new];
    UIView *verLineV = [UIView new];
    
    self.totalPeopleLb = countLb;
    self.totalMoneyLb = moneyLb;
    
    countLb.font = moneyLb.font = systemBoldFont(ScaleW(18));
    countTitleLb.font = moneyTitleLb.font = systemFont(ScaleW(15));
    
    countLb.textColor = moneyLb.textColor = kTitleColor;
    countTitleLb.textColor = moneyTitleLb.textColor = kSubTitleColor;
    
    [self.topItemsView addSubview:countLb];
    [self.topItemsView addSubview:countTitleLb];
    [self.topItemsView addSubview:moneyLb];
    [self.topItemsView addSubview:moneyTitleLb];
    [self.topItemsView addSubview:verLineV];
    
    countTitleLb.textAlignment
    = countLb.textAlignment
    = moneyLb.textAlignment
    = moneyTitleLb.textAlignment = NSTextAlignmentCenter;
    
    [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.topItemsView.mas_width).multipliedBy(0.5);
        make.top.mas_equalTo(self.topItemsView).offset(ScaleW(35));
    }];
    [countTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topItemsView).offset(ScaleW(-35));
        make.centerX.mas_equalTo(countLb);
    }];
    
    [moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.topItemsView.mas_width).multipliedBy(0.5);
        make.centerY.mas_equalTo(countLb);
        make.left.mas_equalTo(countLb.mas_right);
    }];
    [moneyTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(countTitleLb);
        make.centerX.mas_equalTo(moneyLb);
    }];
    
    
    countTitleLb.text = SSKJLocalized(@"我的团队(人)", nil);
    moneyTitleLb.text = SSKJLocalized(@"累计收益(USDT)", nil);
    countLb.text = @"";
    moneyLb.text = @"";
    

}
- (void) topItemsBtnClick:(UIButton *)sender{
    
}
-(UITableView *)tableView
{
    if (nil == _tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kBgColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[My_Generalize_Cell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        WS(weakSelf);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestGenerialInfo];
        }];
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate UITableViewDatsSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleW(50);
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScaleW(20);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    My_Generalize_Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.title = self.dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 2:
        {
            
            SY_InviteViewController *vc = [[SY_InviteViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case 0:
        {
            My_PromoteDetail_ViewController *vc = [[My_PromoteDetail_ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
            
            My_Yuanli_ViewController *vc = [[My_Yuanli_ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}



#pragma mark - 网络请求

-(void)requestGenerialInfo
{
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:ConcessionInfo_URL RequestType:RequestTypeGet Parameters:nil Success:^(NSInteger statusCode, id responseObject)
     {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        WL_Network_Model * netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if (netWorkModel.status.integerValue == SUCCESSED )
        {
            
            [weakSelf analyzeModel:netWorkModel];
        }
        else
        {
            [MBHUD showError:netWorkModel.msg];
        }
        
//        [self.tableView endRefresh];
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        [self.tableView endRefresh];
    }];
    
    
}



-(void)analyzeModel:(WL_Network_Model*)model
{
    
//    [self.headerView setData:model.data];
    
    
    self.totalPeopleLb.text = [NSString stringWithFormat:@"%@", model.data[@"recommends"] ? model.data[@"recommends"] : @"0"];
    self.totalMoneyLb.text = [WLTools noroundingStringWith:[model.data[@"commission"] doubleValue] afterPointNumber:6];
    

}

@end
