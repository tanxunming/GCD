//
//  ViewController.m
//  iOS-GCD
//
//  Created by xunmingtan on 2019/3/4.
//  Copyright © 2019 xunmingtan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/* 剩余火车票数 */
@property (nonatomic, assign) int ticketSurplusCount;

@end

@implementation ViewController
{
    dispatch_semaphore_t semaphoreLock;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    同步+并发队列  【不会开启线程,依次执行完成】
//    [self syncConcurrent];
    
//    同步+串行队列  【不会开启线程,依次执行完成】
//    [self syncSerial];

//    异步+并发队列  【开启线程,同时进行任务】
//    [self asyncConcurrent];

//    异步+串行队列  【开启线程,依次执行完成任务】
//    [self asyncSerial];
    
//    同步执行+主队列（主线程调用）   【主线程,锁死】
//    [self syncMain];
    
//    同步执行+主队列（其他线程调用）  【主线程,依次执行完】
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
//    异步执行 + 主队列    【只在主线程执行,依次执行任务内的】
//    [self asyncMain];
    
//    GCD 线程间的通信 【回到主线程】
//    [self communication];
    
//    栅栏方法   【分隔开两组任务外依次执行】
//    [self barrier];
    
//    GCD 延时执行方法：dispatch_after【延时加载】
//    [self after];
    
//    GCD 一次性代码（只执行一次）：dispatch_once   【执行一次】
//    [self once];
    
//    快速迭代方法 dispatch_apply 【快速循环】
//    [self apply];
    
    /******** 队列组 group ********/
    
//    队列组 dispatch_group_notify 【分别异步执行2个耗时任务，在回到主任务执行】
//    [self groupNotify];
  
//    队列组 dispatch_group_wait 【分别异步执行2个耗时任务完全完成后，才能执行下面任务，会阻塞当前线程】
//    [self groupWait];
    
    
//    队列组 dispatch_group_enter、dispatch_group_leave
//     [self groupEnterAndLeave];

    /******** GCD 信号量：dispatch_semaphore ********/
//   semaphore 线程同步    【异步执行耗时任务，并使用异步执行的结果进行一些额外的操作】
//    [self semaphoreSync];
 
    
//    [self initTicketStatusNotSave];
    
    
    [self initTicketStatusSave];
}

#pragma mark - GCD方法

/**
 *  同步+并发队列
 *  特点:不会开启新的线程，执行完成一个任务才会执行下一个任务；
 */
-(void)syncConcurrent
{
    NSLog(@"同步+并发队列de线程----%@",[NSThread currentThread]);
    NSLog(@"同步+并发队列----begin");
    dispatch_queue_t queue = dispatch_queue_create("txm", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        NSLog(@"执行①----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"执行②----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"执行③----%@",[NSThread currentThread]);
    });
    
    NSLog(@"同步+并发队列----end");
}

/**
 *  同步+串行队列
 *  特点:不会开启新的线程，执行完第一次才会执行第二个任务
 */
-(void)syncSerial
{
    
    NSLog(@"同步+串行队列de线程----%@",[NSThread currentThread]);
    NSLog(@"同步+串行队列----begin");
    
    dispatch_queue_t queue = dispatch_queue_create("txm", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        NSLog(@"执行①----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"执行②----%@",[NSThread currentThread]);
        
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"执行③----%@",[NSThread currentThread]);
        
    });
    
    NSLog(@"同步+并发队列----end");
}


/**
 *  异步+并发队列
 *  开启多个线程，任务交替同时执行；
 */
-(void)asyncConcurrent
{
    
    NSLog(@"异步+并发队列de线程----%@",[NSThread currentThread]);
    NSLog(@"异步+并发队列----begin");
    
    dispatch_queue_t queue = dispatch_queue_create("txm", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"执行①----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行1️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行②----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行2️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行③----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行3️⃣----%@",[NSThread currentThread]);
    });
    
    NSLog(@"异步+并发队列----end");
    
}

/**
 *  异步+串行队列
 *  开启线程，任务里面是依次执行；
 */
-(void)asyncSerial
{
    NSLog(@"异步+串行队列de线程----%@",[NSThread currentThread]);
    NSLog(@"异步+串行队列----begin");
    
    dispatch_queue_t queue = dispatch_queue_create("txm", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"执行①----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行1️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行②----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行2️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行③----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行3️⃣----%@",[NSThread currentThread]);
    });
    
    NSLog(@"异步+串行队列----end");
}

/**
 *  同步执行+主队列
 *  同步执行+主队列（主线程调用）:卡死互相等待
 *  同步执行+主队列（其他线程调用）:不会开启线程，依次执行完成；
 */
-(void)syncMain
{
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");

    dispatch_queue_t queue = dispatch_get_main_queue();

    dispatch_sync(queue, ^{
        NSLog(@"执行①----%@",[NSThread currentThread]);
        NSLog(@"执行1️⃣----%@",[NSThread currentThread]);
    });

    dispatch_sync(queue, ^{
        NSLog(@"执行②----%@",[NSThread currentThread]);
        NSLog(@"执行2️⃣----%@",[NSThread currentThread]);
    });

    dispatch_sync(queue, ^{
        NSLog(@"执行③----%@",[NSThread currentThread]);
        NSLog(@"执行3️⃣----%@",[NSThread currentThread]);

    });
    NSLog(@"syncMain---end");
}

/**
 *  异步+主队列
 *  只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
-(void)asyncMain
{
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"执行①----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行1️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行②----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行2️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行③----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行3️⃣----%@",[NSThread currentThread]);
    });
    
    NSLog(@"asyncMain---end");
    
}

#pragma mark - GCD其他方法


/*
 GCD 线程间的通信
 
 主线程里边进行UI刷新，例如：点击、滚动、拖拽等事件。我们通常把一些耗时的操作放在其他线程，比如说图片下载、文件上传等耗时操作。而当我们有时候在其他线程完成了耗时操作时，需要回到主线程，那么就用到了线程之间的通讯。
 */
-(void)communication
{
    
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}

/**
 * GCD 栅栏方法：dispatch_barrier_async
 */
-(void)barrier
{
    dispatch_queue_t queue = dispatch_queue_create("txm", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"执行①----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行1️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行②----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行2️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"=====1=====%@============",[NSThread currentThread]);
        
        [NSThread sleepForTimeInterval:2];

        NSLog(@"=====2=====%@============",[NSThread currentThread]);

    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行③----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行3️⃣----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"执行④----%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行4️⃣----%@",[NSThread currentThread]);
    });
}


/**
 *  延时加载
 */
-(void)after
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"已经过啦十秒加载的");
    });
    
}

/**
 *  一次性代码（只执行一次）dispatch_once
 */
-(void)once
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}

/**
 *  快速迭代方法 dispatch_apply
 */
-(void)apply
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply----begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"打印第%zd次=====%@",index,[NSThread currentThread]);
    });
    NSLog(@"apply----end");
}

#pragma mark - 队列组


/**
 *  队列组 dispatch_group_notify
 *  分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组
 */
-(void)groupNotify
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
    
}


/**
 * 队列组 dispatch_group_wait
 */
-(void)groupWait
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t queue = dispatch_group_create();
    
    dispatch_group_async(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:5];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_wait(queue, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---begin");
}

/*
 *  队列组 dispatch_group_enter、dispatch_group_leave
 *  dispatch_group_enter 标志group任务+1
 *  dispatch_group_leave 标志group任务-1
 *  标志group任务=0 才会dispatch_group_waitk解除线程阻塞
 */
-(void)groupEnterAndLeave
{
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        
        NSLog(@"1---%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        
        NSLog(@"2---%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      
        NSLog(@"3---%@",[NSThread currentThread]);

        
        NSLog(@"group---end");
    });
    
}


#pragma mark - semaphore 线程同步

/**
 * semaphore 线程同步
 *  异步执行耗时任务，并使用异步执行的结果进行一些额外的操作
 *
 *  dispatch_semaphore_signal  信号量+1
 *  dispatch_semaphore_wait    信号量-1
 *  dispatch_semaphore_t    信号量不等于0则继续执行 //不能小于0
 */
- (void)semaphoreSync
{
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        
        // 追加任务1
        [NSThread sleepForTimeInterval:5];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        number = 100;
        dispatch_semaphore_signal(semaphore);
        
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//semaphore==0的时候等待
    NSLog(@"semaphore---end,number = %d",number);

}

#pragma mark - 线程安全

/**
* 非线程安全：不使用 semaphore
* 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
*/
-(void)initTicketStatusNotSave
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;//50张票
    
    //queue1 窗口一
    dispatch_queue_t queue1=dispatch_queue_create("txm", DISPATCH_QUEUE_SERIAL);
    //queue2 窗口二
    dispatch_queue_t queue2=dispatch_queue_create("txm", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
    
}

/**
 * 售卖火车票(非线程安全)
 */
-(void)saleTicketNotSafe
{
    
    while (1) {
        
        if (self.ticketSurplusCount>0) {
            self.ticketSurplusCount--;
            
            NSLog(@"%@",[NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            
            [NSThread sleepForTimeInterval:0.2];
        }else{
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
    
    NSLog(@"啊啊啊啊啊啊啊啊啊啊");
    
}


/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 500;//50张票

    dispatch_queue_t queue1 = dispatch_queue_create("txm1", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue2 = dispatch_queue_create("txm2", DISPATCH_QUEUE_SERIAL);

    __weak typeof(self)weakSelf = self;
    
    dispatch_async(queue1, ^{
        
        [weakSelf saleTicketSafe];
        
    });
    
    dispatch_async(queue2, ^{
        
        [weakSelf saleTicketSafe];

    });
    
}


-(void)saleTicketSafe
{
    while (1) {
        
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);//相当于加锁
        
        if (self.ticketSurplusCount > 0) {
            
            self.ticketSurplusCount--;
            
            NSLog(@"剩余【%d】张票，窗口【%@】",self.ticketSurplusCount,[NSThread currentThread]);
            
            [NSThread sleepForTimeInterval:1];
            
        }else{
            NSLog(@"火车票已经售完");
            
            dispatch_semaphore_signal(semaphoreLock);//相当于解锁
            
            break;
        }
        
        dispatch_semaphore_signal(semaphoreLock);//相当于解锁
        
    }
 
    NSLog(@"啊啊啊啊啊啊啊啊啊啊");
    
}


//*  dispatch_semaphore_signal  信号量+1
//*  dispatch_semaphore_wait    信号量-1
//*  dispatch_semaphore_wait    信号量不小于1的时候则继续执行


@end
