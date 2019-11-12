//: [Previous](@previous)

/// 本Demo讲解Observable的操作符之如何转换一个观察序列

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport


let disposeBag = DisposeBag()

/// Buffer  将序列事件置入buffer中分批次发射事件；就像水池里面的水，你可以一直持续让其流着，也可以将其在一定时间蓄到一定量之后再放，它有两个控制条件只要满足其一就分组发射事件
/// 每0.2s 发射一个事件，意味着如果不控制count，那么1s钟间隔每次可以发射5个，但由于count限制，count = 3，则每个buffer分组发射3个组合序列
Observable<Int>.interval(0.2, scheduler: MainScheduler.instance)
    .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { (event) in
        print("Observable  buffer     1:    event  ->   \(event)")
}.disposed(by: disposeBag)

/// 注意观察下列结果的与上一个的区别
Observable<Int>.interval(0.4, scheduler: MainScheduler.instance)
    .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { (event) in
        print("Observable  buffer    2:    event  ->   \(event)")
    }.disposed(by: disposeBag)



/// Window  与Buffer原理类似，但window发射的是可观察序列，而非元素，请注意观察下列控制台的结果
Observable<Int>.of(0, 1, 2, 3, 4, 5, 6)
    .window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
    .subscribe { (event) in
        if let element = event.element {
            element.subscribe({ (eventSub) in
                print("Observable  window:    event  ->   \(element)   eventSub  ->  \(eventSub)")
            })
        }
}.disposed(by: disposeBag)




/// FlatMap  将序列转换为一个序列组，并且通过展开将其再转换为序列，这种情况，如：我们在使用Just时
/// 这个方法是很有用的，例如，当你有一个这样的Observable：它发射一个数据序列，这些数据本身包含Observable成员或者可以变换为Observable，因此你可以创建一个新的Observable发射这些次级Observable发射的数据的完整集合
Observable<[Int]>.just([1, 2], scheduler: MainScheduler.instance)
    .flatMap { (values) -> Observable<Int> in
        return Observable<Int>.from(values)
    }.subscribe { (event) in
        print("Observable   flatMap:     event   ->   \(event)")
    }.disposed(by: disposeBag)



/// Map  将序列元素进行转换，注意与FlatMap的区别
Observable<Int>.of(1, 2)
    .map { (value) -> String in
        return "\(value * 2)"
    }.subscribe { (event) in
        print("Observable   map:     event   ->   \(event)")
}.disposed(by: disposeBag)



/// GroupBy  将序列元素分组成不同observables，请注意看下面的列子
Observable<Int>.of(0, 1, 2, 3, 4)
    .groupBy(keySelector: { (element) -> String in
        return element % 2 == 0 ? "偶数" : "基数"
    }).filter({ (group) -> Bool in
        return group.key == "偶数"
    })
    .subscribe { (event) in
        if let group = event.element {
            group.subscribe({ (eventSub) in
                print("Observable   groupby:    groupKey  \(group.key)    eventSub  ->   \(eventSub)")
            })
        }
}.disposed(by: disposeBag)


/// Scan  给定一个初始值，每一次将上一次的结果与下一次的元素进行组合，其每次事件元素的值都将通过next事件，注意其与Reduce的比较
Observable<Int>.of(0, 1, 2, 3)
    .scan("result ") { (result, value) -> String in
        return result + "  --  \(value)"
    }.subscribe { (event) in
        print("Observable   scan:    event  ->  \(event)")
}.disposed(by: disposeBag)



/// to  将可观察序列转换为一个 数据结构
Observable.of(1, 2, 4).toArray()
