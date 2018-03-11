# Objective-c 实现冒泡排序

## 一、冒泡算法简介

冒泡算法是一种基础的排序算法，这种算法会重复比较数组中相邻的两个元素。如果一个元素比另一个元素大（小），那么久交换着两个元素的位置。重复这一操作直至最后一个元素，这样一次处理之后总能找到未排序元素中最大或者最小的那个数字。

## 二、冒泡排序的时间复杂度
1、 最差时间复杂度为O（n^2）
2、 平均时间复杂度为O（n^2）


## 三、实现思路
1. 每一趟都比较数组中两个相邻元素的大小
2. 如果第i个元素比第i-1个元素大(小)，则交换两个元素的位置
3. 重复n-1比较

## 四、代码实现

```
- (void)bubbleSort:(NSMutableArray *)array {
	if (!array.count)
		return;

	for (int i = 0; i < array.count; i++) {
		for (int j = 1; j < array.count - 1; j++) {
			if ([array[j] integerValue] < [array[j-1] integerValue]) {
				id temp = array[j];
				array[j] = array[j - 1];
				array[j-1] = temp;
			}
		}
	}
}
```