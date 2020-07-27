//
//  FunctionManager.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/24.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import Foundation
import UIKit

class FunctionManager
{
    public static func showCheckMessage(vc: UIViewController, titleStr:String, messageStr:String, yesFunction: @escaping ((UIAlertAction)->Void)) -> Void {
        let alert = UIAlertController(title: titleStr,
                                      message: messageStr,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "確認", style: .default, handler: yesFunction)
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true)
    }
}
