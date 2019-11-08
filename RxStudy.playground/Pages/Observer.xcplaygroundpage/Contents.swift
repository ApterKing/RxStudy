//: [Previous](@previous)

/// 本Demo介绍Observer，由于Observer并非像Observable那样种类多且负责，故在此将特征Observer与非特征Observer一并介绍

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()
let imageUrl = "http://reactivex.io/assets/operators/legend.png"

/// AnyObserver
/// 非特征Observer
let observer: AnyObserver<Int> = AnyObserver { (event) in
    switch event {
    case .next(let element):
        print("observer: next  -> \(element)")
    default:
        print("observer: event  -> \(event)")
    }
}

let observable = Observable<Int>.from([1, 2, 3])

observable.subscribe(observer).disposed(by: disposeBag)
// 其也等于
observable.subscribe { (event) in
    switch event {
    case .next(let element):
        print("observer: next  -> \(element)")
    default:
        print("observer: event  -> \(event)")
    }
}

/// Binder
/// 一种特殊的Observer，按照之前介绍的 Charactistics_Observable，可将其称之为特征Observer
/// 具有：不处理error事件；确保所有事件都在给定的Scheduler上执行，我们已经在Charactistics_Observable见过了，现在再将其来写一遍，权当复习
let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
imageView.backgroundColor = UIColor.white
imageView.contentMode = .scaleAspectFit

URLSession.shared.rx.data(request: URLRequest(url: URL(string: imageUrl)!))
    .map { (data) -> UIImage? in
        return UIImage(data: data)
    }.bind(to: imageView.rx.image)
    .disposed(by: disposeBag)

/// 如何自定义自己的Binder ？其实很简单，这里我们以给UIImageView设置背景色为例，但是注意我们不以backgroundColor来设置binder，换一个名字bgColor
extension Reactive where Base: UIImageView {
    public var bgColor: Binder<UIColor?> {
        return Binder(self.base, binding: { (imgv, color) in
            imgv.backgroundColor = color
        })
    }

}

// 这里试一试我们自定义的一个bgColor，将背景色转换为brown
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
    Observable<UIColor>.just(UIColor.brown)
        .bind(to: imageView.rx.bgColor)
        .disposed(by: disposeBag)
}

PlaygroundPage.current.liveView = imageView

