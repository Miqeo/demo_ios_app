//
//  ImageStore.swift
//  demo
//
//  Created by Michał Hęćka on 21/04/2022.
//

import UIKit

struct ImageStore {
    var images : Dictionary<Int, UIImage> = [:]
    
    private var limit = 50
    
    init(limit : Int) {
        self.limit = limit
    }
    
    mutating func add(at : Int, optionalImage : UIImage?) {
        
        if let image = optionalImage{
            images[at] = image
            print("added at \(at)")
        
            if let max = images.keys.max(), let min = images.keys.min(){
                
                if images.count > limit{
                    
                    if at > min {
                        images.removeValue(forKey: min)
                        print("deleted at \(min)")
                    }
                    else if at < max {
                        images.removeValue(forKey: max)
                        print("deleted at \(max)")
                    }
                    
                }
            }
        }
        
    }
}
