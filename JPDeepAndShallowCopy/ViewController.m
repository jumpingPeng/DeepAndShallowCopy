//
//  ViewController.m
//  JPDeepAndShallowCopy
//
//  Created by 贾鹏 on 2015/7/19.
//  Copyright © 2015年 贾鹏. All rights reserved.
//





/*
 在Objective-C中对象之间的拷贝分为浅拷贝和深拷贝。说白了，对非容器类的浅拷贝就是拷贝对象的地址，对象里面存的内容仍然是一份，没有新的内存被分配。对非容器类的深拷贝就是重写分配一块内存，然后把另一个对象的内容原封不动的给我拿过来。对容器类的深拷贝是对容器中的每个元素都进行拷贝，容器类的浅拷贝是对容器里的内容不进行拷贝，两个容器的地址是不同的，但容器里的所装的东西是一样的，在一个容器中修改值，则另一个浅拷贝的容器中的值也会变化。所以对非容器类看对象是否为深拷贝还是浅拷贝就得看对象的内存地址就可以看出来，而对容器类，我们则进一步看容器中的内容了。因为OC中用引用计数的方式来进行内存管理的所以我们也可以通过观察对象retainCount的变化来分析对象之间是否是深拷贝还是浅拷贝。下面会通过对不同类型的对象进行测试来详细的理解一下对象的深拷贝和浅拷贝。
 
 那么对象大体都分为哪些类型呢？从可变不可变和容器类非容器类的角度可以把对象分为一下几种,那么什么是容器类呢？容器类就是用该类声明的对象可以去容纳其他对象，非容器类则没有这些功能。那么什么是可变或者不可变的呢？可变的时内存的大小是可以根据需要改变，而不可变的就是分配完以后就不可以改变他的内存空间（以上是本人的理解，不足或理解偏颇之处还请批评指正，转载本文请注明出处）
 
 1. 非容器不可变对象，比如NSString
 
 2.非容器可变对象：比如NSMutableString
 
 3.容器类不可变对象： 比如NSArray
 
 4.容器类可变对象： 比如NSMutableArray
 
 在观察深浅拷贝之前先得了解一下retain，copy和mutableCopy的特点，特点如下：
 
 1.retain：始终是浅复制。引用计数每次加一。返回对象是否可变与被复制的对象保持一致。
 
 2.copy：对于可变对象为深复制，引用计数不改变;对于不可变对象是浅复制， 引用计数每次加一。始终返回一个不可变对象。
 
 3.mutableCopy：始终是深复制，引用计数不改变。始终返回一个可变对象。
 
 */


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test5];
}


/**
 1.非容器 + 不可变对象 + retain + copy + mutableCopy
 
 代码说明:先定义一个非容器类不可变对象，然后同过retain,copy和mutableCopy的方式把值copy给一个非容器类不可变对象，最后把各个对象的地址输出，用NSString来做测试。
 */
- (void)test1{
    
    NSLog(@"非容器类不可变对象拷贝NSString");
    NSString *str = @"ludashi";
    NSLog(@" str = %@,  init_str.retainCount   = %d", str, (int)str.retainCount);
    
    //把str通过retain方式把值赋给str1
    NSString *str1 = [str retain];
    NSLog(@"str1 = %@, retain_str1.retainCount = %d",str1, (int)str1.retainCount);
    
    //把str通过copy的方式把值赋给str2
    NSString *str2 = [str copy];
    NSLog(@"str2 = %@, copy_str2.retainCount   = %d", str2, (int)str2.retainCount);
    
    //把str通过mutableCopy的方式把值赋给str3   
    NSString *str3 = [str mutableCopy];
    NSLog(@"str3 = %@, mutableCopy_str3.retainCount = %d", str3, (int)str3.retainCount);
    
    //分别输出每个字符串的内存地址
    NSLog(@" str-p = %p", str);
    NSLog(@"str1-p = %p", str1);
    NSLog(@"str2-p = %p", str2);
    NSLog(@"str3-p = %p", str3);
    
    
    
    
    /*
     2015-07-19 17:28:44.662 JPDeepAndShallowCopy[899:23726] 非容器类不可变对象拷贝NSString
     2015-07-19 17:28:44.662 JPDeepAndShallowCopy[899:23726]  str = ludashi,  init_str.retainCount   = -1
     2015-07-19 17:28:44.662 JPDeepAndShallowCopy[899:23726] str1 = ludashi, retain_str1.retainCount = -1
     2015-07-19 17:28:44.663 JPDeepAndShallowCopy[899:23726] str2 = ludashi, copy_str2.retainCount   = -1
     2015-07-19 17:28:44.663 JPDeepAndShallowCopy[899:23726] str3 = ludashi, mutableCopy_str3.retainCount = 1
     2015-07-19 17:28:44.663 JPDeepAndShallowCopy[899:23726]  str-p = 0x10bfee0e0
     2015-07-19 17:28:44.663 JPDeepAndShallowCopy[899:23726] str1-p = 0x10bfee0e0
     2015-07-19 17:28:44.663 JPDeepAndShallowCopy[899:23726] str2-p = 0x10bfee0e0
     2015-07-19 17:28:44.663 JPDeepAndShallowCopy[899:23726] str3-p = 0x600000078440

     代码运行结果分析：
     
     1. 对于非容器类的不可变对象retain和copy为浅拷贝，mutableCopy为深拷贝
     
     2. 浅拷贝获得的对象的地址和原有对象的地址一致
     
     3.而深拷贝返回新的内存地址，并且返回的对象为可变对象
     
     
     
     */
    
}






/**
 2.非容器 + 可变对象 + retain + copy + mutableCopy
 
 接下来我们来测试下非容器类的可变对象的深浅拷贝
 */
- (void)test2{
    
    NSLog(@"非容器类的可变对象拷贝");
    NSMutableString *s = [NSMutableString stringWithFormat:@"ludashi"];
    NSLog(@" s = %@,     init_s_retainCount = %d", s, (int)s.retainCount);
    
    //把s通过retain的方式把值 赋给s1;
    NSMutableString *s1 = [s retain];
    NSLog(@"s1 = %@,  retain_s1_retainCount = %d", s1, (int)s1.retainCount);
    
    //把s通过copy的方式把值赋给s2;
    NSMutableString *s2 = [s copy];
    NSLog(@"s2 = %@,    copy_s2_retianCount = %d", s2, (int)s2.retainCount);
    
    //把s通过mutableCopy的方式把值赋给s3
    NSMutableString *s3 = [s mutableCopy];
    NSLog(@"s3 = %@, mutable_s3_retainCount = %d", s3, (int)s3.retainCount);
    
    
    //打印每个非容器类可变对象的地址
    NSLog(@" s_p = %p", s);
    NSLog(@"s1_p = %p", s1);
    NSLog(@"s2_p = %p", s2);
    NSLog(@"s3_p = %p", s3);
    
    
    /**
     2015-07-19 17:31:47.807 JPDeepAndShallowCopy[944:27239] 非容器类的可变对象拷贝
     2015-07-19 17:31:47.807 JPDeepAndShallowCopy[944:27239]  s = ludashi,     init_s_retainCount = 1
     2015-07-19 17:31:47.807 JPDeepAndShallowCopy[944:27239] s1 = ludashi,  retain_s1_retainCount = 2
     2015-07-19 17:31:47.807 JPDeepAndShallowCopy[944:27239] s2 = ludashi,    copy_s2_retianCount = -1
     2015-07-19 17:31:47.807 JPDeepAndShallowCopy[944:27239] s3 = ludashi, mutable_s3_retainCount = 1
     2015-07-19 17:31:47.807 JPDeepAndShallowCopy[944:27239]  s_p = 0x618000263440
     2015-07-19 17:31:47.807 JPDeepAndShallowCopy[944:27239] s1_p = 0x618000263440
     2015-07-19 17:31:47.807 JPDeepAndShallowCopy[944:27239] s2_p = 0xa6968736164756c7
     2015-07-19 17:31:47.808 JPDeepAndShallowCopy[944:27239] s3_p = 0x6180002635c0
     
     
     
     运行结果分析：
     
     1.retian对对可变对象为浅拷贝
     
     2.copy对可变对象非容器类为深拷贝
     
     3.mutableCopy对可变非容器类为深拷贝
     
     */
    
    
    
    
}






/**
 3.容器类 +  非可变对象 + retain + copy + mutableCopy
 
 下面对容器类的非可变对象进行测试，有程序的运行结果可知当使用mutableCopy时确实返回了一个新的容器（由内存地址可以看出），但从容器对象看而言是容器的深拷贝，但从输出容器中的元素是容器的浅拷贝。
 */
- (void)test3{
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"ludashi"];
    //第二种：容器类不可变对象拷贝
    NSLog(@"容器类不可变对象拷贝");
    NSArray *array = [NSArray arrayWithObjects:string, @"b", nil];
    NSLog(@" array[0] = %@,    init_array.retainCount = %d", array[0], (int)array.retainCount);
    
    //把array通过retain方式把值赋给array1
    NSArray *array1 = [array retain];
    NSLog(@"array1[0] = %@, retain_array1.retainCount = %d", array1[0], (int)array1.retainCount);
    
    //把array通过copy的方式把值赋给array2
    NSArray *array2 = [array copy];
    NSLog(@"array2[0] = %@,    copy_array.retainCount = %d", array2[0], (int)array2.retainCount);
    
    //把array通过mutableCopy方式把值赋给array3
    NSArray *array3 = [array mutableCopy];
    NSLog(@"array3[0] = %@, mutableCopy_array3.retainCount = %d", array3[0], (int)array3.retainCount);
    
    //分别输出每个地址
    NSLog(@"分别输出每个地址");
    NSLog(@" array_p = %p", array);
    NSLog(@"array1_p = %p", array1);
    NSLog(@"array2_p = %p", array2);
    NSLog(@"array3_p = %p", array3);
    
    //分别输出每个地址
    NSLog(@"分别输出拷贝后数组中第一个元素的地址");
    NSLog(@" array_p[0] = %p", array[0]);
    NSLog(@"array1_p[0] = %p", array1[0]);
    NSLog(@"array2_p[0] = %p", array2[0]);
    NSLog(@"array3_p[0] = %p", array3[0]);
    
    
    
    /**
     2015-07-19 17:42:53.482 JPDeepAndShallowCopy[1020:33311] 容器类不可变对象拷贝
     2015-07-19 17:42:53.482 JPDeepAndShallowCopy[1020:33311]  array[0] = ludashi,    init_array.retainCount = 1
     2015-07-19 17:42:53.482 JPDeepAndShallowCopy[1020:33311] array1[0] = ludashi, retain_array1.retainCount = 2
     2015-07-19 17:42:53.482 JPDeepAndShallowCopy[1020:33311] array2[0] = ludashi,    copy_array.retainCount = 3
     2015-07-19 17:42:53.482 JPDeepAndShallowCopy[1020:33311] array3[0] = ludashi, mutableCopy_array3.retainCount = 1
     2015-07-19 17:42:53.482 JPDeepAndShallowCopy[1020:33311] 分别输出每个地址
     2015-07-19 17:42:53.482 JPDeepAndShallowCopy[1020:33311]  array_p = 0x60800002cf20
     2015-07-19 17:42:53.483 JPDeepAndShallowCopy[1020:33311] array1_p = 0x60800002cf20
     2015-07-19 17:42:53.483 JPDeepAndShallowCopy[1020:33311] array2_p = 0x60800002cf20
     2015-07-19 17:42:53.483 JPDeepAndShallowCopy[1020:33311] array3_p = 0x6100000461e0
     2015-07-19 17:42:53.483 JPDeepAndShallowCopy[1020:33311] 分别输出拷贝后数组中第一个元素的地址
     2015-07-19 17:42:53.483 JPDeepAndShallowCopy[1020:33311]  array_p[0] = 0x600000260140
     2015-07-19 17:42:53.483 JPDeepAndShallowCopy[1020:33311] array1_p[0] = 0x600000260140
     2015-07-19 17:42:53.483 JPDeepAndShallowCopy[1020:33311] array2_p[0] = 0x600000260140
     2015-07-19 17:42:53.483 JPDeepAndShallowCopy[1020:33311] array3_p[0] = 0x600000260140

     */
    
}



/**
 4.容器类 +  可变对象 + retain + copy + mutableCopy
 
 下面对容器类的可变对象进行测试，copy和mutableCopy对于容器本身是深拷贝，原因是返回了一个新的容器地址，但对于容器中的元素仍然是浅拷贝。
 */
- (void)test4{
    
    
    NSLog(@"********************************************\n\n\n\n");
    //第四种：容器类的可变对象的拷贝，用NSMutableArray来实现
    NSLog(@"容器类的可变对象的拷贝");
    
    
    NSString *string = @"hrhrhrh";
    
    NSMutableArray *m_array = [NSMutableArray arrayWithObjects:string, nil];
    
    NSLog(@" m_array[0] = %@,     init_m_array_retainCount = %d", m_array[0], (int)m_array.retainCount);
    
    //把m_array通过retain把值赋给m_array1
    NSMutableArray *m_array1 = [m_array retain];
    NSLog(@"m_array1[0] = %@,  retain_m_array1_retainCount = %d", m_array1[0], (int)m_array1.retainCount);
    
    //把m_array通过copy把值赋给m_array2
    NSMutableArray *m_array2 = [m_array copy];
    NSLog(@"m_array2[0] = %@,    copy_m_array2_retainCount = %d", m_array2[0], (int)m_array2.retainCount);
    
    //把m_array通过mytableCopy把值赋给m_array3
    NSMutableArray *m_array3 = [m_array mutableCopy];
    NSLog(@"m_array3[0] = %@, mutable_m_array3_retainCount = %d", m_array3[0], (int)m_array3.retainCount );
    
    //打印输出每个可变容器对象的地址
    NSLog(@"打印输出每个可变容器对象的地址");
    NSLog(@" m_array_p = %p", m_array);
    NSLog(@"m_array_p1 = %p", m_array1);
    NSLog(@"m_array_p2 = %p", m_array2);
    NSLog(@"m_array_p3 = %p", m_array3);
    
    //打印输出每个可变容器中元素的地址
    NSLog(@"打印输出每个可变容器中元素的地址");
    NSLog(@" m_array_p[0] = %p", m_array[0]);
    NSLog(@"m_array_p1[0] = %p", m_array1[0]);
    NSLog(@"m_array_p2[0] = %p", m_array2[0]);
    NSLog(@"m_array_p3[0] = %p", m_array3[0]);
    
    
    
    
    /**
     2015-07-19 17:45:21.978 JPDeepAndShallowCopy[1092:36685] 容器类的可变对象的拷贝
     2015-07-19 17:45:21.978 JPDeepAndShallowCopy[1092:36685]  m_array[0] = hrhrhrh,     init_m_array_retainCount = 1
     2015-07-19 17:45:21.978 JPDeepAndShallowCopy[1092:36685] m_array1[0] = hrhrhrh,  retain_m_array1_retainCount = 2
     2015-07-19 17:45:21.978 JPDeepAndShallowCopy[1092:36685] m_array2[0] = hrhrhrh,    copy_m_array2_retainCount = 1
     2015-07-19 17:45:21.979 JPDeepAndShallowCopy[1092:36685] m_array3[0] = hrhrhrh, mutable_m_array3_retainCount = 1
     2015-07-19 17:45:21.979 JPDeepAndShallowCopy[1092:36685] 打印输出每个可变容器对象的地址
     2015-07-19 17:45:21.979 JPDeepAndShallowCopy[1092:36685]  m_array_p = 0x618000241da0
     2015-07-19 17:45:21.979 JPDeepAndShallowCopy[1092:36685] m_array_p1 = 0x618000241da0
     2015-07-19 17:45:21.979 JPDeepAndShallowCopy[1092:36685] m_array_p2 = 0x610000011dd0
     2015-07-19 17:45:21.979 JPDeepAndShallowCopy[1092:36685] m_array_p3 = 0x618000241c50
     2015-07-19 17:45:21.979 JPDeepAndShallowCopy[1092:36685] 打印输出每个可变容器中元素的地址
     2015-07-19 17:45:21.980 JPDeepAndShallowCopy[1092:36685]  m_array_p[0] = 0x1036e6560
     2015-07-19 17:45:21.980 JPDeepAndShallowCopy[1092:36685] m_array_p1[0] = 0x1036e6560
     2015-07-19 17:45:21.980 JPDeepAndShallowCopy[1092:36685] m_array_p2[0] = 0x1036e6560
     2015-07-19 17:45:21.980 JPDeepAndShallowCopy[1092:36685] m_array_p3[0] = 0x1036e6560
     
     
     
     
     上面的代码以及代码的运行结果翻来复去就是在验证下面的结论：
     
     ​                1.retain：始终是浅复制。引用计数每次加一。返回对象是否可变与被复制的对象保持一致。
     
     2.copy：对于可变对象为深复制，引用计数不改变;对于不可变对象是浅复制， 引用计数每次加一。始终返回一个不可变对象。
     
     3.mutableCopy：始终是深复制，引用计数不改变。始终返回一个可变对象。
     */
}











/**
 我们如何实现容器中的完全拷贝呢？上代码最为直接，上面真的没有考虑到容器中元素拷贝的问题，下面的代码补充一下上面的不足之处
 */
- (void)test5{
    
    //新建一个测试字符串
    NSMutableString * str = [NSMutableString stringWithFormat:@"ludashi__"];
    
    //新建一个测试字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:str forKey:@"key1"];
    
    //把字典存入数组中
    NSMutableArray *oldArray = [NSMutableArray arrayWithObject:dic];
    
    //用就得数组生成新的数组
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:oldArray];
    
    //用copyItems拷贝数组中的元素
    NSMutableArray *copyItems = [[NSMutableArray alloc] initWithArray:oldArray copyItems:YES];
    
    
    //把数组归档成一个NSData,然后再实现完全拷贝
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:oldArray];
    NSMutableArray *multable = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //往字典中加入新的值
    [dic setObject:@"new_value1" forKey:@"key2"];
    //改变str的值
    [str appendString:@"update"];
    NSLog(@"%@", oldArray);
    NSLog(@"%@", newArray);
    NSLog(@"%@", copyItems);
    NSLog(@"%@", multable);
    
    //每个数组的地址为：
    NSLog(@"%p", oldArray);
    NSLog(@"%p", newArray);
    NSLog(@"%p", copyItems);
    NSLog(@"%p", multable);
    
}


@end
