//
//  LWSListPager.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/25.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSListPager.h"
#import "LWSModelList.h"
#import "UIImageView+WebCache.h"
#import "LWSBasicWebView.h"

/**长文章的可拼接网址 */
#define URLLONG [NSString stringWithFormat:@"http://app3.qdaily.com/app3/categories/index/1/%d",self.page]
#define URLTOP [NSString stringWithFormat:@"http://app3.qdaily.com/app3/categories/index/16/%d",self.page]
#define URLIMAGES [NSString stringWithFormat:@"http://app3.qdaily.cohttp://app3.qdaily.com/app3/categories/index/22/%d",self.page]
#define URLBIGCOMPANY [NSString stringWithFormat:@"http://app3.qdaily.com/app3/categories/index/63/%d",self.page]
#define URLBUSINESS [NSString stringWithFormat:@"http://app3.qdaily.com/app3/categories/index/18/%d",self.page]

@interface LWSListPager ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , assign)NSInteger page;
@property (nonatomic , retain)UITableView *tableView;
@property (nonatomic , retain)UIImageView *imageBack;

@end

@implementation LWSListPager

- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [[NSMutableArray alloc]init];
        /**设置初始的内容(暂时没有图标，找到后需要修改)(有的也没有网站内容) */
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"长文章" StrUrl:URLLONG IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"Top15" StrUrl:URLTOP IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"十个图" StrUrl:URLIMAGES IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"大公司头条" StrUrl:URLBIGCOMPANY IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"商业" StrUrl:URLBUSINESS IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"智能" StrUrl:URLBUSINESS IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"设计" StrUrl:nil IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"时尚" StrUrl:nil IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"娱乐" StrUrl:nil IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"城市" StrUrl:nil IconUrl:nil]];
        [_models addObject:[[LWSModelList alloc] initWithTitle:@"游戏" StrUrl:nil IconUrl:nil]];
    }
    return _models;
}

/**vc的初始化函数 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)loadMyView{
    NSString *state = [[NSUserDefaults standardUserDefaults] valueForKey:CONTECTTYPE];
    [self loadDetialPagerView:state];
}

- (void)loadDetialPagerView:(NSString *)state{
    [super loadDetialPagerView:state];
    /**创建返回的相框的全部内容 */
    self.imageBack = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.imageBack.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackPager)];
    [self.imageBack addGestureRecognizer:tapBack];
    self.imageBack.image = [UIImage imageNamed:@"homeBackButton"];
    [self createTableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect frame = self.tableView.frame;
    frame.size.height = self.view.frame.size.height - 50;
    self.tableView.frame = frame;
    frame = CGRectMake(20, self.view.frame.size.height - 40, 30, 30);
    self.imageBack.frame = frame;
}

- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.alpha = 0.75;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    /**在界面添加返回相框 */
    [self.view addSubview:self.imageBack];
}


- (void)tapBackPager{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x = frame.size.width;
        self.view.frame = frame;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    LWSModelList *model = self.models[indexPath.row];
    if (model.iconUrl) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = model.title;
    cell.textLabel.textColor = [UIColor yellowColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LWSModelList *model = self.models[indexPath.row];
    if (model.strUrl) {
        /**从主界面跳转 */
        self.block(model.strUrl);
    }
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
