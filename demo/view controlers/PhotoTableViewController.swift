//
//  TableViewController.swift
//  demo
//
//  Created by Michał Hęćka on 20/04/2022.
//

import UIKit

class PhotoTableViewController: PhotoTableView {//class responsible for look of photo table view
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate (responsibility of) and data source table view to self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //registrating cell xibs to use in table view
        self.tableView.register(UINib(nibName: "PhotoViewCellRight", bundle: nil), forCellReuseIdentifier: "PhotoViewCellRight")
        self.tableView.register(UINib(nibName: "PhotoViewCellLeft", bundle: nil), forCellReuseIdentifier: "PhotoViewCellLeft")
        
        //refresh controll and its action
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        alert = Alert(view: self as UIViewController)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onReceiveData(_:)), name: Notification.Name("ReceiveData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onReceivePosition(_:)), name: NSNotification.Name(rawValue: "ReceivePosition"), object: nil)
        
        setupRecurse()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ReceiveData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ReceivePosition"), object: nil)
    }
    
    @objc func onReceiveData(_ notification:Notification) {
        print("aktualizacja danych")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setupRecurse()
        }
        
    }
    
    @objc func onReceivePosition(_ notification:Notification) {
        
        print("pozycja zmiana")
        if let indexPath = notification.object as? IndexPath {
            print("pozycja \(indexPath)")
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
        
    }
    
    
    @IBAction func refreshData(_ sender: Any){//pull down refresh method
        
        
        setup { optionalError in
            
            guard let error = optionalError else {
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
                return
            }
            
            self.alert!.show(title: "Error", sub: error, actions: [
                UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            ])
            
            self.refreshControl!.endRefreshing()
        }
        

        
        
    }
    
    func setupRecurse(){//recursively setup data when error occured
        view.showLoading()
        setup { optionalError in
            self.view.removeLoading()
            guard let error = optionalError else {
                self.tableView.reloadData()
                return
            }
            
            self.alert!.show(title: "Error", sub: error, actions: [
                UIAlertAction(title: "Odśwież", style: .default, handler: { [self] (_) in
                    setupRecurse()
                })
            ])
            
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return getAlbumCount()//number of sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getCellPhotoCount(section : section)//filtered number of photos belonging to album (section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //section header setup
        let header = UITableViewHeaderFooterView()

        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 28))
        
        label.text = getAlbumData(id: section).title
        
        header.addSubview(label)
        header.bringSubviewToFront(label)
        
        return header
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let photoData = getCellPhotoData(indexPath: indexPath)//get single photo
        
        let indentifier = (photoData.id) % 2 == 0 ? "PhotoViewCellLeft" : "PhotoViewCellRight"//when id of photo is even use left and vice versa
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath) as! PhotoViewCell
        
        if let title = cell.titleView, let photoView = cell.photoView{//if we know
            title.text = photoData.title//set title
            
            photoView.image = nil//clear previous image
            
            getImage(photoData: photoData) { (img) in
                photoView.image = img//set new image
            }
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoData = getCellPhotoData(indexPath: indexPath)
        
        //user has choice to open link in app or web browser
        alert!.show(title: "Otwórz obraz", sub: "Otwórz obraz w przeglądarce czy w aplikacji?", actions: [
            UIAlertAction(title: "Przeglądarka", style: .default, handler: { (_) in
                if let url = URL(string: photoData.url){
                    UIApplication.shared.open(url)//web browser
                }
            }),
            UIAlertAction(title: "Aplikacja", style: .default, handler: { (_) in
                if let url = URL(string: photoData.url){
                    self.performSegue(withIdentifier: "ShowImage", sender: url)//app
                }
            }),
            UIAlertAction(title: "Anuluj", style: .cancel, handler: nil)
        ])

        tableView.deselectRow(at: indexPath, animated: true)//deselection of row
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//preparation to segue
        
        switch segue.identifier {
        case "ShowImage":
            if let url = sender as? URL{
                let VC = segue.destination as! WebImageView
                VC.imageUrl = url//injecting url value to VC
            }
            break
        default:
            break
        }
    }
}
