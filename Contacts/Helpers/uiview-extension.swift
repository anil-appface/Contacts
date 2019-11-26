//
//  uiview-extension.swift
//  Contacts
//
//  Created by Anil Kumar on 21/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit


extension UIView{
    func drawRoundCorner(withRadius : CGFloat = 5.0){
        self.layer.cornerRadius = withRadius
        self.layer.masksToBounds = true
    }

}
