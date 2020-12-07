//
//  BlockAnimationView.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/25.
//

#import "NavigationAnimationView.h"

@interface NavigationAnimationView ()
@property (nonatomic, strong) UILabel *testView;
@property (nonatomic, strong) UIViewController *parentVC;
@end

@implementation NavigationAnimationView

- (instancetype)initWithFrame:(CGRect)frame AndParentVC:(UIViewController *)controller{
    if (self = [super initWithFrame:frame]) {
        _parentVC = controller;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    UIButton *sampleAni = [self getButtonWithTitle:@"简单Block的动画" AndFrame:CGRectMake(10, 200, self.frame.size.width - 20, 50)];
    sampleAni.tag = 1001;
    [sampleAni addTarget:self action:@selector(aniButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *complationAni = [self getButtonWithTitle:@"带完成回调的动画" AndFrame:CGRectMake(10, 300, self.frame.size.width - 20, 50)];
    complationAni.tag = 1002;
    [complationAni addTarget:self action:@selector(aniButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *optionsAni = [self getButtonWithTitle:@"带过渡效果的动画" AndFrame:CGRectMake(10, 400, self.frame.size.width - 20, 50)];
    optionsAni.tag = 1003;
    [optionsAni addTarget:self action:@selector(aniButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:sampleAni];
    [self addSubview:complationAni];
    [self addSubview:optionsAni];
    [self addSubview:self.testView];
}

- (UIButton *)getButtonWithTitle:(NSString *)title AndFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor orangeColor];
    button.layer.cornerRadius = 10;
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

#pragma mark - animation

- (void)aniButtonAction:(UIButton *)sender {
    
    //CGAffineTransform transform = CGAffineTransformIdentity;
    if (sender.tag == 1001) {
        [UIView animateWithDuration:2  // 动画持续时间
                      animations:^{    // 执行的动画
            self.testView.transform = CGAffineTransformMakeTranslation(0, 100);
            //self.testView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            //self.testView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
         }];
    } else if (sender.tag == 1002) {
        [UIView animateWithDuration:2  //动画持续时间
                     animations:^{     //执行的动画
            self.testView.transform = CGAffineTransformMakeTranslation(0, 0);
        }            completion:^(BOOL finished) { //动画执行提交后的操作
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"带完成回调的动画完成" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self.parentVC presentViewController:alert animated:YES completion:nil];
        }];
    } else if (sender.tag == 1003) {
        [UIView animateWithDuration:2  // 动画持续时间
                           delay:1     // 动画延迟执行的时间
                         options: UIViewAnimationOptionCurveLinear //动画的过渡效果
                      animations:^{    // 执行的动画
            self.testView.transform = CGAffineTransformMakeRotation(M_PI / 2);
         }            completion:^(BOOL finished) { // 动画执行提交后的操作
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"带过渡效果的动画完成" message:@"" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             [alert addAction:cancelAction];
             [alert addAction:okAction];
             [self.parentVC presentViewController:alert animated:YES completion:nil];
         }];
        /**
         UIViewAnimationOptionLayoutSubviews            //进行动画时布局子控件
         UIViewAnimationOptionAllowUserInteraction      //进行动画时允许用户交互
         UIViewAnimationOptionBeginFromCurrentState     //从当前状态开始动画
         UIViewAnimationOptionRepeat                    //无限重复执行动画
         UIViewAnimationOptionAutoreverse               //执行动画回路
         UIViewAnimationOptionOverrideInheritedDuration //忽略嵌套动画的执行时间设置
         UIViewAnimationOptionOverrideInheritedCurve    //忽略嵌套动画的曲线设置
         UIViewAnimationOptionAllowAnimatedContent      //转场：进行动画时重绘视图
         UIViewAnimationOptionShowHideTransitionViews   //转场：移除（添加和移除图层的）动画效果
         UIViewAnimationOptionOverrideInheritedOptions  //不继承父动画设置

         UIViewAnimationOptionCurveEaseInOut            //时间曲线，慢进慢出（默认值）
         UIViewAnimationOptionCurveEaseIn               //时间曲线，慢进
         UIViewAnimationOptionCurveEaseOut              //时间曲线，慢出
         UIViewAnimationOptionCurveLinear               //时间曲线，匀速

         UIViewAnimationOptionTransitionNone            //转场，不使用动画
         UIViewAnimationOptionTransitionFlipFromLeft    //转场，从左向右旋转翻页
         UIViewAnimationOptionTransitionFlipFromRight   //转场，从右向左旋转翻页
         UIViewAnimationOptionTransitionCurlUp          //转场，下往上卷曲翻页
         UIViewAnimationOptionTransitionCurlDown        //转场，从上往下卷曲翻页
         UIViewAnimationOptionTransitionCrossDissolve   //转场，交叉消失和出现
         UIViewAnimationOptionTransitionFlipFromTop     //转场，从上向下旋转翻页
         UIViewAnimationOptionTransitionFlipFromBottom  //转场，从下向上旋转翻页
         */
    }
    //self.testView.transform = CGAffineTransformIdentity;
    NSLog(@"x == %lf",self.testView.frame.origin.x);
    NSLog(@"y == %lf",self.testView.frame.origin.y);
    NSLog(@"w == %lf",self.testView.frame.size.width);
    NSLog(@"h == %lf",self.testView.frame.size.height);
}


#pragma mark - getter
- (UILabel *)testView {
    if (!_testView) {
        _testView = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, self.frame.size.width - 20, 100)];
        _testView.backgroundColor = [UIColor orangeColor];
        _testView.layer.cornerRadius = 10;
        _testView.text = @"左边^-->";
    }
    return _testView;
}

@end
