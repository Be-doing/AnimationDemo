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
            @"name":@"UIView视图动画"
        },@{
            @"type":@2,
            @"name":@"CA基础动画"
        },@{
            @"type":@3,
            @"name":@"CA帧动画"
        },@{
            @"type":@4,
            @"name":@"CA转场动画"
        }];
    return [[self class] paese:dic];
}

@end
