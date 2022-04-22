//
//  Request.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import Foundation
import Alamofire

class Request{//class responsible for communicating with outside world
    
    
    func ask(url : String, completion : @escaping (Data?, String?) -> ()){
        
        do{
            let getRequest = try URLRequest(url: URL(string: url)!, method: .get)//generating get request
            
            AF.request(getRequest).response { [self] (response) in
                switch (response.result){
                case .success(_)://when successful complete without error
                    
                    completion(response.data, nil)
                    break
                case .failure(let err)://when failure complete without data but with description of error
                    
                    completion(nil, errorControll(errCode: err.responseCode))
                    break
                }
                
            }
        }
        catch{//when failure complete without data but with description of error
            completion(nil, "problem przy tworzeniu zapytania")
        }
    }
    
    func errorControll(errCode : Int?) -> String{//default responses to diffrent response codes including nil
        switch (errCode) {
        case 404:
            return "problem z połączeniem z bazą"
        case 500:
            return "problem po stronie użytkownika"
        default://general error description
            return "problem z połączeniem"
        }
    }
}
