//
//  alert.swift
//  demo
//
//  Created by Michał Hęćka on 22/04/2022.
//

import UIKit

class Alert {//class responsible for showing alerts
    
    private var view : UIViewController?
    
    init(view : UIViewController) {//setup view where alerts should be displayed
        self.view = view
    }
    
    func show(title : String, sub : String, actions : Array<UIAlertAction>){
        let alert = UIAlertController(title: title, message: sub, preferredStyle: .alert)
        
        for action in actions {//add actions to alert
            alert.addAction(action)
        }
        
        view!.present(alert, animated: true)
    }
}
