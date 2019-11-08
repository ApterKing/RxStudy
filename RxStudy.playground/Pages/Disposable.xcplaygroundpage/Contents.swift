//: [Previous](@previous)

import Foundation
import RxSwift
import RxCocoa

let imageUrl = "http://reactivex.io/assets/operators/legend.png"

/// Disposable
/// 什么是Disposable，它有何作用
/// 从英文的字面意思来看，disposable是一次性，用完即可丢弃的，那么亦即意味着当发生了completed及error事件时，订阅的资源就可以被清除掉

/// Disposable 常常用于清除资源或者提前取消掉订阅。比如在某个页面有网络请求的情况下，当我们跳转或者做了其他处理是，不希望网络请求时该怎么办？ - 手动取消掉即可

let disposable = URLSession.shared.rx.data(request: URLRequest(url: URL(string: imageUrl)!)).subscribe { (event) in
    switch event {
    case .next(let element):
        print("disposable:  next  ->  \(element.count)")
    case .error(let error):
        print("disposable:  error  ->  \(error.localizedDescription)")
    default:
        print("disposable:  completed")
    }
}

// 模拟一个1s后取消掉网络请求的操作，这里注意查看控制台打印出了些什么
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
    print("disposable: 取消网络请求")
    disposable.dispose()
}


/// 相较于手动管理订阅的生命周期，其实我们更愿意使用自动管理，就像当你习惯了ARC，虽然有时候需要提前释放资源，但大多时候你还是希望自动管理资源释放的

/// 自动资源释放之 DisposaeBag，类似于MRC中的autoreleasepool
let disposeBag = DisposeBag()
disposable.disposed(by: disposeBag)

/// 还有一种方式就是以满足某个条件止，来终止订阅并释放资源，下面这个例子就是当view 执行dealloced时订阅会被取消并释放
let view = UIView()
let textField = UITextField()
view.addSubview(textField)

_ = textField.rx.text
    .takeUntil(view.rx.deallocated)
    .subscribe { (event) in
        print("takeUntil: event  ->  \(event)")
    }
