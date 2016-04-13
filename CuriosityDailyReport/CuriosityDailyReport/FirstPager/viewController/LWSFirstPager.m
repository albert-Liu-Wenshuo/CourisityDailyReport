//
//  LWSFirstPager.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/17.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSFirstPager.h"
#import "LWSBasicTableView.h"
#import "LWSScrollerView.h"
#import "LWSDataAnaly.h"
#import "LWSFirstPagerCell.h"
#import "LWSBasicWebView.h"
#import "LWSBasicWebView.h"
#import "LWSMenuPagerViewController.h"
#import "LWSFirstImageCell.h"
#import "LWSDetialList.h"

#define URL @"http://app3.qdaily.com/app3/homes/index/0"

#define CELLNORMAL @"cell"
#define CELLIMAGE @"imageCell"

@interface LWSFirstPager ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , retain)NSMutableArray *models;
@property (nonatomic , retain)LWSBasicTableView *tableview;
@property (nonatomic , retain)LWSScrollerView *header;
@property (nonatomic , assign)CGFloat cellHeight;
@property (nonatomic , retain)UIView *backView;

@property (nonatomic , retain)LWSMenuPagerViewController *menuPager;

/**设置菜单按钮 */
@property (nonatomic , retain)UIImageView *menuView;

/**判断加载第一个页面的属性 */
@property (nonatomic , assign)NSInteger *page;

/**毛玻璃相框属性 */
@property (nonatomic , retain)UIVisualEffectView *effectView;
@end

@implementation LWSFirstPager

- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [[NSMutableArray alloc]init];
        [LWSDataAnaly getFirstPagerCellModelsWithUrl:URL Result:^(NSMutableArray *result) {
            _models = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
            });
        }];
    }
    return _models;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadDetialPagerView:(NSString *)state{
    [super loadDetialPagerView:state];
    self.view.backgroundColor = [UIColor whiteColor];
    /**添加菜单按钮 */
    [self createMenuImageView];
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //  毛玻璃view 视图
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    self.effectView.frame = self.view.bounds;
    [self createTableView];
    /**解决菜单按钮可能层级错乱的问题 */
    [self.menuView removeFromSuperview];
    [self.view addSubview:self.menuView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)createMenuImageView{
    CGRect frame = CGRectMake(30,self.view.frame.size.height - 80 , 50, 50);
    self.menuView = [[UIImageView alloc]initWithFrame:frame];
    [self.view addSubview:self.menuView];
    self.menuView.alpha = 0.7;
    self.menuView.backgroundColor = [UIColor blackColor];
    self.menuView.layer.cornerRadius = 25.0;
    self.menuView.layer.masksToBounds = YES;
    self.menuView.image = [UIImage imageNamed:@"Home@iPadPro_Yellow"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnMenuImage)];
    self.menuView.userInteractionEnabled = YES;
    [self.menuView addGestureRecognizer:tap];
}

- (void)tapOnMenuImage{
    if (self.menuPager == nil) {
        self.menuPager = [[LWSMenuPagerViewController alloc]init];
        /**对于菜单栏的使用不能简单地将其跳转
         日后考虑在这里添加动画
         */
        [self addChildViewController:self.menuPager];
    }
    __weak typeof(self) weakSelf = self;
    self.menuPager.block = ^(BOOL back){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (back) {
            [strongSelf.effectView removeFromSuperview];
//            NSLog(@"block错了？");
        }
    };
    self.menuPager.myUrlBlock = ^(NSString *strUrl){
        __strong typeof(weakSelf)strongSelf = weakSelf;
        /**跳转到指定的vc ， 并将网址传过去 */
        LWSDetialList *pager = [[LWSDetialList alloc]init];
        pager.strUrl = strUrl;
        [strongSelf.navigationController pushViewController:pager animated:YES];
        NSLog(@"在这里执行跳转");
    };
    [self.view addSubview:self.effectView];
    //设置模糊透明度
    self.effectView.alpha = 0.6f;
    [self.view addSubview:self.menuPager.view];

}

- (void)createTableView{
    /**尺寸设置的位置的问题需要注意
       设置了基类主要是为了日后方便处理相关的背景颜色的问题
       需要注意的是，以后颜色的创建只能在初始化方法中
     */
    self.tableview = [[LWSBasicTableView alloc]initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    /**为tableview的cell取消下不得线条的效果 */
    self.tableview.bounces = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    /**考虑到时间栏的处理使用一层背景蒙版*/
    CGRect scframe = CGRectMake(0, 0, self.view.frame.size.width, 15);
    self.backView = [[UIView alloc]initWithFrame:scframe];
    [self.view addSubview:self.backView];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.alpha = 0.3;
    /**创建该页面的头视图 */
    UIImage *headerHolder = [UIImage imageNamed:@"Scroller_Holder.jpg"];
    CGRect frame = self.view.frame;
    CGFloat height = (frame.size.width / headerHolder.size.width) * headerHolder.size.height;
    frame.size.height = height;
    self.header = [[LWSScrollerView alloc]initWithFrame:frame];
    /**将获取的头视图数组的地址直接给头视图的数组
       只是这是一个异步的过程，所以需要头视图的数组获取到之后才将头视图赋给tableview作为头视图*/
    
//    在ARC下，由于__block抓取的变量一样会被Block retain，所以必须用弱引用才可以解决循环引用问题，iOS 5之后可以直接使用__weak，之前则只能使用__unsafe_unretained了，__unsafe_unretained缺点是指针释放后自己不会置空
    __weak typeof(self) weakself = self;
    [LWSDataAnaly getFirstPagerModelsWithUrl:URL Result:^(NSMutableArray *result) {
        self.header.models = result;
        self.header.block = ^(LWSModelFirst *model){
            LWSBasicWebView *pager = [[LWSBasicWebView alloc]init];
            pager.strUrl = model.appview;
            [weakself presentViewController:pager animated:YES completion:^{
                NSLog(@"跳转执行了");
            }];
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableview.tableHeaderView = self.header;
            /** 可能需要将蒙版浮上去*/
            [self.view insertSubview:self.backView atIndex:self.view.subviews.count - 1];
            /**不知道需不需要加 */
            [self.tableview reloadData];
        });
    }];
    /**注册cell */
    [self.tableview registerClass:[LWSFirstPagerCell class] forCellReuseIdentifier:CELLNORMAL];
    [self.tableview registerClass:[LWSFirstImageCell class] forCellReuseIdentifier:CELLIMAGE];
    [self.view addSubview:self.tableview];
    /**获取cell高 */
    self.cellHeight = [self getCellHeightByImage:[UIImage imageNamed:@"cell_holder.jpg"]];
    /** */
    self.tableview.rowHeight = self.cellHeight;
    
    /**在这添加mj的刷新头视图和尾视图 */
}

- (CGFloat)getCellHeightByImage:(UIImage *)image{
    return ((self.view.frame.size.width / 2.0) / image.size.width * image.size.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWSModelFirst *model = self.models[indexPath.row];
    if (model.imageType) {
        LWSFirstImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIMAGE];
        cell.model = model;
        /**应该是设置选中没有渲染效果 */
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }else{
    LWSFirstPagerCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLNORMAL];
        cell.model = model;
        /**应该是设置选中没有渲染效果 */
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWSModelFirst *model = self.models[indexPath.row];
    if (model.imageType) {
        return 300;
    }
    else{
        /**获取cell高 */
        if (self.cellHeight < 20) {
            self.cellHeight = [self getCellHeightByImage:[UIImage imageNamed:@"cell_holder.jpg"]];
        }
        return self.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LWSModelFirst *model = self.models[indexPath.row];
     LWSBasicWebView *pager = [[LWSBasicWebView alloc]init];
    pager.strUrl = model.appview;
    [self presentViewController:pager animated:YES completion:^{
        
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
