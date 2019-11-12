//: [Previous](@previous)

/// 本Demo讲解Observable的操作符之条件及boolean运算符

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport


let disposeBag = DisposeBag()

/// Amb  多个源Observables中，将会第一个事件发生的源，并且会忽略掉其他的源
/// 请仔细体会下面这个例子，timer 0.45的源Observable将会发射事件，其他的Observables事件都会被忽略掉
/// 可以这样理解：你先来，那么所有都焦点都在你，其他都我都把他们给忽略掉
Observable<Int>.interval(5, scheduler: MainScheduler.instance)
    .amb(Observable<Int>.timer(0.5, period: 3, scheduler: MainScheduler.instance))
    .amb(Observable<Int>.timer(0.45, period: 4, scheduler: MainScheduler.instance))
    .take(3)
    .subscribe { (event) in
        print("Observable   amb:    event  ->  \(event)")
}.disposed(by: disposeBag)



/// DefaultIfEmpty   如果序列中没有任何事件元素，那么发射一个默认值，常用在我们获取数据，这个数据是一个数组，但是没有得到任何值，但此时我们又希望给其赋一个初始值来显示，那么这个是一个比较有用的方法
Observable<Int>.of()
    .ifEmpty(default: 3)
    .subscribe { (event) in
        print("Observable   ifEmpty:    event  ->  \(event)")
}.disposed(by: disposeBag)


/// skipWhile  依据指定的【否】条件，跳过条件未满足之前的所有事件，亦即：条件为否前的所有时间将会被忽略
Observable<String>.of("hello", "skip", "until")
    .skipWhile { (value) -> Bool in
        return !value.contains("s")
    }.subscribe { (event) in
        print("Observable   skipWhile:    event  ->  \(event)")
}.disposed(by: disposeBag)


/// takeWhile  依据指定的【否】条件，发射满足之前的所有事件，亦即：条件为否前的所有时间将会被发射
Observable<String>.of("hello", "skip", "until")
    .takeWhile { (value) -> Bool in
        return !value.contains("s")
    }.subscribe { (event) in
        print("Observable   takeWhile:    event  ->  \(event)")
    }.disposed(by: disposeBag)


/// skipUntil  操作符可以让你忽略源 Observable 中头几个元素，直到另一个 Observable 发出一个元素后，它才镜像源 Observable
Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    .skipUntil(Observable<Int>.timer(3, period: 1, scheduler: MainScheduler.instance))
    .take(10)
    .subscribe { (event) in
        print("Observable   skipUntil:    event  ->  \(event)")
}.disposed(by: disposeBag)



/// takeUntil  与skipUtil相反
Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    .takeUntil(Observable<Int>.timer(1.1, period: 1, scheduler: MainScheduler.instance))
    .take(10)
    .subscribe { (event) in
        print("Observable   takeUntil:    event  ->  \(event)")
    }.disposed(by: disposeBag)


