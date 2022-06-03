//
//  Image.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import UIKit

class Photo : Request {
    
    struct PhotoData : Codable{//data of particular photo
        var albumId : Int
        var id : Int
        var title : String
        var url : String
        var thumbnailUrl : String
    }
    
    struct PhotoList : Codable {//place of photos data downloaded from json
        var list : Array<PhotoData>
        var error : String?
    }
    
    struct PhotoImage{//downloaded image
        var img : UIImage?
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
            
            guard let data = optionalData else {
                albums.error = "problem przy pobieraniu albumu"
                
                completion(albums)
                return
            }
            
            do{
                albums.list = try JSONDecoder().decode(Array<PhotoData>.self, from: data)
            }
            catch{
                albums.error = "problem przy parsowaniu albumu"
            }
            
            completion(albums)
        }
    }
    
    func getImage(url : String, completion : @escaping (PhotoImage) -> ()) {
        
        
        ask(url: url) { (optionalData, optionalError) in
            
            var photo = PhotoImage(img: nil, error: nil)
            
            if let error = optionalError{
                photo.error = error
                completion(photo)
                return
            }
            
            guard let data = optionalData else {
                photo.error = "problem przy pobieraniu zdjęcia"
                
                completion(photo)
                return
            }
            
            photo.img = UIImage(data: data)
            
            completion(photo)
        }
    }
}
