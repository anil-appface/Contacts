//
//  uiviewcontroller-extension.swift
//  Contacts
//
//  Created by Anil Kumar on 26/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
