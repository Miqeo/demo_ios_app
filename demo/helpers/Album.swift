//
//  Album.swift
//  demo
//
//  Created by Michał Hęćka on 19/04/2022.
//

import Foundation

class Album : Request{
    
    struct AlbumData : Codable{
        var userId : Int
        var id : Int
        var title : String
    }
    
    struct AlbumList : Codable {
        var list : Array<AlbumData>
        var error : String?
    }
    
    func getList(url : String, completion : @escaping (AlbumList) -> ()) {
        ask(url: url) { (optionalData, optionalError) in
            
            var albums : AlbumList = AlbumList(list: [], error: nil)
            
            if let error = optionalError{
                albums.error = error
                completion(albums)
                return
            }
            
            if let data = optionalData {
                
                do{
                    albums.list = try JSONDecoder().decode(Array<AlbumData>.self, from: data)
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
