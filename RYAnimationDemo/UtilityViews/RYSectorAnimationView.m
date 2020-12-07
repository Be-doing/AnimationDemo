//
//  RYSectorAnimationView.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/30.
//

#import "RYSectorAnimationView.h"


@interface RYSectorAnimationView ()

@property (nonatomic, assign) CGFloat maxRadius;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *fillColor;

@end

@implementation RYSectorAnimationView

- (instancetype)initWithFrame:(CGRect)frame
                   WithRadius:(CGFloat)radius
                    WithColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
//        [CATransaction begin];
//        [CATransaction setDisableActions:NO];
//        [CATransaction commit];
        _fillColor = color;
        _cornerRadius = radius;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        _maxRadius = width > height ? height : width;
        if (radius > _maxRadius) {
            _cornerRadius = _maxRadius;
        }
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)changeSizeWithRadius:(CGFloat)radius {
    if (radius <= 0 || radius > _maxRadius) {
        return;
    }
    _cornerRadius = radius;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:_cornerRadius startAngle:0 endAngle:M_PI/2.0 clockwise:YES];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path closePath];
    path.lineWidth = 5.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [_fillColor set];
    [path fill];
}


@end
