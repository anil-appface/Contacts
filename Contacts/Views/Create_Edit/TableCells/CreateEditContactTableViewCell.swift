//
//  CreateEditContactTableViewCell.swift
//  Contacts
//
//  Created by Anil Kumar on 25/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit



class CreateEditContactTableViewCell: UITableViewCell {
    
    var textFieldValueChange:(( _ cellType: CellType? , _ value:String?) -> Void)?
    
    var contactAttribute: ContactTableCellAttribute? {
        didSet {
            valueTextField?.placeholder = contactAttribute?.key
            valueTextField?.text = contactAttribute?.value
            keyLabbel?.text = contactAttribute?.key
            valueTextField?.keyboardType = contactAttribute?.textFieldType ?? .default
        }
    }
    
    static let reuseIdentifier = "CreateEditContactTableViewCellIdentifier"
    
    @IBOutlet weak var valueTextField: UITextField? {
        didSet {
            
            valueTextField?.delegate = self
            valueTextField?.addTarget(self, action:
                #selector(textFieldDidChange),
                                      for: .editingChanged)
        }
    }
    @IBOutlet weak var keyLabbel: UILabel?
    
    
    @objc func textFieldDidChange(textField: UITextField){
        contactAttribute?.value = textField.text ?? ""
        textFieldValueChange?(contactAttribute?.cellType, contactAttribute?.value)
    }
}


// MARK: - UITextFieldDelegate
extension CreateEditContactTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        valueTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        valueTextField = nil
    }
}

