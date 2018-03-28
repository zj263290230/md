//
//  FoodFactory.h
//  简单工厂模式
//
//  Created by zj on 2018/3/29.
//  Copyright © 2018年 paddington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface FoodFactory : NSObject

+ (Product *)produceFoodWithFoodType:(ProductType)productType;

@end
