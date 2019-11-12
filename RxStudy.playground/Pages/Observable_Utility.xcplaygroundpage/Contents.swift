//: [Previous](@previous)

/// 本Demo讲解Observable的操作符之常规操作

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()
let imageUrl = "http://reactivex.io/assets/operators/legend.png"
let imageUrlError = "http://reactivex.io/assets/operators/legend.pngg"

/// Delay  在指定的时间后发出事件序列, 注意查看下列例子在控制台的输出结果
Observable.of(1, 2, 3)
    .delay(0.1, scheduler: MainScheduler.instance)
    .subscribe { (event) in
        print("Observable  delay:   event  ->   \(event)")
}.disposed(by: disposeBag)

Observable.of(0)
    .subscribe { (event) in
        print("Observable  delay:   event  ->   \(event)")
}.disposed(by: disposeBag)


/// Do   允许你在Observabe整个生命周期去插入一个动作，这种很有用，就好比如说我们需要知道Observable完成之后做一个其他操作，在disposed之后做一个其他操作等等，更多请看列子体会，并且思考一下在实际生产中该如何运用
Observable<String>.of("hello", "Observable", "do")
    .do(onNext: { (value) in
        print("Observable   do:   onNext")
    }, onError: nil, onCompleted: {
        print("Observable   do:   onCompleted")
    }, onSubscribe: {
        print("Observable   do:   onSubscribe")
    }, onSubscribed: {
        print("Observable   do:   onSubscribed")
    }) {
        print("Observable   do:   onDisposed")
    }.subscribe { (event) in
        print("Observable   do:   event  ->  \(event)")
}.disposed(by: disposeBag)



/// Materialize   将发出的事件与事件元素合并作为一个事件元素发出，暂时没有想到这种场景该如何使用
/// Dematerialize   reverse操作
Observable<Int>.of(1, 2, 3)
    .materialize()
    .subscribe { (eventevent) in
        print("Observable   materizlize:  eventevent  -> \(eventevent)  event  ->  \(eventevent.element)")
}.disposed(by: disposeBag)

Observable<Int>.of(1, 2, 3)
    .materialize()
    .dematerialize()
    .subscribe { (event) in
        print("Observable   dematerizlize:   event  ->  \(event)")
}.disposed(by: disposeBag)


/// SubscribeOn  指定在哪个序列处理元素
/// ObserveOn   指定在哪个序列接收事件
/// 注意查看控制台的输出结果
Observable<String>.of("SubscribeOn", "ObserveOn")
    .subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "subscribeOn"))
    .map { (value) -> String in
        print("Observable  subscribeOn:   \(Thread.current)")
        return value
}.observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "observeOn"))
    .subscribe { (event) in
        print("Observable  observeOn:   \(Thread.current)   event ->  \(event)")
}.disposed(by: disposeBag)


/// Timeout   在指定时间内如果没有收到事件元素，那么将会发送一个timeout error事件
/// 可以尝试着修改timeout 1.9 > 2 试试看结果
/// 这种情况常应用于我们在做一个耗时处理，但只想等待一段时间就结束
Observable<Int>.timer(0.5, period: 2, scheduler: MainScheduler.instance)
    .timeout(1.9, scheduler: MainScheduler.instance)
    .subscribe { (event) in
        print("Observable   timeout:   event  ->  \(event)")
}.disposed(by: disposeBag)



/// Share   共享事件源，避免多个订阅者订阅时，多次请求，这种情况往往用于网络请求的时候，下列例子我们通过map来观察，你可以尝试着注释下列share观察情况
let observable = Observable<Int>.of(1, 2).map { (value) -> Int in
        print("Observable   share:   map    \(value)")
        return value * 2
    }
    .share(replay: 1, scope: .forever)   // 注释这里看看控制台打印的结果体会一下

observable.subscribe { (event) in
    print("Observable   share:   event   1   \(event)")
}.disposed(by: disposeBag)
observable.subscribe { (event) in
    print("Observable   share:   event   2   \(event)")
}.disposed(by: disposeBag)
