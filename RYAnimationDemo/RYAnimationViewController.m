//
//  RYAnimationViewController.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/25.
//

#import "RYAnimationViewController.h"
#import "NavigationAnimationView.h"
#import "TrashAnimationView.h"
#import "MapLoctionAnimationView.h"
#import "TransitionAnimationView.h"
#import "LoadingAnimationView.h"
@interface RYAnimationViewController () <CALayerDelegate>

@property (nonatomic, assign) RYAnimationType animationType;
@property (nonatomic, strong) NavigationAnimationView *navAnimationView;
@property (nonatomic, strong) TrashAnimationView *lockAnimationView;
@end

@implementation RYAnimationViewController

- (instancetype)initWithType:(RYAnimationType)type {
    if (self = [super init]) {
        self.animationType = type;
        //[self setUpAnimationView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showStyleAnimationView];
}

- (void)showStyleAnimationView {
    UIView *subView = nil;
    switch (self.animationType) {
        case RYAnimationTypeNavigation:
        {
            subView = [[NavigationAnimationView alloc] initWithFrame:self.view.frame AndParentVC:self];
            
        }
            break;
        case RYAnimationTypeTrash:
        {
            subView = [[TrashAnimationView alloc] initWithFrame:self.view.frame AndParentVC:self];
            [self.view addSubview:_lockAnimationView];
        }
            break;
        case RYAnimationTypeMapPoint:
        {
            subView = [[MapLoctionAnimationView alloc] initWithFrame:self.view.frame AndParentVC:self];
        }
            break;
        case RYAnimationTypeTransition:
        {
            subView = [[TransitionAnimationView alloc] initWithFrame:self.view.frame AndParentVC:self];
        }
            break;
        case RYAnimationTypeLoading:
        {
            subView = [[LoadingAnimationView alloc] initWithFrame:self.view.frame AndParentVC:self];
        }
            break;
        default:
            break;
    }
    [self.view addSubview:subView];
}

@end
