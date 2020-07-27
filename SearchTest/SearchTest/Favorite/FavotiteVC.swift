//
//  FavotiteVC.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/24.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import UIKit

class FavotiteVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    func initUI() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let screenHeight: CGFloat = screenSize.height
        
        self.title = "Favotite"
        
        //collectionView
        collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = (screenWidth - 10) / 2
        layout?.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoreDataManager.instance.fetchPhoto()
        collectionView.reloadData()
    }
}

extension FavotiteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreDataManager.instance.lovePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.initUI()
        let photo = CoreDataManager.instance.lovePhotos[indexPath.item]
        cell.lable.text = photo.title
        if photo.image != nil {
            cell.img.image = UIImage(data: photo.image!)
        }
        return cell
    }
    
    
}
