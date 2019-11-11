//: [Previous](@previous)

/// 本Demo主要讲解Observable的操作符之如何条件过滤一个观察序列

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()

/// Debounce   在规定的时间窗口内过滤事件元素，如果debounce开启的时候此时元素正好到来，那么将无法收到它们的任何事件
var elements: [Int] = []
for i in 0...1010 {
    elements.append(i)
}
Observable<Int>.from(elements)
    .debounce(10, scheduler: MainScheduler.instance)
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











