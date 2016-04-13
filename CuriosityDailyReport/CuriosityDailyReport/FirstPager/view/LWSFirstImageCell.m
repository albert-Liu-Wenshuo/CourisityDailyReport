//
//  LWSFirstImageCell.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSFirstImageCell.h"
#import "UIImageView+WebCache.h"
#import "LWSModelCategory.h"
#import "LWSCoculateSize.h"

@interface LWSFirstImageCell ()

@property (nonatomic , retain)UILabel *labelTitle;
@property (nonatomic , retain)UILabel *labelSign;
@property (nonatomic , retain)UILabel *labelPriseCount;
@property (nonatomic , retain)UILabel *labelCommentCount;
@property (nonatomic , retain)UILabel *labelPublishTime;
@property (nonatomic , retain)UIImageView *imageShowView;
@property (nonatomic , retain)UILabel *labelSummary;

/**考虑到夜间模式两张图片也会相应的改变，特将两张评论和点赞的图片也设为属性 */
@property (nonatomic , retain)UIImageView *imageCommentView;
@property (nonatomic , retain)UIImageView *imagePriseView;

@end

@implementation LWSFirstImageCell

/**重写model的set方法 */
- (void)setModel:(LWSModelFirst *)model{
    _model = model;
    _labelTitle.text = _model.title
    ;
    _labelSign.text = _model.category.title;
    _labelSummary.text = _model.summary;
    /**根据对应的模型是否存在决定是否添加对应的iamgeview */
    if (_model.praise_count != nil) {
        _labelPriseCount.text = [NSString stringWithFormat:@"%@",_model.praise_count];
        [self.contentView addSubview:_imagePriseView];
    }
    if (_model.comment_count != nil) {
        _labelCommentCount.text = [NSString stringWithFormat:@"%@",_model.comment_count];
        [self.contentView addSubview:_imageCommentView];
    }
    /**时间戳的获取需要判断 :注意时间错的内容也可能不存在 */
    
    /**为相框加载图片 */
    [self loadImage:_model.image ImageView:_imageShowView];
}

/**根据网络状态获取是否加载图片 */
- (void)loadImage:(NSString *)strUrl
        ImageView:(UIImageView *)imageView{
    /**
     目前是设置当网络状态显示的是移动网络的时候不加载图片，日后需要修改
     */
    NSString *state = [[NSUserDefaults standardUserDefaults] valueForKey:CONTECTTYPE];
    if (state != nil && [state isEqualToString:CONTECTMOBILE]) {
        imageView.image = [UIImage imageNamed:@"Scroller_Holder.jpg"];
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"Scroller_Holder.jpg"]];
    }
}

/**对于颜色的调整一定要写在初始化函数中 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /**1.属性的初始化
         2.所有的背景颜色设置
         3.设置类似字体对齐方式，是否可以分行之类的*/
        self.labelSign = [[UILabel alloc]initWithFrame:CGRectZero];
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        self.labelPublishTime = [[UILabel alloc]initWithFrame:CGRectZero];
        self.labelPriseCount = [[UILabel alloc]initWithFrame:CGRectZero];
        self.labelCommentCount = [[UILabel alloc]initWithFrame:CGRectZero];
        self.labelSummary = [[UILabel alloc]initWithFrame:CGRectZero];
        
        /**设置标签栏可以行数可以为多行 */
        self.labelTitle.numberOfLines = 0;
        self.labelSummary.numberOfLines = 0;
        /**设置·标题label的字体是粗体17号 */
        self.labelTitle.font = [UIFont boldSystemFontOfSize:14.0];
        self.labelSummary.font = [UIFont systemFontOfSize:13.0];
        self.labelSign.font = [UIFont systemFontOfSize:12.0];
        self.labelPublishTime.font = [UIFont systemFontOfSize:12.0];
        self.labelPriseCount.font = [UIFont systemFontOfSize:12.0];
        self.labelCommentCount.font = [UIFont systemFontOfSize:12.0];
        self.labelSummary.textColor = [UIColor darkGrayColor];
        self.labelCommentCount.textColor = [UIColor darkGrayColor];
        self.labelPriseCount.textColor = [UIColor darkGrayColor];
        self.labelPublishTime.textColor = [UIColor darkGrayColor];
        self.labelSign.textColor = [UIColor darkGrayColor];
        
        self.imageShowView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.imageShowView];
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelSummary];
        [self.contentView addSubview:self.labelSign];
        [self.contentView addSubview:self.labelPublishTime];
        [self.contentView addSubview:self.labelPriseCount];
        [self.contentView addSubview:self.labelCommentCount];
        
        /**在初始化中为两个iamge属性添加图片 */
        self.imageCommentView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imagePriseView = [[UIImageView alloc]initWithFrame:CGRectZero];
        /**不使用系统渲染 */
        self.imageCommentView.image = [[UIImage imageNamed:@"feedComment"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.imagePriseView.image = [[UIImage imageNamed:@"feedPraise"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    return self;
}

/**在这里设置各个组件的尺寸 ， 以及位置 */
- (void)layoutSubviews{
    [super layoutSubviews];
    /**绝对不能再这里设置组件的颜色，否则未来设置夜间模式会出现严重的问题 */
    //1.图片是整个界面的上半部分
    UIImage *image = [UIImage imageNamed:@"Scroller_Holder.jpg"];
    CGRect frame = self.contentView.frame;
    frame.size = CGSizeMake(frame.size.width, (frame.size.width / image.size.width) * image.size.height);
    self.imageShowView.frame = frame;
    //2.设置其他下半部分组件的尺寸，其中labeltitle需要自适应的高
    frame.size.width -= 20;
    frame.origin = CGPointMake(10, frame.size.height + 10);
    frame.size.height = [LWSCoculateSize getCurrentLabelHeightByLabelText:self.model.title Font:self.labelTitle.font LabelWidth:frame.size.width];
    self.labelTitle.frame = frame;
    
    frame.origin.y += frame.size.height + 5;
    frame.size.height = [LWSCoculateSize getCurrentLabelHeightByLabelText:self.model.summary Font:self.labelSummary.font LabelWidth:frame.size.width];
    self.labelSummary.frame = frame;
    
    //3.设置最后一行
    frame.origin = CGPointMake(10, self.contentView.frame.size.height - 20);
    /**设置标签的label */
    frame.size = CGSizeMake([LWSCoculateSize getCurrentLabelWidthByLabelText:self.model.category.title Font:self.labelSign.font LabelHeight:15], 15);
    self.labelSign.frame = frame;
    /**设置评论的图标和标签 */
    if (self.model.comment_count != nil) {
        frame.origin.x += 5 + frame.size.width;
        frame.size = CGSizeMake([LWSCoculateSize getCurrentLabelWidthByLabelText:self.labelCommentCount.text Font:self.labelCommentCount.font LabelHeight:15], 15);
        self.labelCommentCount.frame = frame;
        /**添加评论的那个iamgeview和图标  (图标大小是15 * 15)*/
        frame.origin.x += 5 + frame.size.width;
        frame.size = CGSizeMake(15, 15);
        self.imageCommentView.frame = frame;
    }
    /**设置点赞的图片和标签 */
    if (self.model.praise_count != nil) {
        frame.origin.x += frame.size.width + 5;
        frame.size = CGSizeMake([LWSCoculateSize getCurrentLabelWidthByLabelText:self.labelPriseCount.text Font:self.labelPriseCount.font LabelHeight:15], 15);
        self.labelPriseCount.frame = frame;
        /**添加点赞的那个iamgeview和图标  (图标大小是20 * 20)*/
        frame.origin.x += 5 + frame.size.width;
        frame.size = CGSizeMake(15, 15);
        self.imagePriseView.frame = frame;
    }
    /**设置时间戳的label */
    if (self.labelPublishTime.text != nil && ![self.labelPublishTime.text isEqualToString:@""]) {
        frame.origin.x += 5 + frame.size.width;
        frame.size.width = [LWSCoculateSize getCurrentLabelWidthByLabelText:self.labelPublishTime.text Font:self.labelPublishTime.font LabelHeight:20];
        self.labelPublishTime.frame = frame;
    }

}




@end
