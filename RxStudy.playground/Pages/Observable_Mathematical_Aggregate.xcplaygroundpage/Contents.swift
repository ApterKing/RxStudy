//: [Previous](@previous)

/// 本Demo主要讲解Observable的操作符之数学及集合运算符

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport


let disposeBag = DisposeBag()

/// Reduce  给定一个初始值，将此次与下次结果根据给定函数进行转换，并且只发送最后一次的结果值
/// 注意其与 Scan的比较
Observable<Int>.of(0, 1, 2, 3)
    .reduce("result") { (result, value) -> String in
        return result + "  --  \(value)"
    }.subscribe { (event) in
        print("Observable   reduce:    event  ->  \(event)")
}.disposed(by: disposeBag)


Observable<Int>.of(1, 2, 3)
    .reduce(0, accumulator: { (result, value) -> Int in
        return result + value
    }) { (value) -> String in
        return String(describing: value)
    }.subscribe { (event) in
        print("Observable   reduce  mapResult:    event  ->  \(event)")
}.disposed(by: disposeBag)

