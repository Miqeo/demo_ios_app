//
//  Request.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import Foundation
import Alamofire

class Request{
    
    
    func ask(url : String, completion : @escaping (Data?, String?) -> ()){
        
        do{
            let getRequest = try URLRequest(url: URL(string: url)!, method: .get)//tworzenie zapytania
            
            AF.request(getRequest).response { (response) in
                switch (response.result){
                case .success(_):
                    
                    completion(response.data, nil)
                    break
                case .failure(let err):
                    
                    switch (err.responseCode) {
                    case 404:
                        completion(nil, "problem z połączeniem z bazą")
                        break
                    case 500:
                        completion(nil, "problem po stronie użytkownika")
                        break
                    default:
                        completion(nil, "problem z połączeniem")
                    }
                    break
                }
                
            }
        }
        catch{
            completion(nil, "problem przy tworzeniu zapytania")
        }
    }
    
    
}
