//
//  LWSBasicWebView.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/18.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSBasicWebView.h"
#import <WebKit/WebKit.h>

@interface LWSBasicWebView ()<WKUIDelegate>

@property (nonatomic , retain)WKWebView *webView;
/**加载背景动图的属性 */
@property (nonatomic , retain)UIImageView *animationPicView;
@property (nonatomic , retain)UIView *backgroundView;

/**添加回退的按钮 */
@property (nonatomic , retain)UIImageView *backView;

@end

@implementation LWSBasicWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /**需要考虑在webview没有加载出来的时候的背景图片的问题 */
    self.webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
//    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    /** 添加一个观察者监听webview的加载状态*/
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(20, frame.size.height - 60);
    frame.size = CGSizeMake(50, 50);
    //    self.backView.backgroundColor = [UIColor blackColor];
    //    self.backView.layer.cornerRadius = 25.0;
    //    self.backView.layer.masksToBounds = YES;
    self.backView = [[UIImageView alloc]initWithFrame:frame];
    self.backView.image = [UIImage imageNamed:@"homeBackButton@2x"];
    self.backView.alpha = 0.7;
    self.backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBackView)];
    [self.backView addGestureRecognizer:tap];
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    frame.origin = CGPointMake(0, 0);
    frame.size = self.view.frame.size;
    self.backgroundView = [[UIView alloc]initWithFrame:frame];
    [self.view addSubview:self.backgroundView];
    frame.size = CGSizeMake(100, 100);
    self.animationPicView = [[UIImageView alloc]initWithFrame:frame];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 93; i++) {
        NSString *name;
        if (i < 10) {
            name = [NSString stringWithFormat:@"Loading_0000%d",i];
        }else
            name = [NSString stringWithFormat:@"Loading_000%d",i];
        [images addObject:[UIImage imageNamed:name]];
    }
    [self.view addSubview:self.backgroundView];
    self.animationPicView.center = self.backgroundView.center;
    [self.backgroundView addSubview:self.animationPicView];
    self.animationPicView.animationImages = images;
    self.animationPicView.animationDuration = 3;
    self.animationPicView.animationRepeatCount = 0;
    [self.animationPicView startAnimating];
    // Do any additional setup after loading the view.
}

- (void)goBackView{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loading"]) {
        BOOL loading = [[change valueForKey:@"new"] boolValue];
        if (!loading) {
            [self.animationPicView stopAnimating];
            [self.animationPicView removeFromSuperview];
            [self.backgroundView removeFromSuperview];
            [self.view addSubview:self.webView];
            [self.view addSubview:self.backView];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /**在程序将药效是的时候移除观察者 */
    [self.webView removeObserver:self forKeyPath:@"loading"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
