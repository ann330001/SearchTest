//
//  ResultVC.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/22.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    var footerView: UpdateFooterView?
    var isFooterAnimate: Bool = false
    
    var selectedItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        addEvent()
    }
    
    func initUI() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let screenHeight: CGFloat = screenSize.height
        
        self.title = "Featured"
        
        //collectionView
        collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = (screenWidth - 10) / 2
        layout?.itemSize = CGSize(width: width, height: width)

        //refreshControl
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新中...")
        collectionView.addSubview(refreshControl)

        APIManager.instance.getSearchData(page: 1)
        collectionView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addEvent() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        APIManager.instance.getSearchData(page: 1)
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func addToFavorivate(alert: UIAlertAction!)
    {
        let photo = APIManager.instance.photos[selectedItem]
        let title = photo.title
        var img:UIImage? = nil
        APIManager.instance.downloadImage(url: photo.imageUrl){ (image) in
            img = image
            if img != nil {
                var imgData = UIImageJPEGRepresentation(img!, 1.0)
                CoreDataManager.instance.addNewPhoto(title: title, data: imgData!)
            }
        }
    }
}

extension ResultVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        APIManager.instance.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCell", for: indexPath) as! ResultCollectionViewCell
        cell.initUI()
        let photo = APIManager.instance.photos[indexPath.item]
        cell.imageURL = photo.imageUrl
        cell.lable.text = photo.title
        cell.img.image = nil
        APIManager.instance.downloadImage(url: photo.imageUrl){ (image) in
            if cell.imageURL == photo.imageUrl, let image = image  {
                DispatchQueue.main.async {
                    cell.img.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UpdateFooterView", for: indexPath) as! UpdateFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            return header
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isFooterAnimate {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter{
            footerView?.prepareInitialAnimation()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter{
            footerView?.stopAnimate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.item
        FunctionManager.showCheckMessage(vc: self, titleStr: "確認要將此檔案加入我的最愛？", messageStr: "", yesFunction: addToFavorivate(alert:))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == tabBarController?.tabBar.frame.size.height
        {
            guard let footerView = self.footerView, footerView.isAnimatingFinal else { return }
            print("load more trigger")
            self.footerView?.startAnimate()
            isFooterAnimate = true
            let searchPage = Int32(APIManager.instance.currentPage + 1)
            if searchPage < APIManager.instance.totalPages {
                APIManager.instance.getSearchData(page: searchPage)
                collectionView.reloadData()
                collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                isFooterAnimate = false
            } else {
                footerView.stopAnimate()
                isFooterAnimate = false
            }
            
        }
    }
    
}
