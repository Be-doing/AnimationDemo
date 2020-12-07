//
//  LoadingAnimationView.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/12/5.
//

#import "LoadingAnimationView.h"
#import "Masonry.h"
@interface LoadingAnimationView ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *successButton;
@property (nonatomic, strong) UIButton *faildButton;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) CAShapeLayer *animationLayer;

@end

@implementation LoadingAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame AndParentVC:(UIViewController *)controller {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    return self;
}


- (void)setUpSubViews {
    _startButton = [[UIButton alloc] init];
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    _startButton.backgroundColor = [UIColor orangeColor];
    _startButton.layer.cornerRadius = 5.f;
    [_startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _closeButton = [[UIButton alloc] init];
    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    _closeButton.backgroundColor = [UIColor orangeColor];
    _closeButton.layer.cornerRadius = 5.f;
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _successButton = [[UIButton alloc] init];
    [_successButton setTitle:@"成功" forState:UIControlStateNormal];
    _successButton.backgroundColor = [UIColor orangeColor];
    _successButton.layer.cornerRadius = 5.f;
    [_successButton addTarget:self action:@selector(successButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _faildButton = [[UIButton alloc] init];
    [_faildButton setTitle:@"失败" forState:UIControlStateNormal];
    _faildButton.backgroundColor = [UIColor orangeColor];
    _faildButton.layer.cornerRadius = 5.f;
    [_faildButton addTarget:self action:@selector(faildButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _animationView = [[UIView alloc] init];
    _animationView.backgroundColor = [UIColor blackColor];
    _animationView.layer.cornerRadius = 10;
    
    [self addSubview:_startButton];
    [self addSubview:_closeButton];
    [self addSubview:_successButton];
    [self addSubview:_faildButton];
    [self addSubview:_animationView];
    
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(self->_animationView);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(self->_animationView);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    [_successButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.bottom.mas_equalTo(self->_animationView);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    [_faildButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(self->_animationView);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    
}

- (CAShapeLayer *)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.lineWidth = 5;
        _animationLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _animationLayer;
}

#pragma mark -- 默认的动画
- (CAAnimationGroup *)animationWithRepeat:(CGFloat)repeat{
    
    // 第一个满圆旋转动画
    
    CABasicAnimation *aniamtion1 = [CABasicAnimation animation];
    aniamtion1.keyPath = @"strokeEnd";
    aniamtion1.fromValue = @0;
    aniamtion1.toValue = @1;
    aniamtion1.duration = 1.5;
    aniamtion1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    // 第二个檫除路径路径动画
    CABasicAnimation *aniamtion2 = [CABasicAnimation animation];
    aniamtion2.keyPath = @"strokeStart";
    aniamtion2.fromValue = @0;
    aniamtion2.toValue = @1;
    aniamtion2.duration = 1.5;
    aniamtion2.beginTime = 1.5;
    aniamtion2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 
    
    // 最后合并到动画组当前去
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations =@[aniamtion1,aniamtion2];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.fillMode = kCAFillModeBoth;
    group.duration = 3;
    group.repeatCount = repeat;
    return group;
  
}

#pragma mark - button action

- (void)startButtonAction:(UIButton *)sender {
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50,50) radius:45 startAngle:M_PI*3/2 endAngle:M_PI*7/2 clockwise:YES];
    self.animationLayer.path = circle.CGPath;
    [self.animationView.layer addSublayer:self.animationLayer];
    [self.animationLayer addAnimation:[self animationWithRepeat:MAXFLOAT] forKey:nil];
}

- (void)closeButtonAction:(UIButton *)sender {
    if (_animationLayer) {
        [_animationLayer removeFromSuperlayer];
    }
}

- (void)successButtonAction:(UIButton *)sender {
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50,50) radius:45 startAngle:M_PI*3/2 endAngle:M_PI*7/2 clockwise:YES];
    UIBezierPath *subPath  = [UIBezierPath bezierPath];
    [subPath moveToPoint:CGPointMake(27.5,50)];
    [subPath addLineToPoint:CGPointMake(50,72.5)];
    [subPath addLineToPoint:CGPointMake(83.75,38.75)];
    [circle appendPath:subPath];
    if (_animationLayer) {
        [_animationLayer removeFromSuperlayer];
        _animationLayer = nil;
    }
    self.animationLayer.path = circle.CGPath;
    [self.animationView.layer addSublayer:self.animationLayer];
    [self.animationLayer addAnimation:[self animationWithRepeat:1.0] forKey:nil];
}

- (void)faildButtonAction:(UIButton *)sender {
    
}
@end
