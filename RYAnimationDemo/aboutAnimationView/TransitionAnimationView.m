//
//  TransitionAnimationView.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/12/4.
//

#import "TransitionAnimationView.h"
@interface TransitionAnimationView ()

@end
@implementation TransitionAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/**

 1.初始化
 CATransition  *transition = [CATransition animation];
 2.设置动画时长,设置代理人
 transition.duration = 1.0f;
 transition.delegate = self;
 3.设置切换速度效果
 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 枚举值:
 kCAMediaTimingFunctionLinear
 kCAMediaTimingFunctionEaseIn
 kCAMediaTimingFunctionEaseOut
 kCAMediaTimingFunctionEaseInEaseOut
 kCAMediaTimingFunctionDefault
 4.动画切换风格
 transition.type = kCATransitionFade;
 枚举值:
 kCATransitionFade = 1,     // 淡入淡出
 kCATransitionPush,         // 推进效果
 kCATransitionReveal,       // 揭开效果
 kCATransitionMoveIn,       // 慢慢进入并覆盖效果
 5.动画切换方向
 transition.subtype = kCATransitionFromTop;//顶部
 枚举值:
 kCATransitionFromRight//右侧
 kCATransitionFromLeft//左侧
 kCATransitionFromTop//顶部
 kCATransitionFromBottom//底部
 6.进行跳转
 [self.navigationController.view.layer addAnimation:transition forKey:nil];
 [self.navigationController pushViewController:"你要跳转的页面" animated:NO];
 跳转动画一定设置为NO,不然会两个效果叠加
 */
- (instancetype)initWithFrame:(CGRect)frame AndParentVC:(UIViewController *)controller {
    if (self = [super initWithFrame:frame]) {
        UIView *animationView = [[UIView alloc]initWithFrame:frame];
        //animationView.frame = CGRectMake(200, kHeight/2-50, 50, 50);
        animationView.backgroundColor = [UIColor greenColor];
        [self addSubview:animationView];
        
        CATransition *anima = [CATransition animation];
        anima.type = kCATransitionPush;
        anima.subtype = kCATransitionFromRight;
        anima.duration = 2.0f;
        [animationView.layer addAnimation:anima forKey:@"transitionAnimation"];

    }
    return self;
}

@end
