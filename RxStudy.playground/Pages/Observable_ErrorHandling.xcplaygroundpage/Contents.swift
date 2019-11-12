//: [Previous](@previous)

/// 本Demo主要讲解Observable的操作符之如何处理错误

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()
let imageUrl = "http://reactivex.io/assets/operators/legend.png"
let imageUrlError = "http://reactivex.io/assets/operators/legend.pngg"

/// Catch  将序列的错误事件转换为另一个可观察序列，以之前在特征序列【Charactistics_Observable】讲解到的为例，如果请求网络失败那么我们就给其赋一个默认图片
// 注意这里为什么用defer，为什么subscribeOn 在非主线程，observeOn主线程
let observable = Observable<UIImage>.deferred { () -> Observable<UIImage> in
    return Observable<UIImage>.create { (observer) -> Disposable in
        if let data = try? Data(contentsOf: URL(string: imageUrlError)!) {
            if let image = UIImage(data: data) {
                observer.onNext(image)
                observer.onCompleted()
            } else {
                observer.onError(NSError(domain: "com.RxStudy", code: -1, userInfo: nil))
            }
        } else {
            observer.onError(NSError(domain: "com.RxStudy", code: -1, userInfo: nil))
        }
        return Disposables.create()
    }
}.catchError { (error) -> Observable<UIImage> in
    // 如果发生错误，则显示一张默认图片
    return Observable<UIImage>.just(UIImage(named: "default_image") ?? UIImage())
}.subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "catch_serial"))
.observeOn(MainScheduler.instance)

let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
imageView.backgroundColor = UIColor.lightGray
imageView.contentMode = .scaleAspectFit

// 注意这里为社会么用Driver？由于这里我们处理了error事件，那么就只会接收到序列元素，这个与我们之前讲解的哪个特征序列相似？没错就是Driver，故
observable.asDriver(onErrorJustReturn: UIImage())
    .drive(imageView.rx.image)
    .disposed(by: disposeBag)

PlaygroundPage.current.liveView = imageView



/// Retry  类似于我们所要做的重试策略，例如：在请求网络过程中，由于客户端断网，服务端返回数据超时等情况，但是我们想要再次重试几次或者重试直到请求数据成功为止，那么这个时候用retry是一种比较好的选择
//  这里设置一个count >= 2时，我们让其替换为正确的图片请求url
var count = 0
let retryObservable = Observable<UIImage?>.create { (observer) -> Disposable in
    print("Observable  retry:  第 \(count) 次重试   当前 Scheduler isMain: \(Thread.current.isMainThread)")
    if let data = try? Data(contentsOf: URL(string: count >= 2 ? imageUrl : imageUrlError)!) {
        if let image = UIImage(data: data) {
            observer.onNext(image)
            observer.onCompleted()
        } else {
            observer.onError(NSError(domain: "com.RxStudy", code: -1, userInfo: nil))
        }
    } else {
        observer.onError(NSError(domain: "com.RxStudy", code: -1, userInfo: nil))
    }
    count += 1
    return Disposables.create()
}

// 这里我们再来复习一下CurrentThreadScheduler，这里就在global中执行，请注意查看控制台的输出
// 如果这里将下列的retry写到observeOn之后再看看输出，思考一下为什么会出现这样的情况
DispatchQueue.global().async {
    retryObservable.subscribeOn(CurrentThreadScheduler.instance)
        .retry(4)
        .observeOn(MainScheduler.instance)
        .subscribe({ (event) in
            print("Observable  retry:   event ->  \(event)")
        }).disposed(by: disposeBag)
}



