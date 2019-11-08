//: A UIKit based Playground for presenting user interface

/// 特征序列介绍
  
import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()
let imageUrl = "http://reactivex.io/assets/operators/legend.png"

/// 在介绍共享特征序列之前，先说一个概念”共享附加作用“
/// 什么是共享附加作用呢？
/// 就是当我们发起第二次订阅的时候，不会重新发出事件，将会共享第一次订阅事件的结果

/// Driver
/// Driver作为特征序列，它有哪些特征？
/// 不会产生error事件；一定在MainScheduler监听；具有共享附加作用
/// 这里请仔细观察并体会 General_Observable 中使用Single的不同之处，注意error处理、DispatchQueue使用，并且观察imageView 与 imageView1显示图像的时间是否是几无间隔并注意查看控制台打印了几次请求（主要体会共享附加作用），如果想要进一步体会共享附加作用，这里可以尝试着用Single、Observable等非特征序列来改写
let observable: Observable<UIImage?> = URLSession.shared.rx.data(request: URLRequest(url: URL(string: imageUrl)!)).map { (data) -> UIImage? in
    return UIImage(data: data)
}
let driver: Driver<UIImage?> = observable.asDriver(onErrorJustReturn: nil)

let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 800)))
view.backgroundColor = UIColor.white

let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
imageView.backgroundColor = UIColor.lightGray
imageView.contentMode = .scaleAspectFit
view.addSubview(imageView)

let imageView1 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 200), size: CGSize(width: 200, height: 200)))
imageView1.backgroundColor = UIColor.gray
imageView1.contentMode = .scaleAspectFit
view.addSubview(imageView1)

driver.drive(imageView.rx.image).disposed(by: disposeBag)
driver.drive(imageView1.rx.image).disposed(by: disposeBag)


/// Signal
/// Signal作为特征序列他有哪些特征，与Driver有何区别？
/// Signal具有Driver所有的特征，唯一与Driver区别在于：Driver会对新观察这回放上一个元素，而Signal不会对新观察者回放上一个元素
/// 请仔细体会下面的代码，这里我们创建一个Button

let button = UIButton(frame: CGRect(x: 0, y: 400, width: 200, height: 50))
button.setTitle("请点击测试Signal", for: .normal)
button.backgroundColor = UIColor.blue
view.addSubview(button)

// 使用driver，请注意查看第一次点击结果：控制台是否打印了 button: observerOnNext1 -> 创建另一个Observer
let buttonDriver = button.rx.tap.asDriver()
var observer1: AnyObserver<()>?
let observer: AnyObserver<()> = AnyObserver { (_) in
    print("button: driver observer -> 创建一个Observer")

    if observer1 == nil {
        observer1 = AnyObserver(eventHandler: { (_) in
            print("button: driver observer1 -> 创建另一个Observer")
        })
        buttonDriver.drive(observer1!).disposed(by: disposeBag)
    }
}
buttonDriver.drive(observer).disposed(by: disposeBag)

// 使用signal，注意看控制台打印的区别
let buttonSignal = button.rx.tap.asSignal()
var observerOnNextSignal1: (() -> Void)?
let observerOnNextSignal: () -> Void = {
    print("button: signal observerOnNext -> 创建一个Observer")

    if observerOnNextSignal1 == nil {
        observerOnNextSignal1 = {
            print("button: signal observerOnNext1 -> 创建另一个Observer")
        }
        buttonSignal.emit(onNext: observerOnNextSignal1!, onCompleted: nil, onDisposed: nil)
    }
}
buttonSignal.emit(onNext: observerOnNextSignal, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

/// ControlEvent
/// ControlEvent有哪些特征？
/// 专门用于UI控件所产生的事件，具有：不产生error；一定在MainScheduler订阅；一定在主线程监听；共享附加作用，同时与Signal相同，不会对新的观察者回放上一次的事件
let button1 = UIButton(frame: CGRect(x: 0, y: 450, width: 200, height: 50))
button1.setTitle("请点击测试ControlEvent", for: .normal)
button1.backgroundColor = UIColor.red
view.addSubview(button1)

let controlEvent = button1.rx.controlEvent(.touchUpInside)
controlEvent.subscribe { (event) in
    print("controlEvent  Thread: \(Thread.current.isMainThread)")
}.disposed(by: disposeBag)

controlEvent.observeOn(SerialDispatchQueueScheduler.init(internalSerialQueueName: "测试线程")).subscribe { (event) in
    print("controlEvent  Thread  1: \(Thread.current.isMainThread)")
}.disposed(by: disposeBag)


PlaygroundPage.current.liveView = view

