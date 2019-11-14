//: [Previous](@previous)

import Foundation
import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport

let gesture1 = UITapGestureRecognizer(target: nil, action: nil)
let gesture2 = UITapGestureRecognizer(target: nil, action: nil)
let observer = AnyObserver<UITapGestureRecognizer> { (event) in
    switch event {
    case .next(let gesture):
        if gesture == gesture1 {
        }
    default:
        break
    }
}
gesture1.rx.event.subscribe(observer)
gesture2.rx.event.subscribe(observer)

let scrollView = UIScrollView()
scrollView.rx.observeWeakly(CGPoint.self, "contentOffset", options: KeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.new.rawValue | NSKeyValueObservingOptions.old.rawValue))
    .subscribe { (event) in
        print("observeWeakly   \(event)")
}
scrollView.contentOffset = CGPoint(x: 1, y: 2)
print("\(NSKeyValueObservingOptions.new.rawValue)    \(NSKeyValueObservingOptions.old.rawValue)   \(NSKeyValueObservingOptions.initial.rawValue)   \(NSKeyValueObservingOptions.prior.rawValue)")

URLSession

