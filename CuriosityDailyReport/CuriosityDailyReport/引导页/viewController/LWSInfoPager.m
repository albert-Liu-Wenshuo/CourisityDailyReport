//
//  LWSInfoPager.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/17.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSInfoPager.h"
#import "LWSFirstPager.h"

@interface LWSInfoPager ()

@property (nonatomic , retain)LWSFirstPager *pager;

@end

@implementation LWSInfoPager

- (void)viewDidLoad {
    [super viewDidLoad];
    /**这就是个第一次进入时候需要设置的页面，以后进行处理 */
    self.view.backgroundColor = [UIColor grayColor];
    [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"info"];
    if (self.pager == nil) {
        self.pager = [[LWSFirstPager alloc]init];
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    // Do any additional setup after loading the view.
}

- (void)timeMethod{
    [self presentViewController:self.pager animated:YES completion:^{
        
    }];
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
