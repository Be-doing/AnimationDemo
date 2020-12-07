//
//  RYAnimationDataModel.h
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RYAnimationType) {
    RYAnimationTypeNavigation = 1,  // 导航栏动画
    RYAnimationTypeTrash,           // 垃圾桶动画
    RYAnimationTypeMapPoint,        // 定位波动动画
    RYAnimationTypeTransition,      // 过渡动画
    RYAnimationTypeLoading,         // 加载动画
    RYAnimationTypeProcessing,      // 进度条动画
    RYAnimationTypeGradients,       // 渐变动画
    RYAnimationTypeOther            // 占位
    
};

@interface RYAnimationModel : NSObject
@property (nonatomic, assign) RYAnimationType animationType;
@property (nonatomic, copy) NSString *animationName;
@end

@interface RYAnimationDataModel : NSObject
@property (nonatomic, copy) NSArray<RYAnimationModel *> *animationData;
@end

NS_ASSUME_NONNULL_END
