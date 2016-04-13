//
//  LWSWarnView.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/14.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSWarnView.h"
#import "LWSCoculateSize.h"

@interface LWSWarnView ()

@property (nonatomic , retain)UILabel *label;
@property (nonatomic , retain)UIImageView *imageView;

@end

@implementation LWSWarnView

/*加阴影--任海丽编辑
_imageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
_imageView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
_imageView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
_imageView.layer.shadowRadius = 4;//阴影半径，默认3
 */

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = _image;
}

- (void)setWarnString:(NSString *)warnString{
    _warnString = warnString;
    CGFloat width = self.frame.size.width - 20;
    CGFloat height = [LWSCoculateSize getCurrentLabelHeightByLabelText:_warnString Font:self.label.font LabelWidth:width];
    CGRect frame = CGRectMake(0, 0, width, height);
    self.label.frame = frame;
    CGPoint center = self.center;
    self.label.center = center;
    self.label.text = _warnString;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(frame.size.width - 4, frame.size.height - 4);
        frame.origin = CGPointMake(2, 2);
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        self.imageView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.imageView.layer.shadowOffset = CGSizeMake(4,4);
        self.imageView.layer.shadowOpacity = 0.7;
        self.imageView.layer.shadowRadius = 4;
        [self addSubview:self.imageView];
        self.imageView.userInteractionEnabled = YES;
        
        /**设置警告的label */
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.textColor = [UIColor yellowColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        self.label.userInteractionEnabled = YES;
    }
    return self;
}

/**在touchBegin方法中添加界面消失的特效以及移除画面的方法 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = @1;
    scale.toValue = @0.1;
    scale.repeatCount = 1;
    scale.duration = 1.0;
    
    CABasicAnimation *opacity = [CABasicAnimation animation];
    opacity.keyPath = @"opacity";
    opacity.fromValue = @1;
    opacity.toValue = @0.1;
    opacity.repeatCount = 1;
    opacity.duration = 1.0;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.duration = 1.0;
    group.animations = @[scale , opacity];
    [self.layer addAnimation:group forKey:nil];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(removeAnimation) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [self.layer removeAllAnimations];
//    [self removeFromSuperview];
}

- (void)removeAnimation{
    [self removeFromSuperview];
    [self.layer removeAllAnimations];
    self.disBlock(YES);
}

@end
