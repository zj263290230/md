# 深入理解Objective-C:category

## 简介
category 是oc2.0之后添加的语言特性，category的主要作用是为已经存在的类添加方法，除此之外，apple还推荐了另外两个使用场景：

* 可以把类的实现分散在几个不同的文件里面。好处有 1）减少单个文件的体积 2）可以把不同的功能组织到不同的category中 3）可以由多个卡发着共同完成一个类 4)可以按需加载category等
* 声明私有方法

不过除了上面推荐的场景，还衍生出了其他的几个使用场景：

* 模拟多继承
* 把framework的私有方法公开

## category和extension
extension 看起来像一个匿名的category，但是完全是两个东西

extension 在编译器确定，它就是类的一部分，在编译期和头文件中的@interface 以及实现文件中的@implement一起形成一个完整的类，它随着类的产生而产生，消亡而消亡。extension用来隐藏类的私有信息，并且必须有一个类的源码才能为一个类添加extension。

category则完全不一样，它是在运行期确定。
所以说extension可以添加实例变量，但是category是无法添加实例变量的（在运行期时，对象的内存布局已经确定，如果添加实例变量就会破会类的内部布局，对编译型语言来说是不允许的）

## category 真面目

我们知道，所有的OC类和对象，在runtime层都是struct表示的，category也不例外，category就是用结构体category_t来表示的,它包含了：
* 类的名字 （name）
* 类 (cls)
* category中所有给类添加的实例方法的列表(instanceMethods)
* category中所有添加的类方法的列表(classMethods)
* category实现的所有协议的列表(protocols)
* category中添加的所有属性(instanceProperties)

```
typedef struct category_t {
	const char *name;
	classref_t cls;
	struct method_list_t *instanceMethods;
	struct method_list_t *classMethods;
	struct protocol_list_t *protocols;
	struct property_list_t *instanceProperties;
} category_t
```
从category_t的定义我们也可以看出，其是不能添加实例变量的。

可以写一个简单的类
```
clang -rewrite-objc person.m 
```
来查看下

## category如何加载
我们知道，Objective-C的运行是依赖OC的runtime的，而OC的runtime和其他系统库一样，是OS X和iOS通过dyld动态加载的。

1)、把category的实例方法、协议以及属性添加到类上
2)、把category的类方法和协议添加到类的metaclass上

需要注意的有两点：
1)、category的方法没有“完全替换掉”原来类已经有的方法，也就是说如果category和原来类都有methodA，那么category附加完成之后，类的方法列表里会有两个methodA
2)、category的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category的方法会“覆盖”掉原来类的同名方法，这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会罢休^_^，殊不知后面可能还有一样名字的方法。

## category和+load方法
我们知道，在类和category中都可以有+load方法，那么有两个问题：
1)、在类的+load方法调用的时候，我们可以调用category中声明的方法么？
2)、这么些个+load方法，调用顺序是咋样的呢？

可以开启以下的环境参数来查看：
```
OBJC_PRINT_LOAD_METHODS
OBJC_PRINT_REPLACED_METHODS
```
可以很清楚的看到结果：
1)、可以调用，因为附加category到类的工作会先于+load方法的执行
2)、+load的执行顺序是先类，后category，而category的+load执行顺序是根据编译顺序决定的。

## category和方法覆盖
那么可以调用原来类中被category覆盖掉的方法吗？
对于这个问题，我们知道category其实并不是完全替换掉原来的方法，而是添加到方法列表的前面，所以我们只要顺着方法列表找到最后一个对应名字的方法，就是原来类的方法。
即 可使用如下代码：

```
    Class currentClass = [person class];
    person *my = [[person alloc] init];
    
    if (currentClass) {
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        IMP lastImp = NULL;
        SEL lastSel = NULL;
        for (NSInteger i = 0; i < methodCount; i++) {
            Method method = methodList[i];
            NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method))
                                                      encoding:NSUTF8StringEncoding];
            if ([@"printName" isEqualToString:methodName]) {
                lastImp = method_getImplementation(method);
                lastSel = method_getName(method);
            }
        }
        typedef void (*fn)(id,SEL);
        
        if (lastImp != NULL) {
            fn f = (fn)lastImp;
            f(my,lastSel);
        }
        free(methodList);
    }
```


## category和关联对象
如上缩减，我们知道在category里面是无法为category添加实例变量的。但是，我们很多时候需要在category中添加和对象关联的值，这个时候可以求助关联对象来实现。

.h
```
@interface person(category1)

@property (nonatomic, copy) NSString *name;
@end

```
.m 
```
@implementation person (category1)
- (void)setName:(NSString *)name {
	objc_setAssociatedObject(self,"name",name,OBJC_ASSOCIATION_COPY);

}

- (NSString *)name {
	NSString * nameObject = objc_getAssociatedObject(self,"name");
	return nameObject;
}
@end
```

但是关联对象又是存在什么地方呢？ 如何存储？ 对象销毁时候如何处理关联对象呢？

通过runtime中的 _objc_set_associative_reference可以看到一些内容：

* 所有的关联对象都是由AssociationsManager管理， 其中AssociationsManager定义如下：

```
class AssociationsManager {
	static OSSpinLock _lock;
	static AssociationsHashMap *_map;
	AssociationsManager() {OSSpinLockLock(&_lock);}
	~AssociationsManager() {OSSpinLockUnlock(&_lock);}
	AssociationsHashMap &associations() {
		if (_map == NULL) {
			_map =  new AssociationsHashMap();
		}
		return *_map;
	}
}
```

AssociationsManager里面是由一个静态的AssociationsHashMap来存储所有的关联对象的。这相当于把所有对象的关联对象都存在一个全局的map里面。而map的key就是这个对象的指针地址（任意两个不同对象的指针地址一定不同），而这个map的value又是另外一个AssociationsHashMap,里面保存了关联对象的KV对。在对象销毁的逻辑里面。  objc_runtime_new.mm中

runtime的销毁对象函数 objc_destructInstance里面会判断这个对象有没有关联对象，如果有，会调用_objc_remove_assocations做关联对象的清理工作。


### 例子见git@github.com:zj263290230/demo.git