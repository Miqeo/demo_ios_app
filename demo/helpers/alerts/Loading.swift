//
//  LoadingIndicator.swift
//  demo
//
//  Created by Michał Hęćka on 03/06/2022.
//

import UIKit

extension UIView {
    func showLoading() {
        if let window = UIApplication.shared.keyWindow{
//            print("show loading")
            if let loading = window.subviews.first(where: { $0 is Loading }){
                loading.removeFromSuperview()
            }
            let loading = Loading.init(frame: frame)
            window.addSubview(loading)
            
            Loading().delay(seconds: 10) { [self] in
                removeLoading()
            }
        }
        
    }

    func removeLoading() {
        if let window = UIApplication.shared.keyWindow {
            if let loading = window.subviews.first(where: { $0 is Loading }){
                loading.removeFromSuperview()
//                print("show remove loading")
            }
        }
        
    }
}
class Loading: UIView {
    
    
    
    let backgroundView = UIView()
    let loading = UIActivityIndicatorView()
    let frontView = DesignableView()
    
    override init(frame: CGRect) {
        backgroundView.alpha = 1
        loading.alpha = 1
        frontView.alpha = 1
        
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        backgroundView.frame = frame
        
        frontView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        frontView.frame = CGRect(x: frame.size.width / 2 - 25, y: frame.size.height / 2 - 25, width: 50, height: 50)
        frontView.cornerRadius = 6
        
        loading.color = Int.random(in: 0...1) == 1 ? UIColor.init(named: "color_blue_accent") : UIColor.init(named: "color_pink_accent")
        loading.startAnimating()
        loading.frame = CGRect(x: frame.size.width / 2, y: frame.size.height / 2, width: 30, height: 30)
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loading.transform = transform
        loading.center = backgroundView.center
        
        super.init(frame: frame)
        addSubview(backgroundView)
        addSubview(frontView)
        addSubview(loading)
        
        delay(seconds: 2) {
            self.backgroundView.isHidden = false
            self.frontView.isHidden = false
            self.loading.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func delay(seconds: Double, completion: @escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}
