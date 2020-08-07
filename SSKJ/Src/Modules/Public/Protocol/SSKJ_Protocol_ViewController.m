//
//  My_Protocol_ViewController.m
//  ZYW_MIT
//
//  Created by 刘小雨 on 2019/4/1.
//  Copyright © 2019年 Wang. All rights reserved.
//

#import "SSKJ_Protocol_ViewController.h"
#import <WebKit/WebKit.h>



@interface SSKJ_Protocol_ViewController () <WKUIDelegate,WKNavigationDelegate,NSURLSessionDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation SSKJ_Protocol_ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSInteger type = self.type.integerValue;
    
    if (type == 6)
    {
        self.title = SSKJLocalized(@"注册协议", nil);
    }
    else if (type == 4)
    {
        self.title = SSKJLocalized(@"隐私政策", nil);
    }
    else if (type == 3)
    {
        self.title = SSKJLocalized(@"法律声明", nil);
    }
    else if (type == 10)
    {
        self.title = SSKJLocalized(@"用户协议", nil);
    }
    else if (type == 8)
    {
        self.title = SSKJLocalized(@"规则", nil);
    }
    
    [self setupUI];
    [self requestProtocolContent];
    
}

- (void)setupUI {
    
//    UIView *lineV = [UIView new];
//    lineV.backgroundColor = kLineColor;
//    [self.view addSubview:lineV];
//    lineV.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScaleW(10));
    
    [self.view addSubview:self.webView];
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


-(WKWebView *)webView
{
    if (nil == _webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar)];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView setOpaque:FALSE];
        _webView.backgroundColor=kBgColor;
        
        if (@available(iOS 11.0, *))
        {
            
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
            _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
            
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
        

    }
    return _webView;
}


- (void)requestProtocolContent {
    

    
    WS(weakSelf);
    
    [MBHUD showHUDAddedTo:self.view];
        
    NSDictionary *params = @{
        @"type":self.type
    };
    
    [[WLHttpManager shareManager] requestWithURL_HTTPCode:BI_Protocol_URL RequestType:RequestTypeGet Parameters:params Success:^(NSInteger statusCode, id responseObject)
     {
         [MBHUD hideHUDForView:self.view];
         WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
         if (netWorkModel.status.integerValue == SUCCESSED )
         {
             [weakSelf.webView loadHTMLString:responseObject[@"data"][@"content"] baseURL:nil];
         }
         else
         {
             [MBHUD showError:netWorkModel.msg];
         }
         
     } Failure:^(NSError *error, NSInteger statusCode, id responseObject)
     {
         [MBHUD hideHUDForView:self.view];
         [MBHUD showError:SSKJLocalized(@"网错出错", nil)];
     }];
    
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"completionHandler:nil];
    
    //修改字体颜色  #9098b8
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#E0E3F9'"completionHandler:nil];
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *string = [NSString stringWithFormat:@"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var myimg,oldwidth;"
                        "var maxwidth = 1000.0;" // WKWebView中显示的图片宽度
                        "for(i=0;i <document.images.length;i++){"
                        "myimg = document.images[i];"
                        "oldwidth = myimg.width;"
                        "myimg.width = maxwidth;"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();"];
    
    [webView evaluateJavaScript:string completionHandler:nil];
    
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:@"加载失败"];
}



@end
