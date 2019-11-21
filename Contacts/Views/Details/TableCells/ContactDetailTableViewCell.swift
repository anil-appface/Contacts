//
//  File.swift
//  Contacts
//
//  Created by Anil Kumar on 21/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit



class ContactDetailTableViewCell: UITableViewCell
{
    
    static let reuseIdentifier = "ContactDetailTableViewCellIdentifier"
    
    var contactAttribute: ContactAttribute? {
        didSet {
            keyLabel?.text = contactAttribute?.key
            valueLabel?.text = contactAttribute?.value
        }
    }
    
    @IBOutlet weak var keyLabel: UILabel?
    @IBOutlet weak var valueLabel: UILabel?
    
}
