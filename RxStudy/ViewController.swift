//
//  ViewController.swift
//  RxStudy
//
//  Created by wangcong on 2019/11/7.
//  Copyright © 2019 wangcong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageUrl = "https://pro-cs.kefutoutiao.com/doc/im/image_1572267257493_m61g8.png?x-oss-process=image/auto-orient,1/resize,h_300,w_300"
        let single = Single<UIImage>.create { (singleObserver) -> Disposable in
            let task = URLSession.shared.dataTask(with: URL(string: imageUrl)!, completionHandler: { (data, _, error) in
                if let error = error {
                    singleObserver(SingleEvent.error(error))
                }

                guard let data = data, let image = UIImage(data: data) else {
                    singleObserver(SingleEvent.error(NSError(domain: "com.RxStudy", code: -1, userInfo: nil) as Error))
                    return
                }
                singleObserver(SingleEvent.success(image))
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }

        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
        imageView.contentMode = .scaleAspectFill
        _ = single.subscribe(onSuccess: { (image) in
            DispatchQueue.main.async {
                imageView.image = image
            }
        }) { (error) in
            print("error: \(error)")
        }
        view.addSubview(imageView)
    }


}

