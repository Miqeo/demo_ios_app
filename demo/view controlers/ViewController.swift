//
//  ViewController.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Album().getList(url: "https://jsonplaceholder.typicode.com/albums") { (albums) in
            
            print(albums)
        }
        
        Photo().getList(url: "https://jsonplaceholder.typicode.com/photos") { (photos) in
            
//            print(photos)
            print(photos.list.count)
            print(photos.list[0])
            
        }
    }


}


