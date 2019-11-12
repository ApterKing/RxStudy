//: [Previous](@previous)

/// 本demo说一些既可以作为可观察序列又可以作为观察者的特殊情况

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()

/// 本章节所讲述到的SubjectType子类，既可以作为Observable也可以作为Observer

/// AsyncSubject 仅接收原始Observable的最后一个值，会把最后一个值发射给任何观测者，如果原始Observable没有发射过任何事件元素，那么AsyncSubject也不会发射任何值
let asyncSubject = AsyncSubject<String>()
asyncSubject.onNext("测试1")
asyncSubject.subscribe { (event) in
    print("asyncSubject   event  ->  \(event)")
}.disposed(by: disposeBag)
asyncSubject.onNext("测试2")
asyncSubject.onNext("测试3")
asyncSubject.onCompleted()

/// ReplaySubject  如果一个Observer订阅了ReplaySubject，那么它将收到订阅前（在bufferSize大小内）以及订阅后的completed或者error前所有事件元素，不管Observer何时订阅的
/// 试试将bufferSize调整到2看看结果
let replaySubject = ReplaySubject<String>.create(bufferSize: 3)
replaySubject.onNext("hello")     // 作为Observer
replaySubject.onNext("RxSwift")
replaySubject.onNext("RxCocoa")

replaySubject.subscribe { (event) in   // 作为Observable
    print("replaySubject   event  ->  \(event)")
}.disposed(by: disposeBag)

replaySubject.onNext("world")
replaySubject.onCompleted()
replaySubject.onNext("completed")

/// BehaviorSubject  如果一个Observer订阅了BehaviorSubject那么他将收到最近的一次事件，如果从未发射过事件，那么将会收到初始化时的默认值
/// 尝试着将订阅前的onNext 1 2 注释掉，再查看控制台输出
/// 在某种程度上你可以将BehaviorSubject理解为bufferSize = 1 的ReplaySubject
let behaviorSubject = BehaviorSubject<Int>(value: 0)
behaviorSubject.onNext(1)    //  作为Observer
behaviorSubject.onNext(2)
behaviorSubject.subscribe { (event) in   // 作为Observable
    print("behaviorSubject   event  ->  \(event)")
}.disposed(by: disposeBag)
behaviorSubject.onNext(3)

/// PublishSubject  仅对对订阅者发送订阅之后的事件，可以将其看作为bufferSize = 0 的ReplaySubject
let publishSubject = PublishSubject<Int>()
publishSubject.onNext(1)    //  作为Observer
publishSubject.onNext(2)
publishSubject.subscribe { (event) in   // 作为Observable
    print("publishSubject   event  ->  \(event)")
}.disposed(by: disposeBag)
publishSubject.onNext(3)

