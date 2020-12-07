//
//  UnlockAnimationView.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/27.
//

#import "TrashAnimationView.h"
#import "Masonry.h"
#import "RYSectorAnimationView.h"
@interface TrashAnimationView ()

@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, assign) CGRect keyOriginalFrame;
@property (nonatomic, strong) UIImageView *planeView;
@property (nonatomic, strong) RYSectorAnimationView *sectorView;
@property (nonatomic, assign) CGFloat radius;
@end

@implementation TrashAnimationView
- (instancetype)initWithFrame:(CGRect)frame AndParentVC:(UIViewController *)controller {
    if (self = [super initWithFrame:frame]) {
        _parentVC = controller;
        _radius = 100;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sectorView];
        [self addSubview:self.planeView];
        [self.planeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
    }
    return self;
}

- (UIImageView *)planeView {
    if (!_planeView) {
        _planeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plane"]];
        _planeView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        [_planeView addGestureRecognizer:pan];
    }
    return _planeView;
}

- (RYSectorAnimationView *)sectorView {
    if (!_sectorView) {
        _sectorView = [[RYSectorAnimationView alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.width) WithRadius:_radius WithColor:[UIColor redColor]];
        _sectorView.alpha = 0;
    }
    return _sectorView;
}


- (void)handlePan:(UIPanGestureRecognizer *) pan {
    UIView *view = pan.view;
    CGPoint translatePoint = [pan translationInView:view];
    view.center = CGPointMake(view.center.x + translatePoint.x, view.center.y + translatePoint.y);

    
    [pan setTranslation:CGPointZero inView:view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.24 animations:^{
            self.sectorView.alpha = 1.0;
        }];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat planeX = view.frame.origin.x;
        CGFloat planeY = view.frame.origin.y;
        CGFloat diff = hypotf(planeX, planeY);
        if (diff <= 200.0) {
            _radius = (200 - diff/2) < 150 ? (200 - diff/2) : 150;
        }
        [self.sectorView changeSizeWithRadius:_radius];
    } else if (pan.state == UIGestureRecognizerStateEnded ||
               pan.state == UIGestureRecognizerStateCancelled) {
        _radius = 100;
        [UIView animateWithDuration:0.24 animations:^{
            self.sectorView.alpha = 0.0;
        }];
    }
}
@end
