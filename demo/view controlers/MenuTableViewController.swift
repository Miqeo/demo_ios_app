//
//  TableViewController.swift
//  demo
//
//  Created by Michał Hęćka on 20/04/2022.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    
    
    var albums : Array<Album.AlbumData> = []
    var photos : Array<Photo.PhotoData> = []
    var store = ImageStore(limit: 60)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "PhotoViewCellRight", bundle: nil), forCellReuseIdentifier: "PhotoViewCellRight")
        self.tableView.register(UINib(nibName: "PhotoViewCellLeft", bundle: nil), forCellReuseIdentifier: "PhotoViewCellLeft")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Album().getList(url: "https://jsonplaceholder.typicode.com/albums") { (_albums) in
            
//            print(_albums)
            
            if let err = _albums.error{
                print(err)
            }
            else{
                self.albums = _albums.list
            }
            
        }
        
        Photo().getList(url: "https://jsonplaceholder.typicode.com/photos") { (_photos) in
            
            print(_photos.list.count)
            
            if let err = _photos.error{
                print(err)
            }
            else{
                self.photos = _photos.list
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return albums.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(photos.filter{ $0.albumId == section + 1 }.count)
        
        return photos.filter{ $0.albumId == section + 1 }.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()

        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 28))
        
        label.text = albums[section].title
        
        header.addSubview(label)
        header.bringSubviewToFront(label)
        
        return header
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let photoData = photos.filter{ $0.albumId == indexPath.section + 1 }[indexPath.row]
        
        let indentifier = (photoData.id) % 2 == 0 ? "PhotoViewCellLeft" : "PhotoViewCellRight" 
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath) as! PhotoViewCell
        
        
        
        
        if let title = cell.titleView{
            title.text = photoData.title
        }
        
         
        if let photoView = cell.photoView{
            photoView.image = nil
            
            print(photoData.id)
            
            if let image = store.images[photoData.id]{
                photoView.image = image
            }
            else{
                print(photoData.thumbnailUrl)
                
                Photo().getImage(url: photoData.thumbnailUrl, completion: { [self] (image) in
                    photoView.image = image.img
                    
                    store.add(at: photoData.id, optionalImage: image.img)
                    
                })
                
            }
            
        }
         

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
