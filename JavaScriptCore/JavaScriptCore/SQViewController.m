//
//  SQViewController.m
//  JavaScriptCore
//
//  Created by 沈强 on 16/9/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "SQViewController.h"

@interface SQViewController ()<UIWebViewDelegate, JSOCExport>
{
    UIWebView *myWebView;
    JSContext *context;
}
@end

@implementation SQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"info.html"];
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    myWebView.delegate = self;
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 设置导航栏title
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    // 设置页面元素
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.display = 'none'"];
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打印异常
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptions) {
        context.exception = exceptions;
        NSLog(@"%@", exceptions);
    };
    
    // 以 JSExport 协议    关联 Native
    context[@"Native"] = self;
    
    // 以block 形式关联 JS中的func
    context[@"log"] = ^(NSString *str) {
        NSLog(@"log = %@", str);
    };
    
    UIViewController *vc = self;
    context[@"alert"] = ^(NSString *str) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"msg from js" message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [vc presentViewController:alert animated:YES completion:nil];
        });
    };
    
    context[@"addSubView"] = ^(NSString *str) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        v.backgroundColor = [UIColor redColor];
        [v addSubview:[[UISwitch alloc] init]];
        [vc.view addSubview:v];
    };
    
//    [context[@"showResult"] callWithArguments:@[@4]];
}

- (void)calculateForJS:(NSNumber *)number {
    int sum = 1;
    for (int i = 1; i <= [number intValue]; i++) {
        sum *= i;
    }
    NSString *str = [NSString stringWithFormat:@"showResult('%d')", sum];
//    [myWebView stringByEvaluatingJavaScriptFromString:str];
    [context evaluateScript:str];
}

/** 带两个参数的方法 */
- (void)testMethodWithParam1:(NSString *)param1 Param2:(NSString *)param2 {
    NSLog(@"testMethodWithParam1 = %@, param2 = %@", param1, param2);
}
/** 带两个参数的方法(2) */
- (void)test:(NSNumber *)param1 method:(NSString *)param2 {
    NSLog(@"testParams = %@, method = %@", param1, param2);
}
/** 带一个参数的方法 */
- (void)testLog:(NSString *)logText {
    NSLog(@"testLog = %@", logText);
}
/** 参数以数组的方式 */
- (void)testArray:(NSArray *)dataArray {
    NSLog(@"testArray = %@", dataArray);
}
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
@end
