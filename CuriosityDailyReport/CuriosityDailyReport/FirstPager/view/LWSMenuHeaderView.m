//
//  LWSMenuHeaderView.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/25.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSMenuHeaderView.h"

@interface LWSMenuHeaderView ()<UITextViewDelegate>

@property (nonatomic , retain)UIButton *buttonSetting;
@property (nonatomic , retain)UIButton *buttonDay;
@property (nonatomic , retain)UIButton *buttonNight;
@property (nonatomic , retain)UIButton *buttonDownLoad;

@property (nonatomic , retain)UITapGestureRecognizer *tapConfig;
@property (nonatomic , retain)UITapGestureRecognizer *tapDay;
@property (nonatomic , retain)UITapGestureRecognizer *tapNight;
@property (nonatomic , retain)UITapGestureRecognizer *tapDownLoad;

@end

@implementation LWSMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createHeaderView];
        /**创建头视图的内容 */
    }
    return self;
}

- (void)createHeaderView{
    CGRect frame = CGRectMake(50, 40, self.frame.size.width - 100, 30);
    self.textSearch = [[UITextField alloc]initWithFrame:frame];
    [self addSubview:self.textSearch];
    frame.origin = CGPointMake(frame.origin.x + 10, frame.origin.y + 5);
    frame.size = CGSizeMake(20, 20);
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:frame];
    imageview.image = [UIImage imageNamed:@"setting_search"];
    [self addSubview:imageview];
    /**设置搜索内容的时候前面要填充一定的空格（在对应的vc中写这个搜索框的协议方法） */
    self.textSearch.placeholder = @"     搜索";
    self.textSearch.borderStyle = UITextBorderStyleRoundedRect;
    
    /**设置按钮及图标 */
    frame.origin = CGPointMake(20, self.textSearch.frame.size.height + self.textSearch.frame.origin.y + 20);
    frame.size = CGSizeMake(30, 30);
    UIImageView *imageConfig = [[UIImageView alloc]initWithFrame:frame];
    imageConfig.image = [[UIImage imageNamed:@"setting_config"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CGPoint center = imageConfig.center;
    [self addSubview:imageConfig];
    center.x = self.frame.size.width / 8.0;
    imageConfig.center = center;
    self.tapConfig = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
    [imageConfig addGestureRecognizer:self.tapConfig];
    
    frame.origin.y += frame.size.height + 10;
    frame.size.width = 50;
    frame.size.height = 20;
    self.buttonSetting = [[UIButton alloc]initWithFrame:frame];
    [self.buttonSetting setTitle:@"设置" forState:UIControlStateNormal];
    self.buttonSetting.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.buttonSetting addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonSetting];
    center = self.buttonSetting.center;
    center.x = imageConfig.center.x;
    self.buttonSetting.center = center;
    
    /**设置日间模式的按钮 */
    frame.origin.y = imageConfig.frame.origin.y;
    frame.size = imageConfig.frame.size;
    UIImageView *imageDay = [[UIImageView alloc]initWithFrame:frame];
    [self addSubview:imageDay];
    imageDay.image = [[UIImage imageNamed:@"setting_sun"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    center = imageDay.center;
    center.x = self.frame.size.width / 8.0 * 3;
    imageDay.center = center;
    self.tapDay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
    [imageDay addGestureRecognizer:self.tapDay];
    frame.origin.y += frame.size.height + 10;
    frame.size.width = 50;
    frame.size.height = 20;
    self.buttonDay = [[UIButton alloc]initWithFrame:frame];
    [self.buttonDay setTitle:@"日间" forState:UIControlStateNormal];
    self.buttonDay.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.buttonDay addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonDay];
    center = self.buttonDay.center;
    center.x = imageDay.center.x;
    self.buttonDay.center = center;
    
    /**设置夜间模式按钮 */
    frame.origin.y = imageDay.frame.origin.y;
    frame.size = imageDay.frame.size;
    UIImageView *imageNight = [[UIImageView alloc]initWithFrame:frame];
    [self addSubview:imageNight];
    imageNight.image = [[UIImage imageNamed:@"setting_mune"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    center = imageNight.center;
    center.x = self.frame.size.width / 8.0 * 5;
    imageNight.center = center;
    
    self.tapNight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
    [imageNight addGestureRecognizer:self.tapNight];
    frame.origin.y += frame.size.height + 10;
    frame.size.width = 50;
    frame.size.height = 20;
    self.buttonNight = [[UIButton alloc]initWithFrame:frame];
    [self.buttonNight setTitle:@"夜间" forState:UIControlStateNormal];
    self.buttonNight.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.buttonNight addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonNight];
    center = self.buttonNight.center;
    center.x = imageNight.center.x;
    self.buttonNight.center = center;
    
    /**设置离线缓存按钮
     不知道在这里实现什么功能啊
     */
    frame.origin.y = imageNight.frame.origin.y;
    frame.size = imageNight.frame.size;
    UIImageView *imageDownLoad = [[UIImageView alloc]initWithFrame:frame];
    [self addSubview:imageDownLoad];
    imageDownLoad.image = [[UIImage imageNamed:@"setting_download"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    center = imageDownLoad.center;
    center.x = self.frame.size.width / 8.0 * 7;
    imageDownLoad.center = center;
    
    self.tapDownLoad = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
    [imageNight addGestureRecognizer:self.tapDownLoad];
    frame.origin.y += frame.size.height + 10;
    frame.size.width = 50;
    frame.size.height = 20;
    self.buttonDownLoad = [[UIButton alloc]initWithFrame:frame];
    [self.buttonDownLoad setTitle:@"下载" forState:UIControlStateNormal];
    self.buttonDownLoad.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.buttonDownLoad addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonDownLoad];
    center = self.buttonDownLoad.center;
    center.x = imageDownLoad.center.x;
    self.buttonDownLoad.center = center;
    
    [self.buttonDay setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.buttonDownLoad setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.buttonNight setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.buttonSetting setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];

}

- (void)tapMethod:(UITapGestureRecognizer *)sender{
    if ([sender isEqual:self.tapConfig]) {
        /**点击的是设置的手势 */
        [self jumpToSettingPage];
    }else if ([sender isEqual:self.tapDay]) {
        /**点击的是判断时候是白天模式，白天模式的话不变，夜间模式的话跳转到白天模式 */
    }else if ([sender isEqual:self.tapNight]){
        /**点击的是判断时候是夜间模式，夜间模式的话不变，白天模式的话跳转到夜间模式 */

    }else if([sender isEqual:self.tapDownLoad])
    {
        /**点击的是下载的方法 */
    }
    
    
}

- (void)clickOnButton:(UIButton *)sender{
    if ([sender isEqual:self.buttonSetting]) {
        /**跳转到设置的界面 */
        [self jumpToSettingPage];
    }else if ([sender isEqual:self.buttonDay]) {
        /**点击的是判断时候是白天模式，白天模式的话不变，夜间模式的话跳转到白天模式 */
    }else if ([sender isEqual:self.buttonNight]){
        /**点击的是判断时候是夜间模式，夜间模式的话不变，白天模式的话跳转到夜间模式 */
        
    }
    else if([sender isEqual:self.buttonDownLoad])
    {
        /**点击的是下载的方法 */
    }
}

- (void)jumpToSettingPage{
    
}

@end
