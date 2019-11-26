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
            
            
            accessoryView = UIImageView(image: (contact?.favorite == true) ?
                #imageLiteral(resourceName: "home_favourite"):  nil)
            accessoryView?.inputView?.backgroundColor = .red
            
            
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        
        contentView.backgroundColor = highlighted ? .lightGray : .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? .lightGray : .none
    }
    
    
}
