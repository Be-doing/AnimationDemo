//
//  MapLoctionAnimationView.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/12/4.
//

#import "MapLoctionAnimationView.h"
@interface MapLoctionAnimationView ()
@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, strong) UIScrollView *mapView;

@end

@implementation MapLoctionAnimationView


- (instancetype)initWithFrame:(CGRect)frame AndParentVC:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _parentVC = controller;
        [self addSubview:self.mapView];
        [self animationAction];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)animationAction {
    [self startAnimationWithBeginTime:CACurrentMediaTime()];
    [self startAnimationWithBeginTime:CACurrentMediaTime() + 0.92];
    [self startAnimationWithBeginTime:CACurrentMediaTime()+1.84];
}

- (void)startAnimationWithBeginTime:(CFTimeInterval)time {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100.0, 100.0)];
    [self addSubview:view];
    CAShapeLayer *layer = [self getCircleLayerConfig];
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAni. fromValue = @(0);
    scaleAni.toValue = @(1);
    CABasicAnimation *alphaAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAni.fromValue = @(0.8);
    alphaAni.toValue = @(0.0);
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scaleAni, alphaAni];
    group.duration = 2.76;
    group.repeatCount = 10;
    group.beginTime = time;
    group.fillMode = kCAFillModeBoth;
    [view.layer addAnimation:group forKey:nil];
    [view.layer addSublayer:layer];
}

- (CAShapeLayer *)getCircleLayerConfig {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100.0, 100.0)].CGPath;
    circleLayer.fillColor = [UIColor orangeColor].CGColor;
    return circleLayer;
}

- (UIScrollView *)mapView {
    if (!_mapView) {
        _mapView = [[UIScrollView alloc] initWithFrame:self.frame];
        // 是否滚动
        _mapView.scrollEnabled = YES;
        // 是否有弹簧效果
        _mapView.bounces = YES;
        // 是否横向或者纵向弹动
        _mapView.alwaysBounceVertical = YES;
        _mapView.alwaysBounceHorizontal = YES;
        // 是否按页滚动
        _mapView.pagingEnabled = NO;
        // 是否隐藏滚动进度条
        _mapView.showsHorizontalScrollIndicator = NO;
        _mapView.showsVerticalScrollIndicator = NO;
        _mapView.zoomScale = 1.0;
        _mapView.minimumZoomScale = 0.5; // 最小缩放比例
        _mapView.maximumZoomScale = 5.0; // 最大缩放比例
        _mapView.contentSize = CGSizeMake(1500, 1500);
        _mapView.layer.contents = (__bridge id)[UIImage imageNamed:@"map"].CGImage;
        _mapView.layer.contentsGravity = kCAGravityResizeAspectFill;
    }
    return _mapView;
}

@end
