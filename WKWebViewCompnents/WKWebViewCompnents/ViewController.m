//
//  ViewController.m
//  WKWebViewCompnents
//
//  Created by Hyyy on 2017/6/27.
//  Copyright © 2017年 Hyyy. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

@interface ViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *jsBridge;

@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.frame = self.view.bounds;
    [self.view addSubview:self.webView];
    
    [WKWebViewJavascriptBridge enableLogging];
    
    // 加载本地的HTML文件
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"www/index.html" ofType:nil];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadHTMLString:appHtml baseURL:baseURL];
    
    // 注册H5需要调用的原生方法
    [self registerH5ToNativeMethods];
}

#pragma mark - H5 Methods
- (void)registerH5ToNativeMethods {
    [self registerShareFunction];
}

- (void)registerShareFunction {
    [self.jsBridge registerHandler:@"shareClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *shareInfo = @"分享信息，传递给H5";
        responseCallback(shareInfo);
    }];
}

#pragma mark - Setter and Getter
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 30.0;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (WKWebViewJavascriptBridge *)jsBridge {
    if (!_jsBridge) {
        _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [_jsBridge setWebViewDelegate:self];
    }
    return _jsBridge;
}

@end
