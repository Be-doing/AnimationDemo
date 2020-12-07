//
//  RYAnimationDataHolder.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/25.
//

#import "RYAnimationDataHolder.h"
#import "RYAnimationDataModel.h"

@interface RYAnimationDataHolder ()

@end

@implementation RYAnimationDataHolder

+ (NSArray *)paese:(NSArray *)data {
    NSMutableArray *arr = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in data) {
            
            NSNumber *type = dic[@"type"];
            if ([type isKindOfClass:[NSNumber class]]) {
                RYAnimationModel *model = [RYAnimationModel new];
                model.animationType = [type unsignedIntegerValue];
                model.animationName = dic[@"name"];
                [arr addObject:model];
            }
        }
        return [NSArray arrayWithArray:arr];
    }
    return nil;
}

+ (NSArray *)getAnimationData {
    NSArray *dic = @[
        @{
            @"type":@1,
            @"name":@"导航栏动画"
        },@{
            @"type":@2,
            @"name":@"垃圾桶动画"
        },@{
            @"type":@3,
            @"name":@"地图定位波动动画"
        },@{
            @"type":@4,
            @"name":@"过渡动画"
        },@{
            @"type":@5,
            @"name":@"加载动画"
        },@{
            @"type":@6,
            @"name":@"进度条动画"
        }];
    return [[self class] paese:dic];
}

@end
