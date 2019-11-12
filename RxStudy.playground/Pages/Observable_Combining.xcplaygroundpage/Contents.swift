//: [Previous](@previous)

/// 本Demo主要讲解Observable的操作符之观察序列组合

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport


let disposeBag = DisposeBag()

/// combineLatest 操作符将多个 Observables 中最新的元素通过一个函数组合起来，然后将这个组合的结果发出来。这些源 Observables 中任何一个发出一个元素，他都会发出一个元素（前提是，这些 Observables 曾经发出过元素）
/// 会将就近的已发出元素相组合
Observable.combineLatest(Observable.of(1, 2, 3), Observable.of("a", "b", "c")) { (e0, e1) -> String in
    return "\(e0)" + e1
    }.subscribe { (event) in
        print("Observable   combineLatest:    event  ->  \(event)")
}.disposed(by: disposeBag)


/// merge  合并多个Observable，当某一个 Observable 发出一个元素时，他就将这个元素发出。
/// 如果，某一个 Observable 发出一个 onError 事件，那么被合并的 Observable 也会将它发出，并且立即终止序列
let merge0 = Observable.of(1, 2, 3)
let merge1 = Observable.deferred { () -> Observable<Int> in
    return Observable.of(4, 5, 6)
}
Observable.of(merge0, merge1)
    .merge()
    .subscribe { (event) in
        print("Observable    merge:    event  ->  \(event)")
}.disposed(by: disposeBag)



/// startWith   在观察序列头部插入一些事件元素
Observable.of(3, 4, 5)
    .startWith(1, 2)
    .subscribe { (event) in
        print("Observable    startWith:    event  ->  \(event)")
}.disposed(by: disposeBag)


/// contact   连接两个或多个个观察序列
Observable<String>.of("hello")
    .concat(Observable.of("RxSwift"))
    .concat(Observable.of("RxCocoa"))
    .subscribe { (event) in
        print("Observable    startWith:    event  ->  \(event)")
}.disposed(by: disposeBag)


/// zip    将最多不超过8个的Observable组合起来，并且它的事件元素是每一个Observable事件元素的严格位置对应，事件数量等于最少的那个Observable中的元素个数
/// 请仔细体会下列例子，并尝试着修改然后再观察其输出的值
let zip0 = Observable.of(1, 2, 3)
let zip1 = Observable.of("a", "b", "c", "d")
let zip2 = Observable.of("A", "B", "C", "D", "E")
Observable.zip(zip0, zip1, zip2) { (e0, e1, e2) -> String in
    return "\(e0)" + e1 + e2
    }.subscribe { (event) in
        print("Observable    zip:   event ->  \(event)")
}.disposed(by: disposeBag)



