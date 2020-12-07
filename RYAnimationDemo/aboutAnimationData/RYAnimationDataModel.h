//
//  RYAnimationDataModel.h
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RYAnimationType) {
    RYAnimationTypeUIView = 1,  // UIView封装的动画
    RYAnimationTypeBasic,       // CA基础动画
    RYAnimationTypeKeyframe,    // CA帧动画
    RYAnimationTypeTransition   // 专场动画
};

@interface RYAnimationModel : NSObject
@property (nonatomic, assign) RYAnimationType animationType;
@property (nonatomic, copy) NSString *animationName;
@end

@interface RYAnimationDataModel : NSObject
@property (nonatomic, copy) NSArray<RYAnimationModel *> *animationData;
@end

NS_ASSUME_NONNULL_END
