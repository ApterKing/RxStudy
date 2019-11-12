//: [Previous](@previous)

/// 本Demo讲解Observable的操作符之如何条件过滤一个观察序列

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()

var elements: [Int] = []
for i in 0...1010 {
    elements.append(i)
}

/// Throttle   过滤掉高频产生的元素，一段时间内没有新元素产生，那么就将事件元素发射出来，仔细体会其与Debounce的不同
Observable<Int>.from(elements)
    .throttle(0.1, scheduler: MainScheduler.instance)
    .subscribe { (event) in
        print("Observable  throttle:    event  ->   \(event)")
}.disposed(by: disposeBag)

/// Debounce   过滤掉高频产生的元素，在 Observable 产生事件元素后，一段时间内没有新元素产生，那么就将此事件元素发射出来
Observable<Int>.from(elements)
    .debounce(0.1, scheduler: MainScheduler.instance)
    .subscribe { (event) in
        print("Observable  debounce:    event  ->   \(event)")
}.disposed(by: disposeBag)


/// Distinct   去重
Observable<Int>.of(0, 1, 0, 0, 4, 4)
    .distinctUntilChanged()   // 就近去重
    .subscribe { (event) in
        print("Observable  distinct:    event  ->   \(event)")
}.disposed(by: disposeBag)

Observable<Int>.of(0, 1, 0, 0, 4, 4, 5)
    .distinctUntilChanged { (l, r) -> Bool in  // 条件去重
        return l % 2 == r % 2
    }.subscribe { (event) in
        print("Observable  distinct   1:    event  ->   \(event)")
}.disposed(by: disposeBag)



/// First  发出第一个元素或者满足条件的第一个序列元素
Observable<String>.of("hello", "he", "her", "w")
    .first()
    .subscribe(onSuccess: { (value) in
        print("Observable  first:    element  ->   \(value)")
    }, onError: nil)


/// ElementAt  发出序列指定位置的元素
Observable<Int>.from([1, 2, 3, 4])
    .elementAt(1)
    .subscribe { (event) in
        print("Observable  elementAt:    event  ->   \(event)")
}.disposed(by: disposeBag)



/// Filter  满足条件则发出序列元素
Observable<Int>.of(0, 1, 2, 4)
    .filter { (value) -> Bool in
        return value % 2 == 0
    }.subscribe { (event) in
        print("Observable  filter:    event  ->   \(event)")
}.disposed(by: disposeBag)



///  IgnoreElements  忽略掉所有元素，仅能够发送complete或者error事件
Observable<Int>.of(0, 2, 4)
    .ignoreElements()
    .subscribe { (event) in
        print("Observable  ignoreElements:    event  ->   \(event)")
}.disposed(by: disposeBag)



/// Skip
Observable<Int>.of(0, 1, 2, 3, 4)
    .skipWhile({ (value) -> Bool in
        return value < 3
    })
    .subscribe { (event) in
        print("Observable  skip:    event  ->   \(event)")
}.disposed(by: disposeBag)



/// Take  与Skip相反
Observable<Int>.of(0, 1, 2, 3, 4)
    .takeWhile({ (value) -> Bool in
        return value < 3
    })
    .subscribe { (event) in
        print("Observable  take:    event  ->   \(event)")
    }.disposed(by: disposeBag)


/// Sample  通过第二个Observable对源Observable进行取样操作，每当第二个Observable发出事件时，则取出源Observable最近的一个事件发出，这有点类似与我们的满足某个条件的抽样调查
Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    .sample(Observable<Int>.interval(3, scheduler: MainScheduler.instance))
    .takeWhile({ (value) -> Bool in
        return value < 10
    })
    .subscribe { (event) in
        print("Observable   sample:    event ->  \(event)")
    }.disposed(by: disposeBag)




