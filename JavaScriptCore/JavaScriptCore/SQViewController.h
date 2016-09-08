//
//  SQViewController.h
//  JavaScriptCore
//
//  Created by 沈强 on 16/9/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSOCExport <JSExport>

/** 带两个参数的方法 */
- (void)testMethodWithParam1:(NSString *)param1 Param2:(NSString *)param2;
/** 带两个参数的方法(2) */
- (void)test:(NSNumber *)param1 method:(NSString *)param2;
/** 带一个参数的方法 */
- (void)testLog:(NSString  *)logText;
/** 参数以数组的方式 */
- (void)testArray:(NSArray *)dataArray;
- (void)calculateForJS:(NSNumber *)number;

@end

@interface SQViewController : UIViewController

@end






