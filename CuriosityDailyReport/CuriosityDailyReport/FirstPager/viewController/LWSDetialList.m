//
//  LWSDetialList.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSDetialList.h"
#import "LWSFirstPagerCell.h"
#import "LWSFirstImageCell.h"
#import "LWSBasicTableView.h"
#import "LWSBasicWebView.h"
#import "LWSDataAnaly.h"

#define CELLNORMAL @"cell"
#define CELLIMAGE @"imageCell"

@interface LWSDetialList ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , retain)LWSBasicTableView *tableView;
@property (nonatomic , retain)NSMutableArray *models;
@property (nonatomic , assign)CGFloat cellHeight;



@end

@implementation LWSDetialList

- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [[NSMutableArray alloc]init];
        [LWSDataAnaly getFirstPagerCellModelsWithUrl:self.strUrl Result:^(NSMutableArray *result) {
            _models = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadMyView{
    NSString *state = [[NSUserDefaults standardUserDefaults] valueForKey:CONTECTTYPE];
    [self loadDetialPagerView:state];
}

- (void)loadDetialPagerView:(NSString *)state{
    [super loadDetialPagerView:state];
    [self createTableView];
}

- (void)createTableView{
    self.tableView = [[LWSBasicTableView alloc]initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LWSFirstPagerCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[LWSFirstImageCell class] forCellReuseIdentifier:@"imageCell"];
    [self.view addSubview:self.tableView];
    /**获取cell高 */
    self.cellHeight = [self getCellHeightByImage:[UIImage imageNamed:@"cell_holder.jpg"]];
    self.tableView.rowHeight = self.cellHeight;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
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
