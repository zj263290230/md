//
//  ViewController.m
//  简单工厂模式
//
//  Created by zj on 2018/3/28.
//  Copyright © 2018年 paddington. All rights reserved.
//

#import "ViewController.h"
#import "FoodFactory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Product* product1 = [FoodFactory produceFoodWithFoodType:ProductTypeMeat];
    [product1 say];
    
    Product* product2 = [FoodFactory produceFoodWithFoodType:ProductTypeFood];
    [product2 say];
    
    Product* product3 = [FoodFactory produceFoodWithFoodType:ProductTypeMilk];
    [product3 say];
}

@end
