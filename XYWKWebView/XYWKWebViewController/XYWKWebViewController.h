//
//  XYWKWebViewController.h
//  XYWKWebView
//
//  Created by 闫世超 on 2018/11/29.
//  Copyright © 2018 闫世超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYWKWebViewController : UIViewController

- (void)updateWithUrl:(NSString *)urlString andWithTitle:(NSString *)titleString andWithIsPush:(BOOL)isPush;

@end

NS_ASSUME_NONNULL_END
