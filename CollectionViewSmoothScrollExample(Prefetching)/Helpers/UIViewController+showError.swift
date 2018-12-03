//
//  UIViewController+showError.swift
//  CollectionViewSmoothScrollExample(Prefetching)
//
//  Created by David on 06/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(withTitle: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
