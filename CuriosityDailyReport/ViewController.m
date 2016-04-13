//
//  ViewController.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/14.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "LWSWarnView.h"



//typedef NS_ENUM(NSUInteger, INTERNETSTATE) {
//    WIFISTATE = 0,
//    MOBILEPHONE,
//    UNCONTECT,
//    UNKNOW,
//};

//为了节约流量，同时也是为了更好的用户体验，目前很多应用都使用本地缓存机制，其中以网易新闻的缓存功能最为出色。我自己的应用也想加入本地缓存的功能，于是我从网上查阅了相关的资料，发现总体上说有两种方法。一种是自己写缓存的处理，一种是采用ASIHTTPRequest中的ASIDownloadCache。

@interface ViewController ()

@property (nonatomic , retain)LWSWarnView *warnView;
@property (nonatomic , assign)BOOL isLoaded;

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isLoaded = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**添加查询网络状态的单例 通过判断状态确定接下来的处理:
        使用的是AFN状态监测，*/
//    NSInteger __block netState;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    /**这是一个block形式的方法，每当网络状态变化的时候就会调用block内部的方法
     ， 所以说我在这里创建和修改userDefault对应部分的值：CONTECTTYPE*/
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                [[NSUserDefaults standardUserDefaults]setObject:CONTECTWIFI forKey:CONTECTTYPE];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                [[NSUserDefaults standardUserDefaults]setObject:CONTECTNONE forKey:CONTECTTYPE];
                if(self.isLoaded){
                    [self showALertViewWithContains:YES];
                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                [[NSUserDefaults standardUserDefaults] setObject:CONTECTMOBILE forKey:CONTECTTYPE];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                [[NSUserDefaults standardUserDefaults] setObject:CONTECTWIFI forKey:CONTECTTYPE];
                break;
            }
        }
    }];
    [self loadMyView];
    // Do any additional setup after loading the view, typically from a nib.
}

/** 1.作为一个可以重写的方法，在里面写子类vc场景的创建 ， 这样的话可以通过网络状态采取相应的措施
    2.也可以起到替代viewDidLoad的作用*/
- (void)loadMyView{
    NSString *state = [[NSUserDefaults standardUserDefaults] valueForKey:CONTECTTYPE];
    if (state != nil) {
        if ([state isEqualToString:CONTECTNONE]) {
            if (!self.isLoaded) {
                [self showUncotectWarn];
            }
        }else{
            [self loadDetialPagerView:state];
        }
    }
}

- (void)loadDetialPagerView:(NSString *)state{
    state = [[NSUserDefaults standardUserDefaults] valueForKey:CONTECTTYPE];
    self.isLoaded = YES;
}

- (void)showUncotectWarn{
    CGRect frame = self.view.frame;
    UIImage *image = [UIImage imageNamed:@"WARN_pic.jpg"];
    frame.size = CGSizeMake(frame.size.width / 2, (frame.size.width / 2 / image.size.width) * image.size.height);
    self.warnView = [[LWSWarnView alloc]initWithFrame:frame];
    __weak typeof(self)weakSelf = self;
    self.warnView.disBlock = ^(BOOL isDis){
        if(isDis){
            /**弹出警告窗 */
            [weakSelf showALertViewWithContains:NO];
        }
    };
    self.warnView.image = image;
    self.warnView.warnString = @"当前网络状况不佳";
    CGPoint center = self.view.center;
    center.y -= 100;
    self.warnView.center = center;
    [self.view addSubview:self.warnView];
}

/**设置网络警告窗 exist(bool属性，判断是否已经有显示内容)*/
- (void)showALertViewWithContains:(BOOL)exist{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"断网通知" message:@"当前网络状态为未连接是否继续观看" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"看缓存内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(!exist){
                NSString  *state = [[NSUserDefaults standardUserDefaults] valueForKey:CONTECTTYPE];
                /**若网络警告的弹窗消失，代表没有加载具体内容，在这里加载 */
                [self loadDetialPagerView:state];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出应用" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            /**填写退出应用的方法 */
            exit(0);
        }]];
        [self presentViewController:alert animated:YES completion:^{
    
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
