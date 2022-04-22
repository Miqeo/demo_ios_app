//
//  ImageStore.swift
//  demo
//
//  Created by Michał Hęćka on 21/04/2022.
//

import UIKit

struct ImageStore {//structure made to store set limit of images
    var images : Dictionary<Int, UIImage> = [:]//key - id of image
    
    private var limit = 50//default limit
    
    init(limit : Int) {
        self.limit = limit
    }
    
    mutating func add(at : Int, optionalImage : UIImage?) {//method to delete previous image when adding new
        
        if let image = optionalImage{
            images[at] = image//when image is present, save it
            print("added at \(at)")
        
            if let max = images.keys.max(), let min = images.keys.min(){//if minimum and maximum id is present
                
                if images.count > limit{//and count is outside the limit
                    
                    //delete lower id when adding higher and vice versa
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
