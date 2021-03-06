//
//  HeYue_KlineViewController.m
//  SSKJ
//
//  Created by zhao on 2019/8/28.
//  Copyright © 2019 刘小雨. All rights reserved.
//

#import "HeYue_KlineViewController.h"

// controller
#import "SSKJ_TabbarController.h"
#import "HeYue_LeftViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "AppDelegate.h"
// view
#import "ETF_BBTrade_TableHeaderView.h"
#import "ETF_BBTrade_SegmentControl.h"
#import "LXY_KLineView.h"
#import "ETF_BBTrade_IntroductHeaderView.h"
#import "ETF_BBTrade_IntroductView.h"
#import "ETF_Kline_Zhibiao_View.h"
#import "JB_BBTrade_SocketDealOrder_View.h"
#import "ETF_BBTrade_MoreSegment_View.h"

// model
#import "ETF_BBTrade_Introduce_Model.h"

// tools
#import "ManagerSocket.h"
#import "LXY_KLinePositionTool.h"

#import "STO_BB_DepthView.h"
#import "SSKJ_Default_ActionsheetView.h"
#import "SPButton.h"

static NSString *klineSocketIdentifier = @"klineSocketIdentifier";
static NSString *orderSocketIdentifier = @"orderSocketIdentifier";
static NSString *deepSocketIdentifier = @"deepSocketIdentifier";
static NSString *marketSocketIdentifier = @"maekSocketIdentifier";

@interface HeYue_KlineViewController ()<ManagerSocketDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ETF_BBTrade_TableHeaderView *headerView;

@property (nonatomic, strong) ETF_BBTrade_SegmentControl *segmentControl;

@property (nonatomic, strong) LXY_KLineView *kLineView;
@property (nonatomic, strong) ETF_BBTrade_IntroductHeaderView *introductHeaderView;

@property (nonatomic, strong) JB_BBTrade_SocketDealOrder_View *socketOrderView;//成交
@property (nonatomic, strong) ETF_BBTrade_IntroductView *introductView;//简介

@property (nonatomic, strong) ETF_Kline_Zhibiao_View *zhibiaoView;
@property (nonatomic, strong) ETF_BBTrade_MoreSegment_View *moreView;

@property(nonatomic, strong)STO_BB_DepthView *depthView;//深度

@property(nonatomic, strong)NSArray *coinArray;
@property(nonatomic, strong)SPButton *titleBtn;

@property (nonatomic, strong) NSArray *kLineDataArray;

// k线图时间类型
@property (nonatomic, strong) NSString *typeString;


// 币币交易按钮
@property (nonatomic, strong) UIButton *bbTradebutton;

// 行情推送
@property (nonatomic, strong) ManagerSocket *marketSocket;
// k线推送
@property (nonatomic, strong) ManagerSocket *klineSocket;

//// 盘口推送
@property (nonatomic, strong) ManagerSocket *orderSocket;


@property (nonatomic, strong) ManagerSocket *deepthSocket;  // 深度推送

// 币种简介model
@property (nonatomic, strong) ETF_BBTrade_Introduce_Model *introduceModel;

//k线type数据
@property(nonatomic, strong)NSArray *kLineTypeAarray;
@property(nonatomic, strong)NSArray *kLineMoreTypeAarray;

@property(nonatomic, copy)NSString *currentPrice;

@end
@implementation HeYue_KlineViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!self.coinModel.code.length) {
        self.coinModel.code = @"BTC/USDT";
    }
//    self.title = self.coinModel.code;
    
    
//    self.title = SSKJLanguage(@"合约");
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage imageNamed:@"mine_fanhui"] forState:UIControlStateNormal];
//    [backBtn setTitle:[NSString stringWithFormat:@" %@", self.coinModel.code] forState:UIControlStateNormal];
//    [backBtn setTitleColor:kTitleColor forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
    
    //Changed
    UIView *contentView = [UIView new];
    contentView.frame = CGRectMake(0, 0, ScreenWidth, ScaleW(44));
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage imageNamed:@"mine_fanhui"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0, 6, ScaleW(32), ScaleW(32));
//    [contentView addSubview:backBtn];
    
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(ScaleW(0), contentView.centerY - ScaleW(8), ScaleW(1), ScaleW(16));
    lineView.backgroundColor = kSubTitleColor;
    [contentView addSubview:lineView];
    
    SPButton *swcBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    swcBtn.imageTitleSpace = ScaleW(12.5);
    
    swcBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [swcBtn setImage:[UIImage imageNamed:@"hy_unShow"] forState:UIControlStateNormal];
    NSArray *array = [[self.coinModel.code uppercaseString] componentsSeparatedByString:@"_"];
    NSString *str;
    [swcBtn setTitle:self.coinModel.code forState:UIControlStateNormal];

    [swcBtn setTitleColor:kTitleColor forState:UIControlStateNormal];
    [swcBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    swcBtn.frame = CGRectMake(lineView.right + ScaleW(19.5), ScaleW(6), ScaleW(280), ScaleW(32));
    [contentView addSubview:swcBtn];
    self.titleBtn = swcBtn;
    self.navigationItem.titleView = contentView;

    self.typeString = @"minute";
    [self setUI];
    
}

- (void)leftClick {
    //是否是时间合约
    
    HeYue_LeftViewController *vc = [[HeYue_LeftViewController alloc]init];
    CWLateralSlideConfiguration *config = [[CWLateralSlideConfiguration alloc]initWithDistance:ScreenWidth * 0.8 maskAlpha:0.6 scaleY:1 direction:CWDrawerTransitionFromLeft backImage:nil];
    WS(weakSelf);
    vc.selectCoinBlock = ^(SSKJ_Market_Index_Model * _Nonnull coinModel) {
        weakSelf.coinModel = coinModel;
        [weakSelf refreshCodeDate];
        
    };
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:config];
}

#pragma mark - 更新币种
- (void)refreshCodeDate{
    

    [self updatePageInfo];
    
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self updatePageInfo];
}

-(void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self closeSocket];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [self updatePageInfo];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

    [self closeSocket];
}

#pragma mark - 更新页面信息
- (void)updatePageInfo{
    
    if (!self.coinModel.code.length) {
        return;
    }
    NSArray *array = [self.coinModel.code componentsSeparatedByString:@"/"];
    NSString *str;
    
    [self.titleBtn setTitle:[[self.coinModel.code uppercaseString] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] forState:UIControlStateNormal];
    
    [LXY_KLinePositionTool setCoin:self.coinModel.code];
    [self requestKlineData];
    [self requestDeepData];
    [self requestDealData];
    [self requstWithInstrolHttpRequst];
    [self closeSocket];
    [self openSocket];
    
}


#pragma mark - socket


-(ManagerSocket *)marketSocket
{
    if (nil == _marketSocket) {
        //SocketUrl
        _marketSocket = [[ManagerSocket alloc]initWithUrl:MarketSocketUrl identifier:marketSocketIdentifier];
    }
    return _marketSocket;
}

-(ManagerSocket *)klineSocket
{
    if (nil == _klineSocket) {
        //SocketUrl
        _klineSocket = [[ManagerSocket alloc]initWithUrl:MarketSocketUrl identifier:klineSocketIdentifier];
    }
    return _klineSocket;
}


-(ManagerSocket *)orderSocket
{
    if (nil == _orderSocket) {
        //shiShiChengJiaoSocketUrl
        _orderSocket = [[ManagerSocket alloc]initWithUrl:MarketSocketUrl identifier:orderSocketIdentifier];
    }
    return _orderSocket;
}

-(ManagerSocket *)deepthSocket
{
    if (nil == _deepthSocket) {
        //shenDuSocketUrl
        _deepthSocket = [[ManagerSocket alloc]initWithUrl:MarketSocketUrl identifier:deepSocketIdentifier];
    }
    return _deepthSocket;
}


-(void)openSocket
{
    [self openMarketSocket];
    [self openOrderSocket];
    [self openDeepSocket];
    [self openKlineSocket];
}

-(void)closeSocket
{
    [self closeMarketSocket];
    [self closeOrderSocket];
    [self closeDeepSocket];
    [self closeKlineSocket];
}



-(void)openMarketSocket
{
    WS(weakSelf);
    if (!self.marketSocket.socketIsConnected) {
        self.marketSocket.delegate = self;
        [self.marketSocket openConnectSocketWithConnectSuccess:^{
            NSString *string = [NSString stringWithFormat:@"ticker@%@",weakSelf.coinModel.code];
            NSString *type = [WLTools wlDictionaryToJson:@{@"sub":string}];
            [weakSelf.marketSocket socketSendMsg:type];
            [weakSelf.marketSocket startSendHeartTimer];
        }];
    }
}


-(void)openOrderSocket
{
    WS(weakSelf);
    if (!self.orderSocket.socketIsConnected) {
        self.orderSocket.delegate = self;
        [self.orderSocket openConnectSocketWithConnectSuccess:^{
            NSString *string = [NSString stringWithFormat:@"trader@%@",weakSelf.coinModel.code];
            NSString *type = [WLTools wlDictionaryToJson:@{@"sub":string}];
            [weakSelf.orderSocket socketSendMsg:type];
            [weakSelf.orderSocket startSendHeartTimer];
        }];
    }
}


-(void)openDeepSocket{
    if (!self.deepthSocket.socketIsConnected) {
        self.deepthSocket.delegate = self;
        WS(weakSelf);
        [self.deepthSocket openConnectSocketWithConnectSuccess:^{
            NSString *string = [NSString stringWithFormat:@"pct@%@",weakSelf.coinModel.code];
            NSString *type = [WLTools wlDictionaryToJson:@{@"sub":string}];
            [weakSelf.deepthSocket socketSendMsg:type];
            [weakSelf.deepthSocket startSendHeartTimer];

        }];
    }
}




-(void)openKlineSocket{
    
    [self closeKlineSocket];
    WS(weakSelf);
    if (!self.klineSocket.socketIsConnected)
    {
        self.klineSocket.delegate = self;
        [self.klineSocket openConnectSocketWithConnectSuccess:^{
            NSString *str = [self getCurrentModel].typeString;
            NSString *minute;
            if ([str isEqualToString:@"minute1"])
            {
                         minute = @"1";
            }
            if ([str isEqualToString:@"minute5"])
            {
                         minute = @"5";
             }
            if ([str isEqualToString:@"minute15"])
            {
                         minute = @"15";
             }
            if ([str isEqualToString:@"minute30"])
            {
                         minute = @"30";
             }
            if ([str isEqualToString:@"minute60"])
            {
                         minute = @"60";
             }
            if ([str isEqualToString:@"hour4"])
            {
                         minute = @"240";
             }
            if ([str isEqualToString:@"day"])
            {
                         minute = @"1440";
             }
            if ([str isEqualToString:@"week"])
            {
                         minute = @"10080";
             }
            if ([str isEqualToString:@"month"])
            {
                         minute = @"43200";
                
            }
        
            NSString *string = [NSString stringWithFormat:@"ticker@%@",weakSelf.coinModel.code];
            
            NSString *type = [WLTools wlDictionaryToJson:@{@"sub":string}];
            [weakSelf.klineSocket socketSendMsg:type];
            [weakSelf.klineSocket startSendHeartTimer];

        }];
    }
}

-(void)closeMarketSocket{
    if (self.marketSocket.socketIsConnected) {
        self.marketSocket.delegate = nil;
        [self.marketSocket closeConnectSocket];
    }
}

-(void)closeOrderSocket{
    if (self.orderSocket.socketIsConnected) {
        self.orderSocket.delegate = nil;
        [self.orderSocket closeConnectSocket];
    }
    
}

-(void)closeDeepSocket{
    if (self.deepthSocket.socketIsConnected) {
        [self.deepthSocket closeConnectSocket];
        self.deepthSocket.delegate = nil;
    }
}

-(void)closeKlineSocket{
    if (self.klineSocket.socketIsConnected) {
        self.klineSocket.delegate = nil;
        [self.klineSocket closeConnectSocket];
    }
    
}

#pragma mark - 用户操作

-(void)segmentSelectIndex:(NSInteger)index
{
    if (self.zhibiaoView.superview) {
        [self.zhibiaoView removeFromSuperview];
    }
    
    if (self.moreView.superview) {
        [self.moreView removeFromSuperview];
    }

    [self requestKlineData];
    [self openKlineSocket];
}



-(void)moreSegmentSelectIndex:(NSInteger)index
{
    [self requestKlineData];
    [self openKlineSocket];
}

#pragma mark 跳转合约交易
-(void)toBBTradeEvent
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didGetCoinModel" object:self.coinModel];

    if (self.isNeedPop)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        SSKJ_TabbarController *tabbVc = (SSKJ_TabbarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tabbVc.selectedIndex = 2;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 请求深度数据
-(void)requestDeepData
{
    NSDictionary *dict=@{
                         @"code":self.coinModel.code,
                         @"type":@"pct"
                         };
    
    
    WS(weakSelf);
 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //Get_shendu_URL
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:BI_BBCoinDeep_URL RequestType:RequestTypeGet Parameters:dict Success:^(NSInteger statusCode, id responseObject)
     {
         [hud hideAnimated:YES];

         WL_Network_Model *network_Model=[WL_Network_Model mj_objectWithKeyValues:responseObject];
         if (network_Model.status.integerValue == SUCCESSED)
         {
             [weakSelf.depthView setDeepData:network_Model.data];
             if (weakSelf.introductHeaderView.selectedIndex == 0)
             {
                 weakSelf.scrollView.contentSize = CGSizeMake(ScreenWidth, self.depthView.bottom + ScaleW(60));
             }
         }else{
             [MBProgressHUD showError:network_Model.msg];
         }
         
     } Failure:^(NSError *error, NSInteger statusCode, id responseObject)
     {
         [hud hideAnimated:YES];

         [MBProgressHUD showError:SSKJLocalized(@"网络异常", nil)];
     }];
    
}

#pragma mark 请求实时成交数据

-(void)requestDealData
{
    NSDictionary *dict=@{
                         @"code":self.coinModel.code
                         };
    
    WS(weakSelf);
    
    //Heyue_ShiShiChengjiao_Api
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:BI_BBKTransaction_URL RequestType:RequestTypeGet Parameters:dict Success:^(NSInteger statusCode, id responseObject)
     {
         
         WL_Network_Model *network_Model=[WL_Network_Model mj_objectWithKeyValues:responseObject];
         if (network_Model.status.integerValue == SUCCESSED)
         {
             NSArray *array = [JB_BBTrade_SocketDealOrder_Model mj_objectArrayWithKeyValuesArray:network_Model.data[@"data"]];
             for (JB_BBTrade_SocketDealOrder_Model *mode in array) {
                 mode.income = mode.amount;
                 mode.type = mode.dc;
                 mode.selltime = mode.dt;
                 mode.sellprice = mode.price;
                 mode.code = weakSelf.coinModel.code;

             }
             
             weakSelf.socketOrderView.dataSource = array;
             weakSelf.socketOrderView.coinModel = weakSelf.coinModel;
             
             if (weakSelf.introductHeaderView.selectedIndex == 1) {
                 weakSelf.scrollView.contentSize = CGSizeMake(ScreenWidth, self.socketOrderView.bottom + ScaleW(60));
             }
         }else{
             [MBProgressHUD showError:network_Model.msg];
         }
         
     } Failure:^(NSError *error, NSInteger statusCode, id responseObject)
     {
         [MBProgressHUD showError:SSKJLocalized(@"网络异常", nil)];
     }];
    
}
#pragma mark 请求k线数据
-(void)requestKlineData
{
    NSDictionary *dict=@{
                        @"goodsType":self.typeString,
                         @"code":self.coinModel.code,
                         @"pageSize":@(500)
                         };
    
    
    WS(weakSelf);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //HY_HistoryData
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:BI_BBKline_URL RequestType:RequestTypeGet Parameters:dict Success:^(NSInteger statusCode, id responseObject)
     {
         [hud hideAnimated:YES];

         WL_Network_Model *network_Model=[WL_Network_Model mj_objectWithKeyValues:responseObject];
//         [CMRemind dismiss];
         if (network_Model.status.integerValue == SUCCESSED)
         {
             weakSelf.kLineDataArray=network_Model.data;
             
             [weakSelf setKlineView];
         }else{
             [MBProgressHUD showError:network_Model.msg];
         }
         
     } Failure:^(NSError *error, NSInteger statusCode, id responseObject)
     {
//         [CMRemind dismiss];
         
         [hud hideAnimated:YES];
         [MBProgressHUD showError:SSKJLocalized(@"网络异常", nil)];
     }];
    
}

-(void)setKlineView
{
    
    kLineTypeModel *model = [self getCurrentModel];
    
    [self.kLineView setData:self.kLineDataArray klineType:model.viewType timeFormatter:model.timeFormatter];
    
}

#pragma mark - 获取当前kLine model
- (kLineTypeModel *)getCurrentModel{
    kLineTypeModel *model;
    if(self.segmentControl.selectedIndex == self.kLineTypeAarray.count){
        model = self.kLineMoreTypeAarray[self.moreView.selectedIndex];
    }else{
        model = self.kLineTypeAarray[self.segmentControl.selectedIndex];
    }
    return model;
}

- (NSString *)typeString{
    return [self getCurrentModel].typeString;
}

#pragma mark - 长连接收到推送数据
-(void)socketDidReciveData:(id)data identifier:(NSString *)identifier
{
    
    kLineTypeModel *currentModel = [self getCurrentModel];
    
    NSDictionary *dic = (NSDictionary *)data;
    
    if ([identifier isEqualToString:marketSocketIdentifier]) {
        SSKJ_Market_Index_Model *socketModel = [SSKJ_Market_Index_Model mj_objectWithKeyValues:dic];
        self.headerView.coinModel = socketModel;
        
        if (socketModel.change.doubleValue < 0) {
            self.bbTradebutton.backgroundColor = KRedColor;
        }else{
            self.bbTradebutton.backgroundColor = KgreenColor;
        }

    }
    else if ([identifier isEqualToString:klineSocketIdentifier])
    {
                
        if ([dic[@"code"] isEqualToString:self.coinModel.code])
        {
            LXY_KLine_DataModel *model = [LXY_KLine_DataModel mj_objectWithKeyValues:dic];
            
            model.high = dic[@"high"];
            model.low = dic[@"low"];
            model.open = dic[@"open"];
            model.close = [dic[@"close"] stringValue];
            model.price = [dic[@"close"] stringValue];
            model.timestamp =  dic[@"timestamp"];
            [self.kLineView refreshWithSocketData:model minuteInvital:currentModel.minute];
            [self.kLineView setCurrentPrice:model.price];
        }
                
    }
    else if ([identifier isEqualToString:orderSocketIdentifier]){
        
        if (self.introductHeaderView.selectedIndex == 1) {
            NSArray *array = [JB_BBTrade_SocketDealOrder_Model mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            for (JB_BBTrade_SocketDealOrder_Model *mode in array) {
                mode.income = mode.amount;
                mode.type = mode.dc;
                mode.selltime = mode.dt;
                mode.sellprice = mode.price;
                mode.code = dic[@"code"];
                
            }
            self.socketOrderView.dataSource = array;
            self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.socketOrderView.bottom + ScaleW(60));
        }
    }else if ([identifier isEqualToString:deepSocketIdentifier]) {

        if (self.introductHeaderView.selectedIndex == 0) {
            [self.depthView setDeepData:dic];
            self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.depthView.bottom + ScaleW(60));
        }
    }
    
}



-(NSDictionary *)dicWithData:(id)data
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *singleGoodsDatas = nil;
    if ([data isKindOfClass:[NSString class]]) {
        singleGoodsDatas = [self dictionaryWithJsonString:data];
        dic = [singleGoodsDatas mutableCopy];
    } else if ([data isKindOfClass:[NSDictionary class]])
    {
        singleGoodsDatas = data;
        NSString *goodsCode = [WLTools stringTransformObject:[singleGoodsDatas objectForKey:@"code"]];
        [dic setObject:singleGoodsDatas forKey:goodsCode];
    }
    return dic;
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSString *newJsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    
    newJsonString = [newJsonString stringByReplacingOccurrencesOfString:@"}{" withString:@"},{"];
    
    NSData *jsonData = [newJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    if(err) {
        return nil;
    }
    return array.firstObject;
}




#pragma mark - 请求币种简介

-(void)requstWithInstrolHttpRequst
{
    NSMutableDictionary *pamaDic = [NSMutableDictionary dictionary];
    [pamaDic setObject:self.coinModel.code forKey:@"code"];
    WS(weakSelf);
    //ETF_BBTrade_CoinIntroduce_URL
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_BBCoinInfo_URL RequestType:(RequestTypeGet) Parameters:pamaDic Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *network_Model=[WL_Network_Model mj_objectWithKeyValues:responseObject];
        if (network_Model.status.integerValue == 200) {
            
            NSDictionary *dataDic = network_Model.data;
            
            ETF_BBTrade_Introduce_Model *currentModel = [ETF_BBTrade_Introduce_Model mj_objectWithKeyValues:dataDic];
            weakSelf.introduceModel = currentModel;
            //            weakSelf.introduceModel.name = _model.name;
            [weakSelf.introductView setViewWithModel:currentModel];
            
            if (self.introductHeaderView.selectedIndex == 2) {
                self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.introductView.bottom + ScaleW(60));
            }
            
        }else{
            [MBProgressHUD showError:network_Model.msg];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        [MBProgressHUD showError:SSKJLocalized(@"网络异常", nil)];
    }];
}

#pragma mark - UI
-(void)setUI
{
    
    self.view.backgroundColor = kBgColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.segmentControl];
    [self.scrollView addSubview:self.kLineView];
    [self.scrollView addSubview:self.introductHeaderView];
    [self.scrollView addSubview:self.depthView];
    [self.scrollView addSubview:self.socketOrderView];
    [self.scrollView addSubview:self.introductView];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.depthView.bottom + ScaleW(60));
    [self.view addSubview:self.bbTradebutton];
    
    self.scrollView.height = ScreenHeight - Height_NavBar;
    
    
}



-(UIScrollView *)scrollView
{
    if (nil == _scrollView) {
        CGFloat bottomH = ScaleW(65);
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - bottomH - Height_NavBar)];
        _scrollView.backgroundColor = kBgColor;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}


-(ETF_BBTrade_TableHeaderView *)headerView
{
    if (nil == _headerView) {
        _headerView = [[ETF_BBTrade_TableHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScaleW(105))];
        _headerView.coinModel = self.coinModel;
    }
    return _headerView;
}


-(ETF_BBTrade_SegmentControl *)segmentControl
{
    if (nil == _segmentControl) {
        NSMutableArray *titles = [NSMutableArray array];
        for (kLineTypeModel *model in self.kLineTypeAarray) {
            [titles addObject:model.title];
        }
        [titles addObject:SSKJLanguage(@"更多")];
        [titles addObject:SSKJLanguage(@"指标")];
        
        _segmentControl = [[ETF_BBTrade_SegmentControl alloc]initWithFrame:CGRectMake(0, self.headerView.bottom, ScreenWidth, ScaleW(45)) titles:titles normalColor:kTitleColor selectedColor:kBlueColor fontSize:ScaleW(13)];
        _segmentControl.backgroundColor = kBgColor;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(ScaleW(15), 0, _segmentControl.width -ScaleW(30), 1)];
        lineView.backgroundColor = kSubBgColor;
        [_segmentControl addSubview:lineView];
        WS(weakSelf);
        _segmentControl.selectedIndexBlock = ^(NSInteger index) {
            [weakSelf segmentSelectIndex:index];
        };
        _segmentControl.zhibiaoBlock = ^{
            if (weakSelf.zhibiaoView.superview) {
                [weakSelf.zhibiaoView removeFromSuperview];
            }else{
                [weakSelf.scrollView addSubview:weakSelf.zhibiaoView];
            }
            
            if (weakSelf.moreView.superview) {
                [weakSelf.moreView removeFromSuperview];
            }
        };
        
        
        _segmentControl.moreBlock = ^{
            if (weakSelf.moreView.superview) {
                [weakSelf.moreView removeFromSuperview];
            }else{
                [weakSelf.scrollView addSubview:weakSelf.moreView];
            }
            if (weakSelf.zhibiaoView.superview) {
                [weakSelf.zhibiaoView removeFromSuperview];
            }
        };
        
    }
    return _segmentControl;
}

-(LXY_KLineView *)kLineView
{
    if (nil == _kLineView) {
        _kLineView = [[LXY_KLineView alloc]initWithFrame:CGRectMake(0, self.segmentControl.bottom + ScaleW(3), ScreenWidth, ScaleW(328)) accessoryType:LXY_ACCESSORYTYPENONE mainAccessoryType:LXY_KMAINACCESSORYTYPEMA];
    }
    return _kLineView;
}

-(ETF_BBTrade_IntroductHeaderView *)introductHeaderView
{
    if (nil == _introductHeaderView) {
        _introductHeaderView = [[ETF_BBTrade_IntroductHeaderView alloc]initWithFrame:CGRectMake(0, self.kLineView.bottom + ScaleW(5), ScreenWidth, ScaleW(40))];
        [_introductHeaderView changeUI];
        
        
        WS(weakSelf);
        _introductHeaderView.segmentSelectBlock = ^(NSInteger index) {
            if (index == 1) {
                weakSelf.depthView.hidden = YES;
                weakSelf.socketOrderView.hidden = NO;
                weakSelf.introductView.hidden = YES;
                weakSelf.scrollView.contentSize = CGSizeMake(ScreenWidth, weakSelf.socketOrderView.bottom + ScaleW(60));
            }else if (index == 2) {
                weakSelf.depthView.hidden = YES;
                weakSelf.socketOrderView.hidden = YES;
                weakSelf.introductView.hidden = NO;
                weakSelf.scrollView.contentSize = CGSizeMake(ScreenWidth, weakSelf.introductView.bottom + ScaleW(60));
                
            }else{
                weakSelf.depthView.hidden = NO;
                weakSelf.socketOrderView.hidden = YES;
                weakSelf.introductView.hidden = YES;
                weakSelf.scrollView.contentSize = CGSizeMake(ScreenWidth, weakSelf.depthView.bottom + ScaleW(60));
            }
        };
    }
    return _introductHeaderView;
}

-(ETF_BBTrade_IntroductView *)introductView
{
    if (nil == _introductView) {
        _introductView = [[ETF_BBTrade_IntroductView alloc]initWithFrame:CGRectMake(0, self.introductHeaderView.bottom, ScreenWidth, ScaleW(200))];
        _introductView.hidden = YES;
    }
    return _introductView;
}

- (STO_BB_DepthView *)depthView{
    
    if (!_depthView) {
        _depthView = [[STO_BB_DepthView alloc] initWithFrame:CGRectMake(0, self.introductHeaderView.bottom, ScreenWidth, ScaleW(250))];
    }
    return _depthView;
}


-(JB_BBTrade_SocketDealOrder_View *)socketOrderView
{
    if (nil == _socketOrderView) {
        _socketOrderView = [[JB_BBTrade_SocketDealOrder_View alloc]initWithFrame:CGRectMake(0, self.introductHeaderView.bottom, ScreenWidth, 0)];
        _socketOrderView.coinModel = self.coinModel;
       _socketOrderView.isFromGangGan = YES;
        _socketOrderView.hidden = YES;
    }
    return _socketOrderView;
}

-(ETF_Kline_Zhibiao_View *)zhibiaoView
{
    if (nil == _zhibiaoView) {
        _zhibiaoView = [[ETF_Kline_Zhibiao_View alloc]initWithFrame:CGRectMake(ScaleW(5), self.segmentControl.bottom, ScreenWidth - ScaleW(10), ScaleW(100))];
        WS(weakSelf);
        _zhibiaoView.selectMainAccessoryBlock = ^(LXY_KMAINACCESSORYTYPE mainAccessoryType) {
            weakSelf.kLineView.mainAccessoryType = mainAccessoryType;
        };
        
        
        _zhibiaoView.selectSubAccessoryBlock = ^(LXY_ACCESSORYTYPE accessoryType) {
            weakSelf.kLineView.accessoryType = accessoryType;
        };
    }
    return _zhibiaoView;
}


-(ETF_BBTrade_MoreSegment_View *)moreView
{
    if (nil == _moreView) {
        _moreView = [[ETF_BBTrade_MoreSegment_View alloc]initWithFrame:CGRectMake(0, self.segmentControl.bottom, ScreenWidth, ScaleW(40))];
        
        NSMutableArray *titles = [NSMutableArray array];
        for (kLineTypeModel *model in self.kLineMoreTypeAarray) {
            [titles addObject:model.title];
        }
        _moreView.titlesArray = titles;
        
        WS(weakSelf);
        _moreView.selectBlock = ^(NSInteger index, NSString * _Nonnull title) {
            [weakSelf.moreView removeFromSuperview];
            [weakSelf.segmentControl setMoreWithTitle:title];
            [weakSelf moreSegmentSelectIndex:index];
        };
    }
    return _moreView;
}

-(UIButton *)bbTradebutton
{
    if (nil == _bbTradebutton) {
        _bbTradebutton = [[UIButton alloc]initWithFrame:CGRectMake(ScaleW(15), self.view.height - ScaleW(55), ScreenWidth - ScaleW(30), ScaleW(45))];
        [_bbTradebutton setTitle:SSKJLocalized(@"合约交易", nil) forState:UIControlStateNormal];
        [_bbTradebutton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _bbTradebutton.titleLabel.font = systemFont(ScaleW(15));
        _bbTradebutton.layer.masksToBounds = YES;
        _bbTradebutton.layer.cornerRadius = ScaleW(4);
        if (self.coinModel.change.doubleValue < 0) {
            _bbTradebutton.backgroundColor = KRedColor;
        }else{
            _bbTradebutton.backgroundColor = KgreenColor;
        }
        [_bbTradebutton addTarget:self action:@selector(toBBTradeEvent) forControlEvents:UIControlEventTouchUpInside];
//        [_bbTradebutton addGradientColor];
    }
    return _bbTradebutton;
}

-(SSKJ_Market_Index_Model *)coinModel
{
    if (!_coinModel) {
        _coinModel = [[SSKJ_Market_Index_Model alloc]init];
    }
    return _coinModel;
}

- (NSArray *)kLineTypeAarray{
    if (!_kLineTypeAarray) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < 6; i++) {
            kLineTypeModel * model = [kLineTypeModel new];
            [array addObject:model];
            switch (i) {
                case 0:
                    model.type = kLineTypeNone;
                    break;
                case 1:
                    model.type = kLineTypeMinute;
                    break;
                case 2:
                    model.type = kLineTypeMinute5;
                    break;
                case 3:
                    model.type = kLineTypeMinute15;
                    break;
                case 4:
                    model.type = kLineTypeMinute30;
                    break;
                case 5:
                    model.type = kLineTypeDay;
                    break;
                default:
                    break;
            }
        }
        _kLineTypeAarray = [array copy];
    }
    return _kLineTypeAarray;
}


- (NSArray *)kLineMoreTypeAarray{
    if (!_kLineMoreTypeAarray) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < 4; i++) {
            kLineTypeModel * model = [kLineTypeModel new];
            [array addObject:model];
            switch (i) {
                case 0:
                    model.type = kLineTypeMinute60;
                    break;
                case 1:
                    model.type = kLineTypeHour4;
                    break;
                case 2:
                    model.type = kLineTypeWeek;
                    break;
                case 3:
                    model.type = kLineTypeMonth;
                    break;
                default:
                    break;
            }
        }
        _kLineMoreTypeAarray = [array copy];
    }
    return _kLineMoreTypeAarray;
}



@end



@implementation kLineTypeModel
/*
 K线类型（minute，minute5，minute15，minute30，minute60，day，hour4，week，month）
 
 @property(nonatomic, copy)NSString *title;
 @property(nonatomic, copy)NSString *typeString;
 @property(nonatomic, copy)NSString *timeFormatter;
 @property(nonatomic)NSInteger minute;
 */


- (void)setType:(kLineType)type{
    _type = type;
    
    self.viewType = 1;
    
    if (type == kLineTypeNone) {
        self.title = SSKJLanguage(@"分时");
        self.typeString = @"minute1";
//        self.typeString = @"1";
        self.timeFormatter = @"HH:mm";
        self.minute = 1;
        self.viewType = 0;
    }else if (type == kLineTypeMinute){
        self.title = SSKJLanguage(@"1M");
        self.typeString = @"minute1";
//        self.typeString = @"1";
        self.timeFormatter = @"HH:mm";
        self.minute = 1;
    }else if (type == kLineTypeMinute5){
        self.title = SSKJLanguage(@"5M");
        self.typeString = @"minute5";
//        self.typeString = @"5";
        self.timeFormatter = @"HH:mm";
        self.minute = 5;
    }else if (type == kLineTypeMinute15){
        self.title = SSKJLanguage(@"15M");
        self.typeString = @"minute15";
//        self.typeString = @"15";
        self.timeFormatter = @"HH:mm";
        self.minute = 15;
    }else if (type == kLineTypeMinute30){
        self.title = SSKJLanguage(@"30M");
        self.typeString = @"minute30";
//        self.typeString = @"30";
        self.timeFormatter = @"HH:mm";
        self.minute = 30;
    }else if (type == kLineTypeMinute60){
//        self.title = SSKJLanguage(@"60M");
        self.title = @"1H";
        self.typeString = @"minute60";
//        self.typeString = @"60";
        self.timeFormatter = @"HH:mm";
        self.minute = 60;
    }else if (type == kLineTypeHour4){
        self.title = SSKJLanguage(@"4H");
        self.typeString = @"4hour";
//        self.typeString = @"240";

        self.timeFormatter = @"HH:mm";
        self.minute = 240;
    }else if (type == kLineTypeDay){
        self.title = SSKJLanguage(@"日线");
        self.typeString = @"day";
//        self.typeString = @"1440";

        self.timeFormatter = @"MM-dd";
        self.minute = 24 * 60;
    }else if (type == kLineTypeWeek){
        self.title = SSKJLanguage(@"周线");
        self.typeString = @"week";
//        self.typeString = @"10080";
        self.timeFormatter = @"MM-dd";
        self.minute = 24 * 60 * 7;
    }else if (type == kLineTypeMonth){
        self.title = SSKJLanguage(@"月线");
        self.typeString = @"month";
//        self.typeString = @"43200";

        self.timeFormatter = @"yy-MM";
        self.minute = 24 * 60 * 30;
    }
}


@end


