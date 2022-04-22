//
//  PhotoTableView.swift
//  demo
//
//  Created by Michał Hęćka on 21/04/2022.
//

import UIKit

class PhotoTableView : UITableViewController{
    
    //private store of downloaded values
    private var albums : Array<Album.AlbumData> = []
    private var photos : Array<Photo.PhotoData> = []
    private var store = ImageStore(limit: 100)
    
    var alert : Alert? = nil
    
    //value getters
    func getAlbumCount() -> Int{
        return albums.count
    }
    
    func getPhotoCount() -> Int{
        return photos.count
    }
    
    func getAlbumData(id : Int) -> Album.AlbumData{
        return albums[id]
    }
    
    func getPhotoData(id : Int) -> Photo.PhotoData?{
        return photos[id]
    }
    
    func getImage(photoData : Photo.PhotoData, completion : @escaping (UIImage?) -> ()){
        
        if let image = store.images[photoData.id]{
            completion(image)
        }
        else{
//            print(photoData.thumbnailUrl)
            
            Photo().getImage(url: photoData.thumbnailUrl, completion: { [self] (image) in
                completion(image.img)
                
                store.add(at: photoData.id, optionalImage: image.img)
            })
            
            
        }
    }
    
    func getCellPhotoCount(section : Int) -> Int{
        return photos.filter{ $0.albumId == section + 1 }.count
    }
    
    func getCellPhotoData(indexPath : IndexPath) -> Photo.PhotoData{
        return photos.filter{ $0.albumId == indexPath.section + 1 }[indexPath.row]
    }
    
    //value setter
    func setup(completionSuccess : @escaping () -> (), completionFailure : @escaping (String) -> ()){
        
        Album().getList(url: "https://jsonplaceholder.typicode.com/albums") { (_albums) in
            
            if let err = _albums.error{
                print(err)
                completionFailure(err)
                return
            }
            else{
                self.albums = _albums.list
            }
            
        }
        
        Photo().getList(url: "https://jsonplaceholder.typicode.com/photos") { (_photos) in
            
            print(_photos.list.count)
            
            if let err = _photos.error{
                print(err)
                completionFailure(err)
            }
            else{
                self.photos = _photos.list
                completionSuccess()
            }
            
        }
    }
    
}
