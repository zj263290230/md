//
//  Product.h
//  简单工厂模式
//
//  Created by zj on 2018/3/28.
//  Copyright © 2018年 paddington. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ProductType) {
    ProductTypeUnKnown, //默认从0开始
    ProductTypeFood,
    ProductTypeMilk,
    ProductTypeMeat,
};

@interface Product : NSObject

- (void)say;

@end
