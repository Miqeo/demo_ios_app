//
//  Image.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import Foundation

class Photo : Request{
    
    struct PhotoData : Codable{
        var albumId : Int
        var id : Int
        var title : String
        var url : String
        var thumbnailUrl : String
    }
    
    struct PhotoList : Codable {
        var list : Array<PhotoData>
        var error : String?
    }
    
    func getList(url : String, completion : @escaping (PhotoList) -> ()) {
        ask(url: url) { (optionalData, optionalError) in
            
            var albums : PhotoList = PhotoList(list: [], error: nil)
            
            if let error = optionalError{
                albums.error = error
                completion(albums)
                return
            }
            
            if let data = optionalData {
                
                do{
                    albums.list = try JSONDecoder().decode(Array<PhotoData>.self, from: data)
                }
                catch{
                    albums.error = "problem przy parsowaniu albumu"
                }
            }
            else{
                albums.error = "problem przy pobieraniu albumu"
            }
            
            completion(albums)
        }
    }
}
