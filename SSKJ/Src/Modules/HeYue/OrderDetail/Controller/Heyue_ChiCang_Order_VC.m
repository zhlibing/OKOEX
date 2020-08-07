//
//  Heyue_ChiCang_Order_VC.m
//  SSKJ
//
//  Created by 赵亚明 on 2019/8/3.
//  Copyright © 2019 刘小雨. All rights reserved.
//

#import "Heyue_ChiCang_Order_VC.h"

#import "Heyue_ChiCang_Order_Cell.h"

#import "Heyue_AllPingCang_AlertView.h"//一键平仓 弹框

#import "HeYue_PingCang_AlertView.h"//平仓弹框

#import "HeYue_EditWinLoss_AlertView.h"//修改止盈止损

#import "Heyue_OrderWinLoss_Model.h"//最大最小止盈止损Model

#import "Heyue_OrderDdetail_Model.h"

#import "SSKJ_NoDataView.h"

#import "Heyue_Done_AlertView.h"

#import "Heyue_Leverage_Model.h"

static NSString *ChiCangOrderID = @"ChiCangOrderID";

#define kPageSize @"50"
#define CoinMarketSocket @"CoinSocket"

@interface Heyue_ChiCang_Order_VC ()<UITableViewDelegate,UITableViewDataSource,ManagerSocketDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,strong) UIButton * allBtn;

@property (nonatomic,strong) Heyue_AllPingCang_AlertView *allPingCangAlertView;

@property (nonatomic,strong) HeYue_PingCang_AlertView *pingCangAlertView;

@property (nonatomic,strong) HeYue_EditWinLoss_AlertView *editWinLossAlertView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger index;//如果大于1 加载时不显示菊花

@property (nonatomic,assign) NSInteger seletedIndex;//标记选中个那个Cell  止盈止损时用

@property (nonatomic,strong) Heyue_OrderWinLoss_Model * winLossmodel;//止盈止损Model

@property (nonatomic,strong) ManagerSocket * coinSocket;//币种Socket

@property (nonatomic, strong) Heyue_OrderDdetail_Model *curredntModel;

@property(nonatomic, strong)Heyue_Leverage_Model *leverageModel;
@end

@implementation Heyue_ChiCang_Order_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;

    [self tableView];
    
    [self allBtn];
    
    self.index = 1;
    
    [self requestChiCangOrder_URL];
    
    
    [self openTimer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 通知（进入后台，进入后台）

-(void)applicationDidBecomeActive:(NSNotification *)notification
{
//    [self openSocket];
    
}

-(void)applicationDidEnterBackground:(NSNotification *)notification
{
    
//    [self closeSocket];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启推送
//    [self openSocket];
}
#pragma mark -- Socket --
//打开推送
- (void)openSocket{
    WS(weakSelf);
    
    //成交
    // NSString *type = [WLTools wlDictionaryToJson:@{@"code":self.model.code}];
    //SocketUrl
    self.coinSocket = [[ManagerSocket alloc]initWithUrl:MarketSocketUrl identifier:CoinMarketSocket];
    self.coinSocket.delegate = self;
    [self.coinSocket openConnectSocketWithConnectSuccess:^{
        NSString *type = [WLTools wlDictionaryToJson:@{@"type":@"goods_list_all_lever"}];
        [weakSelf.coinSocket socketSendMsg:type];
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self closetimer];
//    [self closeSocket];
}
//关闭推送
- (void)closeSocket{
    self.coinSocket.delegate = nil;
    [self.coinSocket closeConnectSocket];
    
}
- (void)openTimer{
    if (!self.timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(reloadTimer) userInfo:nil repeats:YES];
    }
}

- (void)closetimer{
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 推送返回的数据
//接收推送数据
-(void)socketDidReciveData:(id)data identifier:(NSString *)identifier{
    if ([identifier isEqualToString:CoinMarketSocket]) {
        NSDictionary *pushGoodsInfoDatas = nil;
        if ([data isKindOfClass:[NSString class]]){
            pushGoodsInfoDatas = [WLTools dictionaryWithJsonString:data];
        }
        else if ([data isKindOfClass:[NSDictionary class]]){
            pushGoodsInfoDatas = data;
        }
        SSKJ_Market_Index_Model *socketModel=[SSKJ_Market_Index_Model mj_objectWithKeyValues:data];
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < self.dataSource.count; i++) {
            Heyue_OrderDdetail_Model *model = self.dataSource[i];
            if ([model.code isEqualToString:socketModel.code]) {
                model.marketPrice = socketModel.price;
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                [tempArr addObject:index];
            }
        }
        if (tempArr.count) {
            [self.tableView reloadRowsAtIndexPaths:tempArr withRowAnimation:(UITableViewRowAnimationNone)];
            [self updateSuperVC];
        }
        //        updateNowPriceUI
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadHeyueChicangCell" object:socketModel];
        //止盈止损弹框更新最新价
        //        if (self.winLossmodel) {
        if ([socketModel.code.lowercaseString isEqualToString:self.curredntModel.code.lowercaseString]) {
            [self.editWinLossAlertView updateNowPriceUI:self.winLossmodel nowPrice:socketModel.price];
        }
        
        //        }
        //平仓价格更新
        //止盈止损弹框更新最新价
        
        if (self.pingCangAlertView) {
            if ([socketModel.code.lowercaseString isEqualToString:self.curredntModel.code.lowercaseString]) {
                [self.pingCangAlertView setMarketPriceView:socketModel.price];
            }
        }
        
        //        if (self.doneAlertView) {
        //            if ([socketModel.code.lowercaseString isEqualToString:self.curredntModel.stockCode.lowercaseString]) {
        //                self.doneAlertView.nePrice = socketModel.price;
        //            }
        //        }
    }
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBgColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScaleW(150))];
//        _tableView.separatorColor = kLightLineColor;
        if (@available(iOS 11.0, *)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[Heyue_ChiCang_Order_Cell class] forCellReuseIdentifier:ChiCangOrderID];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(ScaleW(5)));
            make.left.bottom.right.equalTo(@(ScaleW(0)));
        }];
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf footerRefresh];
//        }];
    }
    return _tableView;
}
#pragma mark - 上拉、下拉
- (void)headerRefresh{
    self.index = 1;
    [self requestChiCangOrder_URL];
}
- (void)footerRefresh{
    [self requestChiCangOrder_URL];
    
}
- (void)reloadTimer{
    self.index++;
    [self requestChiCangOrder_URL];
    
}

//- (void)headerRefreshChiCangOrder_URL{
//    NSDictionary *params = @{
//                             @"stockUserId":kUserID,
//                             @"pageNum":@(1),
//                             @"pageSize":kPageSize,
//                             @"stockCode":self.model.code
//                             };
//    WS(weakSelf);
//    //Heyue_Chicang_Api
//    [[WLHttpManager shareManager] requestWithURL_HTTPCode:URL_HEYUE_DoingList_URL RequestType:RequestTypeGet Parameters:params Success:^(NSInteger statusCode, id responseObject) {
//
//        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
//        if (netModel.status.integerValue == 200) {
////            if ([netModel.data[@"res"] isKindOfClass:[NSArray class]]) {
//            [weakSelf.dataSource removeAllObjects];
//                weakSelf.dataSource = [Heyue_OrderDdetail_Model mj_objectArrayWithKeyValuesArray:netModel.data[@"list"]];
//                if (weakSelf.dataSource.count > 0) {
//                    weakSelf.page = 2;
//                }
//            if ([Heyue_OrderDdetail_Model mj_objectArrayWithKeyValuesArray:netModel.data[@"list"]].count != kPageSize.integerValue) {
//                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//            }else{
//                self.tableView.mj_footer.state = MJRefreshStateIdle;
//            }
//                //止盈止损弹框更新最新价
//                if (self.winLossmodel) {
//                    [weakSelf.editWinLossAlertView setViewWithData:weakSelf.winLossmodel orderDic:self.dataSource[self.seletedIndex]];
//                }
//                [SSKJ_NoDataView showNoData:self.dataSource.count toView:self.tableView offY:0];
//
//                [weakSelf.tableView reloadData];
//
//                [weakSelf endRefresh];
////            }
//        }else{
//            [MBProgressHUD showError:netModel.msg];
//        }
//
//
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
//
//    }];
//}


#pragma mark -- 全部平仓按钮---
- (UIButton *)allBtn{
    if (_allBtn == nil) {
        _allBtn = [WLTools allocButton:nil textColor:nil nom_bg:nil hei_bg:nil frame:CGRectZero];
        _allBtn.cornerRadius = ScaleW(28);
        [_allBtn addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = MyImage(@"");
        
        
        [_allBtn setBackgroundImage:UIImageNamed(SSKJLanguage(@"hy_pingcang")) forState:UIControlStateNormal];
        
        [self.view addSubview:_allBtn];
        [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(ScaleW(-16)));
            make.bottom.equalTo(@(ScaleW(-53)));
            make.width.height.equalTo(@(ScaleW(56)));
            if (Height_NavBar == 88) {
                make.bottom.equalTo(@(ScaleW(-87)));
            }
        }];
    }
    return _allBtn;
}

#pragma mark -- 全部平仓 点击事件 --
- (void)allAction{
    [self.allPingCangAlertView showWithMessage:SSKJLocalized(@"是否确认要全部平仓?", nil)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScaleW(240);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Heyue_ChiCang_Order_Cell *cell = [tableView dequeueReusableCellWithIdentifier:ChiCangOrderID];
    WS(weakSelf);
    
    cell.bottomlineView.hidden = NO;
    if (indexPath.row == self.dataSource.count - 1) {
        cell.bottomlineView.hidden = YES;
    }
    //编辑（修改）
    cell.HeyueEditBlock = ^{
        
        weakSelf.seletedIndex = indexPath.row;
        weakSelf.curredntModel = weakSelf.dataSource[indexPath.row];
//        [weakSelf requestSettingInfoWith:weakSelf.dataSource[indexPath.row]];
        [weakSelf.editWinLossAlertView setViewWithOrderDic:weakSelf.curredntModel];
        [weakSelf.editWinLossAlertView showAlertView];
        
        
    };
    //平仓
    cell.HeyuePingCangBlock = ^{
        weakSelf.curredntModel = weakSelf.dataSource[indexPath.row];
//                [self.doneAlertView initDataWithWeituoModel:weakSelf.dataSource[indexPath.row]];
//                [weakSelf.doneAlertView showAlertView];
       
        [self.pingCangAlertView initDataWithDic:weakSelf.dataSource[indexPath.row]];
        [weakSelf.pingCangAlertView showAlertView];
    };
    cell.chicangModel = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark -- 网络请求 --
- (void)requestChiCangOrder_URL{
    
    [[WLHttpManager shareManager] cancleAllTask];
    [self.timer setFireDate:[NSDate distantFuture]];

    
    MBProgressHUD *hud;
    if (self.index > 1) {
        hud = nil;
    }else{
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    NSDictionary *params = @{
                            @"data_type":@"1",
                             @"page":@"1",
                             };
    WS(weakSelf);
    //Heyue_Chicang_Api
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:URL_HEYUE_DoingList_URL RequestType:RequestTypeGet Parameters:params Success:^(NSInteger statusCode, id responseObject)
    {
        [hud hideAnimated:YES];
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if (netModel.status.integerValue == 200)
        {
            [weakSelf handleExchangeListWithModel:netModel];
        }
        else
        {
            [MBProgressHUD showError:netModel.msg];
        }
        [self endRefresh];

    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [hud hideAnimated:YES];
        [self endRefresh];

    }];
}

-(void)handleExchangeListWithModel:(WL_Network_Model *)net_model
{
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    NSMutableArray *array = [Heyue_OrderDdetail_Model mj_objectArrayWithKeyValuesArray:net_model.data[@"data"]];
    self.dataSource = [NSMutableArray arrayWithArray:array];
    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    WS(weakSelf);
    [UIView performWithoutAnimation:^{
        [weakSelf.tableView reloadData];
    }];
    [self updateSuperVC];
    self.allBtn.hidden = !self.dataSource.count;
    [SSKJ_NoDataView showNoData:self.dataSource.count toView:self.tableView offY:0];
    
    
    for (Heyue_OrderDdetail_Model *model in self.dataSource) {
        if ([model.ID isEqualToString:self.curredntModel.ID] && self.pingCangAlertView.superview != nil) {
            [self.pingCangAlertView setMarketPriceView:model.marketPrice];
        }
        
        if ([model.ID isEqualToString:self.curredntModel.ID] && self.editWinLossAlertView.superview != nil) {
            [self.editWinLossAlertView updateNowPriceUI:model nowPrice:model.marketPrice];
        }
    }
    
}

#pragma mark - 更新父视图数据
- (void)updateSuperVC{
    if (self.updateBlock) {
        self.updateBlock(self.dataSource);
    }
}

-(void)endRefresh
{
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark -- 手动平仓网络请求 --
- (void)request_currentPingcang_URL:(Heyue_OrderDdetail_Model *)model number:(NSString *)number{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{
                             @"order_id":model.ID,
                             @"hands":number
                             };
    WS(weakSelf);
    //Heyue_currentPingcang_Api
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:URL_HEYUE_Done_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject)
    {
        [hud hideAnimated:YES];
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if (netModel.status.integerValue == 200)
        {
            [MBProgressHUD showError:netModel.msg];
            [weakSelf headerRefresh];
        }
        else
        {
            [MBProgressHUD showError:netModel.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [hud hideAnimated:YES];
    }];
}



#pragma mark -- 修改止盈止损请求 --
- (void)requestEditWinLossWithWinStr:(NSString *)winStr lossStr:(NSString *)lossStr{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{
                            @"hold_id":self.curredntModel.ID,
                             @"zy":winStr,
                             @"zs":lossStr
                            };
    
    //Heyue_setPoitLossWin_Api
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:URL_HEYUE_StopPrice_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        
        [hud hideAnimated:YES];
        
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (netModel.status.integerValue == 200) {
            [MBProgressHUD showError:SSKJLocalized(@"修改成功", nil)];
            [self headerRefresh];
        }else{
            [MBProgressHUD showError:netModel.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [hud hideAnimated:YES];
    }];
}


- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark -- 一键平仓 --
- (Heyue_AllPingCang_AlertView *)allPingCangAlertView{
    if (_allPingCangAlertView == nil) {
        _allPingCangAlertView = [[Heyue_AllPingCang_AlertView alloc]initWithFrame:self.view.bounds];
        WS(weakSelf);
        self.allPingCangAlertView.AllPingCangBlock = ^{
            [weakSelf allPingCangRequstion];
        };
    }
    return _allPingCangAlertView;
}
#pragma mark -- 平仓 --
- (HeYue_PingCang_AlertView *)pingCangAlertView{
    if (_pingCangAlertView == nil) {
        _pingCangAlertView = [[HeYue_PingCang_AlertView alloc]initWithFrame:self.view.bounds];
        WS(weakSelf);
        
        _pingCangAlertView.PingCangBlock = ^(NSString * sheets) {
            [weakSelf request_currentPingcang_URL:weakSelf.curredntModel number:sheets];
        };
    }
    return _pingCangAlertView;
}

#pragma mark -- 修改止盈止损 --
- (HeYue_EditWinLoss_AlertView *)editWinLossAlertView{
    if (_editWinLossAlertView == nil) {
        _editWinLossAlertView = [[HeYue_EditWinLoss_AlertView alloc]initWithFrame:self.view.bounds];
        WS(weakSelf);
        _editWinLossAlertView.EditWinLossBlock = ^(NSString * _Nonnull winstr, NSString * _Nonnull lossStr) {
            [weakSelf requestEditWinLossWithWinStr:winstr lossStr:lossStr];
        };
    }
    return _editWinLossAlertView;
}
#pragma mark - 一键平仓请求
- (void)allPingCangRequstion{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WS(weakSelf);
    //Heyue_AllPingcang_Api
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:URL_HEYUE_DoneAll_URL RequestType:RequestTypePost Parameters:nil Success:^(NSInteger statusCode, id responseObject) {
        [hud hideAnimated:YES];
        
        WL_Network_Model *netModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if (netModel.status.integerValue == 200) {
            [weakSelf.allPingCangAlertView removeFromSuperview];
            [MBProgressHUD showError:SSKJLocalized(@"平仓成功", nil)];
            [weakSelf headerRefresh];
        }else{
            [MBProgressHUD showError:SSKJLocalized(@"平仓失败", nil)];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [hud hideAnimated:YES];
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
