//
//  XYWKWebViewController.m
//  XYWKWebView
//
//  Created by 闫世超 on 2018/11/29.
//  Copyright © 2018 闫世超. All rights reserved.
//

#import "XYWKWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0f

@interface XYWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) CALayer *progresslayer;

@property (strong, nonatomic) UIView *progressView;

//navView
@property (strong, nonatomic) UIView *navView;
@property (strong, nonatomic) UIButton *return_btn;
@property (strong, nonatomic) UILabel *title_label;

@end

@implementation XYWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //添加属性监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    // Do any additional setup after loading the view.
}


- (void)updateWithUrl:(NSString *)urlString andWithTitle:(NSString *)titleString andWithIsPush:(BOOL)isPush{
    if (isPush) {
        //是push的controller
        [self createPushUI:titleString];
        self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-(kStatusBarHeight+kNavBarHeight));
        self.progressView.frame = CGRectMake(0, 0, kScreenWidth, 1.0f);
    }else{
       //是present 的 controller
        [self createPresentUI:titleString];
        self.webView.frame = CGRectMake(0, kStatusBarHeight+kNavBarHeight, kScreenWidth, kScreenHeight-(kStatusBarHeight+kNavBarHeight));
        self.progressView.frame = CGRectMake(0, kStatusBarHeight+kNavBarHeight, kScreenWidth, 1.0f);
    }
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

//是push 创建UI
- (void)createPushUI:(NSString *)titleStr{
    self.title = titleStr;
    self.progressView.frame = CGRectMake(0, 0, kScreenWidth, 1.0f);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnClick:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)leftBtnClick:(UIBarButtonItem *)sender{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//是present 创建UI
- (void)createPresentUI:(NSString *)titleStr{
    __weak typeof(self) weakself = self;
    self.progressView.frame = CGRectMake(0, 0, kScreenWidth, 1.0f);
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.view.mas_left);
        make.right.mas_equalTo(weakself.view.mas_right);
        make.top.mas_equalTo(weakself.view.mas_top).offset(kStatusBarHeight);
        make.height.mas_equalTo(kNavBarHeight);
    }];
    
    [self.navView addSubview:self.return_btn];
    [self.return_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.navView.mas_left).offset(15.0f);
        make.centerY.mas_equalTo(weakself.navView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kNavBarHeight, kNavBarHeight));
    }];
    
    [self.navView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakself.navView.mas_centerX);
        make.centerY.mas_equalTo(weakself.navView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(3*kScreenWidth/5, 20.0f));
    }];
    
    self.title_label.text = titleStr;
    
}

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]init];
    }
    return _navView;
}

- (UIButton *)return_btn{
    if (!_return_btn) {
        _return_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_return_btn setTitle:@"返回" forState:UIControlStateNormal];
        [_return_btn addTarget:self action:@selector(return_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_return_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _return_btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _return_btn;
}

- (UILabel *)title_label{
    if (!_title_label) {
        _title_label = [[UILabel alloc]init];
        _title_label.font = [UIFont systemFontOfSize:16.0f];
        _title_label.textColor = [UIColor colorWithRed:34.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1];
        _title_label.textAlignment = NSTextAlignmentCenter;
    }
    return _title_label;
}

- (void)return_btnClick:(UIButton *)sender{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.view resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//进度条
- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc]init];
        _progressView.backgroundColor = [UIColor clearColor];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 1.0f);
        layer.backgroundColor = [UIColor cyanColor].CGColor;
        [_progressView.layer addSublayer:layer];
        _progresslayer = layer;
    }
    return _progressView;
}


- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
        config.userContentController = [[WKUserContentController alloc]init];
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}


#pragma mark - delegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //        NSLog(@"%@", change);
        self.progresslayer.opacity = 1;
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //开始加载
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //加载完成
    //这里可以接受web前端的方法，用来初始化web页面的信息
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    //网络错误
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    //    NSLog(@"======url=========   %@",navigationAction.request.URL);
    NSString* reqUrl = navigationAction.request.URL.absoluteString;
    
    if ([reqUrl containsString:@"next"]){
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if ([reqUrl containsString:@"ios_recharge_zs_pay"]){
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        // NOTE: 跳转支付宝App
        BOOL bSucc = [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"未检测到支付宝客户端，请安装后重试。"
                                                          delegate:self
                                                 cancelButtonTitle:@"立即安装"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if ([reqUrl hasPrefix:@"weixin://"] || [reqUrl hasPrefix:@"weixin://"]) {
        // NOTE: 跳转支付宝App
        BOOL bSucc = [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
        
        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"未检测到微信客户端，请安装后重试。"
                                                          delegate:self
                                                 cancelButtonTitle:@"立即安装"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    //允许webView的点击时数据的获取
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    //    NSLog(@"============= %@",message);
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    completionHandler(NO);
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
