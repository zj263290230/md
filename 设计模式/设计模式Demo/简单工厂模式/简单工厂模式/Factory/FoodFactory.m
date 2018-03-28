//
//  FoodFactory.m
//  简单工厂模式
//
//  Created by zj on 2018/3/29.
//  Copyright © 2018年 paddington. All rights reserved.
//

#import "FoodFactory.h"
#import "Food.h"
#import "Meat.h"
#import "Milk.h"

@implementation FoodFactory

+ (Product *)produceFoodWithFoodType:(ProductType)productType {
    if (productType == ProductTypeUnKnown) {
        NSLog(@"产品不存在");
        return nil;
    } else if (productType == ProductTypeFood) {
        return [[Food alloc] init];
    } else if (productType == ProductTypeMilk) {
        return [[Milk alloc] init];
    } else if (productType == ProductTypeMeat) {
        return [[Meat alloc] init];
    }
    return nil;
}

@end
