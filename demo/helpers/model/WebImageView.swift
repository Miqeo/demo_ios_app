//
//  WebImageView.swift
//  demo
//
//  Created by Michał Hęćka on 21/04/2022.
//

import UIKit

class WebImageView : UIViewController {
    
    var imageUrl : URL?//url of displayed photo injected by segue
    
    var alert : Alert? = nil
    
    func loadImageWeb(completionSuccess : (URLRequest) -> (), completionFailure : (String) -> ()){//check if url is correct
        guard let url = imageUrl else {
            completionFailure("Niepoprawny link")
            return
        }
        completionSuccess(URLRequest(url: url))
    }
    
    
}
