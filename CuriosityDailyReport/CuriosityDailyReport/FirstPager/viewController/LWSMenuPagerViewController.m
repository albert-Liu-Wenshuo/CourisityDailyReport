 //
//  LWSMenuPagerViewController.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/21.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSMenuPagerViewController.h"
#import "LWSBasicTableView.h"
#import "LWSMenuHeaderView.h"
#import "LWSListPager.h"

@interface LWSMenuPagerViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , retain)UIImageView *backView;
@property (nonatomic , retain)UITableView *tableView;
@property (nonatomic , retain)NSMutableArray *arrays;
@property (nonatomic , retain)NSMutableArray *iamges;

@property (nonatomic , retain)UITableView *tableViewList;
@property (nonatomic , retain)LWSMenuHeaderView *header;

/**list的vc */
@property (nonatomic , retain)LWSListPager *pager;


@end

@implementation LWSMenuPagerViewController

- (NSMutableArray *)arrays{
    if (_arrays == nil) {
        _arrays = [@[@"关于我们" ,@"新闻分类" ,@"栏目中心" ,@"好奇心研究所" ,@"我的消息" , @"个人中心" , @"首页"] mutableCopy];
    }
    return _arrays;
}

- (NSMutableArray *)iamges{
    if (_iamges == nil) {
        _iamges = [[NSMutableArray alloc]init];
        [_iamges addObject:[UIImage imageNamed:@"menu_about@2x"]];
        [_iamges addObject:[UIImage imageNamed:@"menu_category@2x"]];
        [_iamges addObject:[UIImage imageNamed:@"menu_column@2x"]];
        [_iamges addObject:[UIImage imageNamed:@"menu_home@2x"]];
        [_iamges addObject:[UIImage imageNamed:@"menu_lab@2x"]];
        [_iamges addObject:[UIImage imageNamed:@"menu_noti@2x"]];
        [_iamges addObject:[UIImage imageNamed:@"menu_user@2x"]];
    }
    return _iamges;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /**设置时间栏的颜色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)loadMyView{
    NSString *state = [[NSUserDefaults standardUserDefaults] valueForKey:CONTECTTYPE];
    [self loadDetialPagerView:state];
}

- (void)loadDetialPagerView:(NSString *)state{
    [super loadDetialPagerView:state];
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.alpha = 0.7;
    [self createTableView];
    /**创建返回按钮 */
    [self createBackView];
}

- (void)createBackView{
    CGRect frame = CGRectMake(30,self.view.frame.size.height - 80 , 50, 50);
    self.backView = [[UIImageView alloc]initWithFrame:frame];
    [self.view addSubview:self.backView];
    self.backView.alpha = 0.7;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToFirstPage)];
    [self.backView addGestureRecognizer:tap];
    self.backView.image = [UIImage imageNamed:@"closeButton@2x"];
    self.backView.userInteractionEnabled = YES;
    [self.view addSubview:self.backView];
    /**添加头视图 */
}


- (void)createTableView{
    self.tableView = [[LWSBasicTableView alloc]initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.alpha = 0.75;
    /**创建tableview的头视图 */
    CGRect frame = self.view.frame;
    frame.size.height = 170;
    self.header = [[LWSMenuHeaderView alloc]initWithFrame:frame];
    self.tableView.tableHeaderView = self.header;
    
    /**创建跳转菜单的vc */
    self.pager = [[LWSListPager alloc]init];
    __weak typeof(self)weakSelf = self;
    [self addChildViewController:self.pager];
    self.pager.block = ^(NSString *strUrl){
        weakSelf.myUrlBlock(strUrl);
    };
    
}

- (void)backToFirstPage{
    self.block(YES);
    [self.view removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.arrays[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.imageView.image = self.iamges[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor yellowColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.arrays[indexPath.row];
    if ([title isEqualToString:@"栏目中心"]) {
        /**在这里添加移除当前界面，并将主界面跳转到对应界面 */
        if (![self.pager isViewLoaded]) {
            self.pager.view.frame = CGRectMake(self.view.frame.size.width, self.header.frame.size.height + self.header.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - (self.header.frame.size.height + self.header.frame.origin.y));
            NSLog(@"%.2f",self.pager.view.frame.size.height);
            [self.view addSubview:self.pager.view];
        }
        [UIView animateWithDuration:1.0 animations:^{
            CGRect frame = self.pager.view.frame;
            frame.origin.x = 0;
            self.pager.view.frame = frame;
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrays.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
