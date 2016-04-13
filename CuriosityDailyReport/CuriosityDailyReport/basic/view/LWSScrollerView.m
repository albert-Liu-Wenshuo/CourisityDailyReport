//
//  LWSScrollerView.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/17.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSScrollerView.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+LWSScroller_Touch.h"

#define CONTECTTYPE @"internetContectType"
#define CONTECTWIFI @"wifi"
#define CONTECTMOBILE @"mobile"
#define CONTECTNONE @"no"

@interface LWSScrollerView ()<UIScrollViewDelegate>

@property (nonatomic , retain)UIScrollView *scrollerview;
@property (nonatomic , retain)UIPageControl *pager;
/**添加计时器 */
@property (nonatomic , retain)NSTimer *timer;
/**添加判断是否手滑的状态 */
@property (nonatomic , assign)BOOL istouches;
/**添加延时定时器 */
@property (nonatomic , retain)NSTimer *holderTimer;

/**添加记录上次点击位置的属性 */
@property (nonatomic , assign)CGFloat touchX;

@end

@implementation LWSScrollerView

- (NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(runImageViews) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSTimer *)holderTimer{
    if (_holderTimer == nil) {
        _holderTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(runHolderTimer) userInfo:nil repeats:YES];;
    }
    return _holderTimer;
    
}

/**设置延时器的判断 */
- (void)runHolderTimer{
    if (!self.istouches) {
        [self.timer setFireDate:[NSDate distantPast]];
    }else
        self.istouches = NO;
}

/**设置nstimer的方法 */
- (void)runImageViews{
   /**第一步：获取当前scroller的偏移量 */
    CGPoint point = self.scrollerview.contentOffset;
    /**
     逻辑判断
     */
    CGFloat boderPointX = self.scrollerview.contentSize.width - 2 * self.scrollerview.frame.size.width;
    if (point.x >= boderPointX) {
        point.x = self.scrollerview.frame.size.width;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scrollerview setContentOffset:point animated:NO];
            self.pager.currentPage = 0;
        });

    }else{
        point.x += self.scrollerview.frame.size.width;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger number = self.scrollerview.contentOffset.x / self.scrollerview.frame.size.width;
            self.pager.currentPage = number;
            [self.scrollerview setContentOffset:point animated:YES];
        });
    }
    /**设置图片移动的动画：不知道是不是需要在主线程中使用该方法 */
    //    [self.scrollerview setContentOffset:point animated:YES];
}

/**使用的计时器时候需要在delloc方法中将计时器置空 */
- (void)dealloc{
    self.timer = nil;
}

/**因为imageview的尺寸直接使用的是view的尺寸，所以在外界设置尺寸的时候就需要设置好屏幕比率 */
- (void)setModels:(NSMutableArray *)models{
    if (_models != models) {
        /**这内部只在传入的模型发生变化的时候才会执行 */
        _models = models;
        NSInteger number = 2 + _models.count;
        self.scrollerview.contentSize = CGSizeMake(self.frame.size.width * number, self.frame.size.height);
        /**设置正确的采集页数量 */
        self.pager.numberOfPages = _models.count;
        /**在这里创建imageview */
        for (int i = 0; i < number; i++) {
            UIImageView *imageView;
            LWSModelFirst *model;
            CGRect frame = self.frame;
            /**第一张和最后一张需要注意 ， 其余选项按照 i-1 赋值 */
            if (i == 0) {
                /**第一张图片是最后一张 */
                model = _models[number - 3];
                frame.origin = CGPointMake(0, 0);
                imageView = [[UIImageView alloc]initWithFrame:frame];
                [self.scrollerview addSubview:imageView];
                /**所有使用sd方法的地方都加一层判断 */
                [self loadImage:model.image ImageView:imageView];
            }
            else if (i == number - 1){
                /**最后一张图片铺的是第一张 */
                model = [_models firstObject];
                frame.origin = CGPointMake(self.frame.size.width * (number - 1), 0);
                imageView = [[UIImageView alloc]initWithFrame:frame];
                [self.scrollerview addSubview:imageView];
                [self loadImage:model.image ImageView:imageView];
            }
            else{
                model = _models[i - 1];
                frame.origin = CGPointMake(self.frame.size.width * i, 0);
                imageView = [[UIImageView alloc]initWithFrame:frame];
                [self.scrollerview addSubview:imageView];
                [self loadImage:model.image ImageView:imageView];
            }
            /**开起来iamgeview的用户交互 */
            imageView.userInteractionEnabled = YES;
        }
    }
}

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

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.touchX = 0.0;
        /**创建一个scrollerView */
        CGRect frame = self.frame;
        frame.origin = CGPointMake(0, 0);
        self.scrollerview = [[UIScrollView alloc]initWithFrame:frame];
        [self addSubview:self.scrollerview];
        self.scrollerview.backgroundColor = [UIColor yellowColor];
        self.scrollerview.showsHorizontalScrollIndicator = NO;
        self.scrollerview.showsVerticalScrollIndicator = NO;
        /**设置的是有两张假图，然后默认是一共加载三张图片 */
        self.scrollerview.contentSize = CGSizeMake(frame.size.width * 5, frame.size.height);
        self.scrollerview.contentOffset = CGPointMake(self.scrollerview.frame.size.width, 0);
        self.scrollerview.delegate = self;
        self.scrollerview.pagingEnabled = YES;
        /**初始化pager */
        /**尺寸可能需要改 */
        frame.size = CGSizeMake(frame.size.width - 40, 20);
        frame.origin = CGPointMake(20, self.frame.size.height - 30);
        self.pager = [[UIPageControl alloc]initWithFrame:frame];
        [self addSubview:self.pager];
        [self.pager addTarget:self action:@selector(pageValueChanged:) forControlEvents:UIControlEventValueChanged];
//        /**考虑到时间栏的处理使用一层背景蒙版*/
//        frame = CGRectMake(0, 0, frame.size.width, 20);
//        UIView *backView = [[UIView alloc]initWithFrame:frame];
//        [self addSubview:backView];
//        backView.backgroundColor = [UIColor whiteColor];
//        backView.alpha = 0.3;
        /**在初始化的时候是定时器运行，这样的话定时器只会运行一次 */
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:self.holderTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    /**暂停计时器 */
    if (self.timer != nil) {
        /**想要实现定时器的赞同和开启需要使用的停止方法 */
        NSLog(@"暂停定时器");
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    else{
        NSLog(@"计时器有bug");
    }
    /**设置状态是手滑状态 */
    self.istouches = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    /**在这里写跳转假图的逻辑 */
    //    NSLog(@"%f",self.scrollerview.contentOffset.x);
    /**number显示的是具体的图片的数量 */
    NSInteger number = self.scrollerview.contentSize.width / self.scrollerview.frame.size.width - 2;
    if (self.scrollerview.contentOffset.x == 0 ) {
        /**想要看最后一张图 */
        [self.scrollerview setContentOffset:CGPointMake(self.scrollerview.contentSize.width - 2 * self.frame.size.width, 0)];
        self.pager.currentPage = number - 1;
    }else if (self.scrollerview.contentOffset.x == self.scrollerview.contentSize.width - self.scrollerview.frame.size.width){
        /**想要看第一张图 */
        self.scrollerview.contentOffset = CGPointMake(self.frame.size.width, 0);
        self.pager.currentPage = 0;
    }else{
        NSInteger index = self.scrollerview.contentOffset.x / self.scrollerview.frame.size.width - 1;
//        NSLog(@"%ld",index);
        self.pager.currentPage = index;
    }
//    if (self.timer != nil) {
//        NSLog(@"延时执行计时器");
//        /**考虑是不是要在这创建一个延时定时器来确定这个定时器的开启和关闭 */
//        /**想要实现定时器的赞同和开启需要使用的开始方法 */
//        [[NSRunLoop currentRunLoop] addTimer:self.holderTimer forMode:NSDefaultRunLoopMode];
//    }
}

- (void)pageValueChanged:(UIPageControl *)pager{
    /**根据pager上值得改变动态修改上面相框的图片的位置
       注：第一张图片的configsett的值是width
       注：pager的最小值是0；
     */
    NSInteger pagerNumber = pager.currentPage + 1;
    CGPoint contentOffset = CGPointMake(self.frame.size.width * pagerNumber, self.frame.size.height);
    /**设置带动画的跳转 */
    [self.scrollerview setContentOffset:contentOffset animated:YES];
}

/**
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 [[self nextResponder] touchesBegan:touches withEvent:event];
 [super touchesBegan:touches withEvent:event];
 }
 使用了scrollerview之后需要重写touchbegin方法才能使其中的相框响应touchbegin的处理
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /**在touchbegin中通过偏移量判断点击了哪张图片从而确定对应的跳转网址 */
    CGPoint touchSet = [[touches anyObject] locationInView:self.scrollerview];
    CGFloat boderPointX = self.scrollerview.contentSize.width - self.scrollerview.frame.size.width;
    if (touchSet.x < self.frame.size.width || touchSet.x > boderPointX) {
        /**由于某种原因点击了两张假图的位置 ， 无效的操作 */
    }else{
        /**根据偏移量确定的点击的图片的index */
        NSInteger index = (NSInteger)touchSet.x / self.scrollerview.frame.size.width - 1;
        LWSModelFirst *model = self.models[index];
        /**在这里写跳转的方法
           预计使用block的方式
           在对应的界面自行对block进行处理*/
        if (self.touchX != touchSet.x) {
            self.block(model);
            self.touchX = touchSet.x;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /**在touchbegin中通过偏移量判断点击了哪张图片从而确定对应的跳转网址 */
//    CGPoint touchSet = [[touches anyObject] locationInView:self.scrollerview];
//    CGFloat boderPointX = self.scrollerview.contentSize.width - self.scrollerview.frame.size.width;
//    if (touchSet.x < self.frame.size.width || touchSet.x > boderPointX) {
//        /**由于某种原因点击了两张假图的位置 ， 无效的操作 */
//    }else{
//        /**根据偏移量确定的点击的图片的index */
//        NSInteger index = (NSInteger)touchSet.x / self.scrollerview.frame.size.width - 1;
//        LWSModelFirst *model = self.models[index];
//        /**在这里写跳转的方法
//         预计使用block的方式
//         在对应的界面自行对block进行处理*/
//        self.block(model);
//    }
}


- (void)layoutSubviews{
    /**设置scrollerview等的相关属性 */
    
}

@end
