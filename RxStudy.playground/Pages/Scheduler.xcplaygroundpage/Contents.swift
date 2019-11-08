//: [Previous](@previous)

/// Scheduler 调度器，你可以将其看作多线程编程在Rx上的一些扩展，它决定了在哪个线程订阅，在哪个线程监听

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()
let imageUrl = "http://reactivex.io/assets/operators/legend.png"

/// 常见的一种场景就是，我们在获取数据时需要在后台线程，当数据获取到之后需要在主线程刷新UI
let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
imageView.backgroundColor = UIColor.lightGray
imageView.contentMode = .scaleAspectFit

let observable = Observable<UIImage?>.create { (observer) -> Disposable in
    print("observable: Scheduler  subscribeOn  ->  \(Thread.current.isMainThread)")
    if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
        observer.onNext(UIImage(data: data))
        observer.onCompleted()
    } else {
        observer.onError(NSError(domain: "com.RxStudy", code: -1, userInfo: nil))
    }
    return Disposables.create {}
}

// 请注意控制台打印出来的提示结果，获取数据的时候我们是在background中，而接收事件是在main线程
observable.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    .observeOn(MainScheduler.instance)
    .subscribe({ (event) in
        print("observable: Scheduler  observeOn  ->  \(Thread.current.isMainThread)")
        switch event {
        case .next(let image):
            imageView.image = image
        case .error(let error):
            print("请求 请求数据错误")
        default:
            break
        }
    }).disposed(by: disposeBag)

PlaygroundPage.current.liveView = imageView

/// ImmediateSchedulerType
/// OperationQueueScheduler 是通过OperationQueue来控制你同时并发的最大线程数
/// 尝试着修改下列 maxConcurrentOperationCount 的值来体会其用法
let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 2
let operationObservable = Observable.of(1, 2, 3).subscribeOn(OperationQueueScheduler(operationQueue: operationQueue))
for i in 0..<100 {
    operationObservable.subscribe { (event) in
        print("operationObservable: \(i)  \(event)")
    }
}

/// CurrentThreadScheduler 是在当前线程处理订阅事件，如果在main，那么整个执行过程就在main，如果在global那么整个执行过程就在global
let currentThreadObservable = Observable.of(1, 2, 3).subscribeOn(CurrentThreadScheduler.instance)
currentThreadObservable.subscribe { (event) in
    print("currentThreadObservable:  \(Thread.current)   \(event)")
}
DispatchQueue.global().async {
    currentThreadObservable.subscribe { (event) in
        print("currentThreadObservable:  \(Thread.current)   \(event)")
    }
}

/// ScheduleType: 作为ImmediateSchedulerType子Protocol
//SchedulerType
//VirtualTimeScheduler; HistoricalScheduler
//SerialDispatchQueueScheduler; MainScheduler
//ConcurrentMainScheduler
//ConcurrentDispatchQueueScheduler
