//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Anil Kumar on 20/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation
import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let resuseIdentifier = "ContactTableViewCellIdentifier"
    
    @IBOutlet weak var nameLabel: UILabel!
    var contact: Contact? {
        didSet {
            nameLabel.text = contact?.firstName
        }
    }
    
}
