//: [Previous](@previous)

/// 本Demo讲解Observable的操作符之可连接观察序列

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport


let disposeBag = DisposeBag()


/// connect ConnectableObservable和普通的 Observable 十分相似，不过在被订阅后不会发出元素，直到 connect 操作符被应用为止。这样我们就可以等所有观察者全部订阅完成后，才发出元素。
/// 【 亦即意味着：我们可以控制在什么时候发射元素，这很重要，往往我们是需要等待所有订阅者都订阅了之后才发射事件元素 】
/// publish 可以将普通Observable转换为 可连接的ConnectableObservable
/// 请仔细体会下列时间等待
let publishObservable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()

_ = publishObservable
    .subscribe(onNext: { print("Observable  connect   publish  1:  event -> \($0)") })

DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
    _ = publishObservable
        .subscribe(onNext: { print("Observable  connect   publish   2:  event -> \($0)") })
}

// 在这2s前是不会发出任何元素的，直到调用了connect
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    let disposable = publishObservable.connect()

    // 2s后取消所有订阅
    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        disposable.dispose()
    })
}


/// replay 确保所有订阅者都收到相同事件元素，请注意其与publish的对比
/// 特别注意 publish  2 与 replay 2 之间的不同，深刻体会或自己重新写一遍来感受
/// 为了控制台打印的信息分开，这里延时一下
DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    let replayObservable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replayAll()

    _ = replayObservable
        .subscribe(onNext: { print("Observable  connect   replay 1:  event -> \($0)") })

    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
        _ = replayObservable
            .subscribe(onNext: { print("Observable  connect   replay  2:  event -> \($0)") })
    }

    // 在这2s前是不会发出任何元素的，直到调用了connect
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        let disposable = replayObservable.connect()

        // 2s后取消所有订阅
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            disposable.dispose()
        })
    }
}



/// refCount 将ConnectableObservable 转换为普通的Observable
let connectObservable = Observable<Int>.of(1, 2, 3).publish()
_ = connectObservable.connect()
let normalObservable = connectObservable.refCount()



