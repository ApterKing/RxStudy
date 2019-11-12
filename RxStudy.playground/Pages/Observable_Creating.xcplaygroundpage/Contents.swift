//: [Previous](@previous)

/// 本Demo讲解Observable的操作符之如何创建一个观察序列

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true
//PlaygroundPage.current.finishExecution()

let disposeBag = DisposeBag()

/// Create  通过编程方式来创建可观察对象，创建后的Observeble是可以接收到.onNext、.onError、.onComplete
let createObservable = Observable<Int>.create { (observer) -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    return Disposables.create()
}
createObservable.subscribe { (event) in
    print("createObservable:  event  ->  \(event)")
}.disposed(by: disposeBag)



/// From   创建一个或一组可观察序列，from支持optional
_ = Observable<String>.from(optional: nil)

Observable<String>.from(["hello", "RxSwift"])
    .subscribe { (event) in
        print("fromObservable:   event  ->   \(event)")
}.disposed(by: disposeBag)




/// of   作用与From类似，在写法上略微区别，of不支持optional
Observable<String>.of("hello", "RxSwift")
    .subscribe { (event) in
        print("ofObservable:   event  ->   \(event)")
}.disposed(by: disposeBag)



/// Just  创建仅包含一个元素的事件序列
Observable<Int>.just(1, scheduler: MainScheduler.instance)
    .subscribe { (event) in
        print("justObservable:     event   ->   \(event)")
}.disposed(by: disposeBag)



/// Defer  延时到当有订阅者的时候才创建事件序列，并且每订阅一次都会创建一个全新的Observable；deferr采用一个Factory函数型作为参数，Factory函数返回的是Observable类型。这也是其延时创建Observable的主要实现
var value: String?
// defer创建在前
let deferObservable = Observable<String>.deferred { () -> Observable<String> in
    return Observable<String>.from(optional: value)
}
// 赋值在后
value = "hello  deferObservable"
deferObservable.subscribe { (event) in
    print("deferObservable:   event  ->   \(event)")
}.disposed(by: disposeBag)

var value1: String?
// 普通创建在前
let compareObservable = Observable<String>.from(optional: value1)
// 赋值在后
value1 = "hello none defer"
compareObservable.subscribe { (event) in
    print("非 deferObservable 用于对比:  event  ->   \(event)")
}.disposed(by: disposeBag)
// 请仔细体会上述二者在控制台所打印出的事件结果对比



/// Empty  那么我们在什么时候会用到Empty呢？ 相信在一个错误发生时，但你不想收到任何关于错误的信息就结束
Observable<Int>.empty()
    .subscribe { (event) in
        print("emptyObservable:    event  ->   \(event)")
    }.disposed(by: disposeBag)



/// Range
Observable<Int>.range(start: 0, count: 5)
    .subscribe { (event) in
        print("rangeObservable:    event  ->   \(event)")
}.disposed(by: disposeBag)



/// Repeat
Observable<String>.repeatElement("测试")
    .take(2)
    .subscribe { (event) in
        print("repeatObservable:    event  ->   \(event)")
}.disposed(by: disposeBag)



/// Interval
Observable<Int32>.interval(1.1, scheduler: MainScheduler.instance)
    .take(3)
    .subscribe { (event) in
        print("intervalObservable:    event  ->   \(event)")
    }.disposed(by: disposeBag)



/// Timer  间隔一段时间发送序列事件，与Interval类似，只是可以设置一个相对开始时间的值，而Interval相对开始的时间与period值相同
Observable<Int>.timer(1, period: 1, scheduler: MainScheduler.asyncInstance)
    .take(3)
    .subscribe { (event) in
        print("timerObservable:    event  ->   \(event)")
}.disposed(by: disposeBag)



/// Generate：其实是实现了一个迭代器的效果，他有三个参数，第一个是初始值，第二个是条件（满足条件之后就会继续执行.Next事件，第三个是迭代器，每次都会返回一个E类型，直到不满足条件为止
Observable<Int>.generate(initialState: 0, condition: { (value) -> Bool in
        return value < 10
    }) { (value) -> Int in
        return value + 3
    }.subscribe { (event) in
        print("generateObservable:    event  ->   \(event)")
}.disposed(by: disposeBag)

