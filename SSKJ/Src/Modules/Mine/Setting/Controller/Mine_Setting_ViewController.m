//
//  BI_Setting_ViewController.m
//  SSKJ
//
//  Created by 刘小雨 on 2019/6/19.
//  Copyright © 2019年 刘小雨. All rights reserved.
//

#import "Mine_Setting_ViewController.h"
#import "SSKJ_Default_ActionsheetView.h"
#import "Mine_ChangeLanguage_ViewController.h"
#import "Setting_TableViewCell.h"
#import "AppDelegate.h"
#import "Mine_Version_AlertView.h"
#import "SSKJ_Default_AlertView.h"
#import "LoginViewController.h"

#define kPageSize @"10"

static NSString *cellid = @"Setting_TableViewCell";
@interface Mine_Setting_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *sunTitleArray;

@property (nonatomic, strong) UIView *logOutView;

@property (nonatomic, strong) Mine_Version_Model *versionModel;

@property(nonatomic, strong)NSDictionary *languageDic;
@property(nonatomic, strong)NSArray *languageArray;
@end

@implementation Mine_Setting_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = SSKJLocalized(@"设置", nil);
    self.titleArray = @[SSKJLocalized(@"切换语言", nil),SSKJLocalized(@"当前版本", nil)];
    
    
    self.languageDic = @{@"zh-Hans":@"简体中文",
                         @"en":@"English",
                         };
    
    self.languageArray = @[@"简体中文", @"English"];
    
    
    NSString *language = [self.languageDic valueForKey:[[SSKJLocalized sharedInstance]currentLanguage]];
    
    self.sunTitleArray = [NSMutableArray arrayWithArray:@[language,[NSString stringWithFormat:@"%@  %@",SSKJLocalized(@"当前版本", nil),kAppVersion]]];
     [self setUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!kLogin){
        [self.logOutView setHidden:true];
    }
}


#pragma mark - Getter / Setter
-(void)setUI
{
//    self.view.backgroundColor=kLineColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logOutView];
    
}

-(UITableView *)tableView
{
    if (nil == _tableView) {
        
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScaleW(110)) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[Setting_TableViewCell class] forCellReuseIdentifier:cellid];
        if (@available(iOS 11.0, *))
        {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 10;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        
        _tableView.separatorColor = kBgColor;
        
        _tableView.backgroundColor = kBgColor;
        
        _tableView.contentInset = UIEdgeInsetsMake(ScaleW(10), 0, 0, 0);
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
               
    }
    return _tableView;
}

-(UIView *)logOutView
{
    if (nil == _logOutView) {
        _logOutView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - ScaleW(45) - ScaleW(30), ScreenWidth, ScaleW(45))];
        UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(ScaleW(15), ScaleW(0), ScreenWidth - ScaleW(30), ScaleW(45))];
        [logoutButton setTitle:SSKJLocalized(@"退出登录", nil) forState:UIControlStateNormal];
        logoutButton.backgroundColor = kBlueColor;
        [logoutButton setTitleColor:kTitleColor forState:UIControlStateNormal];
        logoutButton.titleLabel.font = systemFont(ScaleW(15));
        logoutButton.layer.masksToBounds = YES;
        logoutButton.layer.cornerRadius = ScaleW(5);
//        logoutButton.hidden = YES;
        [logoutButton addTarget:self action:@selector(logoutEvent) forControlEvents:UIControlEventTouchUpInside];
        [_logOutView addSubview:logoutButton];
    }
    return _logOutView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleW(50);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Setting_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
    NSString *title = self.titleArray[indexPath.row];
    NSString *subTitle = self.sunTitleArray[indexPath.row];
    cell.nameLabel.text = title;
    cell.subTextLabel.text = subTitle;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        #pragma mark case 0 版本更新
        case 1:
        {
            [self checkVersion];
        }
            break;
        #pragma mark case 1 语言
        case 0:
        {
            
            Mine_ChangeLanguage_ViewController *vc = [[Mine_ChangeLanguage_ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
            WS(weakSelf);
            [SSKJ_Default_ActionsheetView showWithItems:self.languageArray title:@"" selectedIndexBlock:^(NSInteger selectIndex) {
                
                NSString *title = self.languageArray[selectIndex];
                
                NSString *language = [self.languageDic valueForKey:[[SSKJLocalized sharedInstance] currentLanguage]];
                
                if ([title isEqualToString:language]) {
                    return;
                }
                
                [self.languageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([title isEqualToString:obj]) {
                        [[SSKJLocalized sharedInstance]setLanguage:key];
                        *stop = YES;
                    }
                }];
                
                
                if (![weakSelf.sunTitleArray[1] isEqualToString:title]) {
                    
                    [weakSelf.sunTitleArray replaceObjectAtIndex:1 withObject:title];
                    [weakSelf.tableView reloadData];
                    
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate gotoMain];
                }
                
            } cancleBlock:^{
                
            }];
        }
            break;
        #pragma mark case 2 计价方式
        case 2:
        {
            
            WS(weakSelf);
            [SSKJ_Default_ActionsheetView showWithItems:@[SSKJLocalized(@"人民币(CNY)", nil),SSKJLocalized(@"美元(USD)", nil)] title:@"" selectedIndexBlock:^(NSInteger selectIndex) {
                NSString *title;
                if (selectIndex == 0) {
                    title = @"CNY";
                    [[SSKJ_User_Tool sharedUserTool]setMoneyType:MoneyTypeCNY];
                }else{
                    title = @"USD";
                    [[SSKJ_User_Tool sharedUserTool]setMoneyType:MoneyTypeUSDT];
                }
                
                if (![weakSelf.sunTitleArray[2] isEqualToString:title]) {
                    [weakSelf.sunTitleArray replaceObjectAtIndex:2 withObject:title];
                    [weakSelf.tableView reloadData];
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate gotoMain];
                }
                
            } cancleBlock:^{
                
            }];
        }
            break;
    }
}



-(void)checkVersion
{
    NSDictionary *dict=@{
                        @"type":@"2",
                        @"version":kAppVersion
                         };
    
    SSLog(@"\r版本->请求参数：%@",dict);
    
    
    WS(weakSelf);
    
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:BI_CheckVersion_URL RequestType:RequestTypeGet Parameters:dict Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *network_Model=[WL_Network_Model mj_objectWithKeyValues:responseObject];
        
        if (network_Model.status.integerValue == SUCCESSED)
        {
           weakSelf.versionModel=[Mine_Version_Model mj_objectWithKeyValues:network_Model.data];
            
            if (weakSelf.versionModel == nil || [weakSelf.versionModel.vercode compare:kAppVersion] == kCFCompareLessThan || [weakSelf.versionModel.vercode isEqualToString:kAppVersion]) {
                [MBProgressHUD showError:SSKJLocalized(@"当前为最新版本", nil)];
                return ;
            }else{
                [Mine_Version_AlertView showWithModel:weakSelf.versionModel confirmBlock:^{
                    [weakSelf upgrade_Button_Event];
                } cancleBlock:^{
                    
                }];
            }
        }else{
            [MBProgressHUD showError:SSKJLocalized(@"当前为最新版本", nil)];
        }
        
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {

    }];
    
}


#pragma mark - 版本更新控制 立即更新 事件
-(void)upgrade_Button_Event
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionModel.address]];
}



#pragma mark - 退出登录
-(void)logoutEvent
{
    WS(weakSelf);
    [SSKJ_Default_AlertView showWithTitle:SSKJLocalized(@"退出登录", nil) message:SSKJLocalized(@"是否确定退出该账户？", nil) cancleTitle:SSKJLocalized(@"取消", nil) confirmTitle:SSKJLocalized(@"退出", nil) confirmBlock:^{
        
        {
            
            [SSKJ_User_Tool clearUserInfo];
            LoginViewController *loginVc = [[LoginViewController alloc]init];
            loginVc.isLoginOut = YES;
            [weakSelf.navigationController pushViewController:loginVc animated:YES];
        }
        
    }];
    
    
}




@end
