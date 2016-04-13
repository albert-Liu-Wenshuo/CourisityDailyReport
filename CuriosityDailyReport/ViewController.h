//
//  ViewController.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/14.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CONTECTTYPE @"internetContectType"
#define CONTECTWIFI @"wifi"
#define CONTECTMOBILE @"mobile"
#define CONTECTNONE @"no"

@interface ViewController : UIViewController

/**这是相当于系统本身的viewDidLoad的类方法，并附带了一个代表系统网络状态的字符串 */
- (void)loadDetialPagerView:(NSString *)state;

/**加载vc时根据网络添加网络提示窗 */
- (void)loadMyView;

/**如果对于基类的警告界面不满意可以重写该方法 */
- (void)showUncotectWarn;

@end

