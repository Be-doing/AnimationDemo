//
//  RYSectorAnimationView.h
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RYSectorAnimationView : UIView
/**
 初始化一个扇形，中心点为(0,0)
 @param frame            view的大小
 @param radius          初始半径
 @param color            扇形颜色
 */
- (instancetype)initWithFrame:(CGRect)frame
                   WithRadius:(CGFloat)radius
                    WithColor:(UIColor *)color;

/**
 通过更改半径大小
 @param radius          半径
 */
- (void)changeSizeWithRadius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
