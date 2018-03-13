# Objective-C 实现插入排序

## 一、插入排序

插入排序是一种简单的排序方法，实现的思想是每次讲一个未排序的元素插入到已排好序的元素的合适位置中去

## 二、时间复杂度
1、最差时间复杂度为O（n^2）
2、平均时间复杂度为O（n^2）

## 三、实现方法
1、 将数组中的第一个元素取出，做为已排序的第一个元素
2、 将数组中的下一个元素取出，与已排序的数组中元素挨个比较，放入合适的位置
3、 循环操作2步骤，直至数组元素都已处理


## Objective-C 实现
```
- (void)insertSort:(NSMutableArray *)array {
    if (!array.count)
		return;
		
    for (int i = 0; i < array.count; i++) {
        for (int j = i; j > 0; j--) {
            if (array[j] < array[j - 1]) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j - 1];
            } else {
                break;
            }
        }
    }
}
```


