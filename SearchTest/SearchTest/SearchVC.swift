//
//  SearchVC.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/22.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var isSearchTextFieldOK = false
    var isNumTextFieldOK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        AddEvent()
    }
    
    func initUI() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let screenHeight: CGFloat = screenSize.height
        
        let leading: CGFloat = 15
        let gap: CGFloat = 20
        let itemHeight = screenHeight/15
        let itemWidth = screenWidth - leading * 2
        
        self.title = "搜尋輸入頁"
        
        //searchTextField
        searchTextField.frame = CGRect(x: leading, y: screenHeight/2 - itemHeight * 3/2 - gap, width: itemWidth, height: itemHeight)
        searchTextField.placeholder = "欲搜尋內容"
        
        //searchTextField
        numTextField.frame = CGRect(x: leading, y: screenHeight/2 - itemHeight/2, width: itemWidth, height: itemHeight)
        numTextField.placeholder = "每頁呈現數量"
        numTextField.keyboardType = .namePhonePad
        
        //searchTextField
        searchBtn.frame = CGRect(x: leading, y: screenHeight/2 + itemHeight/2 + gap, width: itemWidth, height: itemHeight)
        searchBtn.backgroundColor = UIColor.gray
        searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchBtn.setTitle("搜尋", for: .normal)
        searchBtn.isEnabled = false
    }
    
    func AddEvent() {
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        numTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchBtn.addTarget(self, action: #selector(searchBtnPressed), for: .touchUpInside)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        let textCount = textfield.text?.count ?? 0
        if textfield == searchTextField {
            isSearchTextFieldOK = textCount > 0 ? true : false
        } else if textfield == numTextField {
            isNumTextFieldOK = textCount > 0 ? true : false
            
            let pageNum = Int(textfield.text ?? "") ?? -99
            if pageNum < 0 {
                isNumTextFieldOK = false
            }
        }
        
        if isSearchTextFieldOK && isNumTextFieldOK {
            searchBtn.isEnabled = true
            searchBtn.backgroundColor = UIColor.blue
        } else {
            searchBtn.isEnabled = false
            searchBtn.backgroundColor = UIColor.gray
        }
    }
    
    @objc func searchBtnPressed(sender : UIButton!)
    {
        APIManager.instance.searchText = searchTextField.text ?? ""
        APIManager.instance.searchPerPage = numTextField.text ?? ""
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoTabBarViewController") as? photoTabBarViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

