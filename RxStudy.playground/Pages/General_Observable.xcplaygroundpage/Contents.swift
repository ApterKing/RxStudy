//: [Previous](@previous)

/// 非特征序列介绍

import Foundation
import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport

let disposeBag = DisposeBag()
let imageUrl = "http://reactivex.io/assets/operators/legend.png"

/// Single
/// 与Observable相比较有何特点？什么时候会使用到Single?
/// 与Observable相比较Single只会发送一个元素或者error
/// 种常用语我们只需要两种结果，并且结果只有一种值的情况，如：网络请求
let single = Single<UIImage>.create { (singleObserver) -> Disposable in
    let task = URLSession.shared.dataTask(with: URL(string: imageUrl)!, completionHandler: { (data, _, error) in
        if let error = error {
            singleObserver(.error(error))
        }

        guard let data = data, let image = UIImage(data: data) else {
            singleObserver(.error(NSError(domain: "com.RxStudy", code: -1, userInfo: nil) as Error))
            return
        }
        singleObserver(.success(image))
    })
    task.resume()
    return Disposables.create {
        task.cancel()
    }
}

let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
imageView.backgroundColor = UIColor.white
imageView.contentMode = .scaleAspectFit
let observer = { (event: SingleEvent<UIImage>) in
    if case .success(let element) = event {
        DispatchQueue.main.async {
            imageView.image = element
        }
    } else if case .error(let error) = event {
        print("single: error -> \(error)")
    }
}
single.subscribe(observer).disposed(by: disposeBag)
// or
single.subscribe(onSuccess: { (image) in
    DispatchQueue.main.async {
        imageView.image = image
    }
}) { (error) in
    print("single error -> \(error)")
}.disposed(by: disposeBag)

PlaygroundPage.current.liveView = imageView



/// Completable
/// 与Observable、Single相比较有何特点？什么时候会使用到Completable？
/// 与Observable相比较，Completable要么只能产生一个competed事件，要么产生一个error事件，这是什么意思呢？以为着Completable是不能够产生next事件即序列不会产生任何元素的
/// 就仅用于只需要接收complete 或者 error事件的的情况，如：那些不关心返回值，只需要知道是否完毕的情况
let completable = Completable.create { (completableObserver) -> Disposable in

    completableObserver(.completed)

    completableObserver(CompletableEvent.error(NSError(domain: "com.RxStudy", code: -1, userInfo: nil) as Error))

    return Disposables.create {}
}
completable.subscribe(onCompleted: {
    print("completable: onCompleted")
}) { (error) in
    print("completable: error -> \(error)")
}.disposed(by: disposeBag)

/// Maybe
/// 与Observable相比较有何特点？什么时候会使用到Maybe？
/// Maybe要么发送一个元素，要么发送complete，要么error事件
/// 也就是说Maybe用于那些只要产生种事件的情况
let maybe = Maybe<String>.create { (maybeObserver) -> Disposable in

    // 可以试试调整这里的顺序看看输出的是什么结果，注意体会一下和Observable之间的差别
    maybeObserver(.success("success"))

    maybeObserver(.completed)

    maybeObserver(MaybeEvent.error(NSError(domain: "com.RxStudy", code: -1, userInfo: nil) as Error))

    return Disposables.create {}
}
maybe.subscribe(onSuccess: { (element) in
    print("maybe: success -> \(element)")
}, onError: { (error) in
    print("maybe: error -> \(error)")
}) {
    print("maybe: completed")
}.disposed(by: disposeBag)

/// 综上，其实Single、Completable、Maybe其内部都是通过Observable实现的，可以将他们看做Observable的一种语法糖，一种特殊情况下使用的可观察序列

