//
//  WebImageViewController.swift
//  demo
//
//  Created by Michał Hęćka on 21/04/2022.
//

import UIKit
import WebKit

class WebImageViewController: WebImageView, WKNavigationDelegate {//class responsible for web view

    
    @IBOutlet weak var webImageView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegation setup
        webImageView.navigationDelegate = self
        
        alert = Alert(view: self)//setup alert
        
        loadImageWeb { (request) in//load image from url
            webImageView.load(request)
        }
        completionFailure: { (err) in//error out
            print(err)
            alert!.show(title: "Error", sub: err, actions: [
                UIAlertAction(title: "Ok", style: .default, handler: nil)
            ])
        }

    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {//when failed show alert
        print(error)
        alert!.show(title: "Error", sub: Request().errorControll(errCode: nil), actions: [
            UIAlertAction(title: "Ok", style: .default, handler: nil)
        ])
    
    }
    
}
