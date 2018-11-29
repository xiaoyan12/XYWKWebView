//
//  ViewController.m
//  XYWKWebView
//
//  Created by 闫世超 on 2018/11/29.
//  Copyright © 2018 闫世超. All rights reserved.
//

#import "ViewController.h"
#import "XYWKWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(UIButton *)sender {
//    NSString *url = @"https://www.daofengdj.com/index/activitynew/confession?token=76a0IWzoPC6WWvcGIIXSVs-kwa3nssgP9zYrsr9zjHlaBy00B9IbhtKcrWgZCcDNY590hcwXd9zkHlUy";
    NSString *url = @"https://www.baidu.com";
    XYWKWebViewController *webViewController = [[XYWKWebViewController alloc]init];
    
    [webViewController updateWithUrl:url andWithTitle:@"啦啦啦" andWithIsPush:YES];
    [self.navigationController pushViewController:webViewController animated:YES];
    
//    [webViewController updateWithUrl:url andWithTitle:@"啦啦啦" andWithIsPush:NO];
//    [self presentViewController:webViewController animated:YES completion:nil];
    

}

@end
