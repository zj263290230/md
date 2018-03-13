# Objective-c 实现快速排序

## 一、快排简介
快速排序也是基于值比较，然后交换的思路，同时基于二分的思想来实现的，简单的说就是将一个大的问题通过不断的一分为二化简为较小的问题来解决排序问题

## 二、时间复杂度
1、 最差时间复杂度为O(n^2)
2、 平均时间复杂度为O（nlogn）

## 三、Objective-C 实现
```
- (void)quickSortWithArray:(NSMutableArray *)array left:(NSInteger)left right:(NSInteger)right {
    //数组不需要排序
    if (left >= right)
        return;

    //数组第一个位置
    NSInteger i = left;
    //数组最后一个位置
    NSInteger j = right;
    //将第一个位置的<value>作为---基准
    NSInteger base = [array[left] integerValue];

    while (i != j) {
        //从后往前走, 直到找到 小于 <基准> 的数字, 此时 j 保存那个数字的下标位置
        while (i < j && base <= [array[j] integerValue]) {
            j--;
        }
        //再从前往后走, 直到找到 大于 <基准> 的数字, 此时 i 保存那个数字的下标位置
        while (i < j && base >= [array[i] integerValue]) {
            i++;
        }
        //互换位置
        if (i < j) {
            [array exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    //最终将基准数归位, 因为i == j, 需要将<基数所在位置的value>与<i/j相等的位置的value>互换位置
    [array exchangeObjectAtIndex:i withObjectAtIndex:left];
    
    //继续左边的排序
    [self quickSortWithArray:array withLeft:left andRight:i - 1];
    //继续右边的排序
    [self quickSortWithArray:array withLeft:i + 1 andRight:right];
}
```