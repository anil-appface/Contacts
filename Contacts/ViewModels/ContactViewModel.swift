//
//  ContactViewModel.swift
//  Contacts
//
//  Created by Anil Kumar on 20/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation

protocol ContactViewModelDelegate: class {
    func updateContacts()
}


class ContactViewModel {
    
    var isLoading: Bool = false

    private (set) var contactsDictionary: [String: [Contact]] = [:] {
        didSet {
            allSections = contactsDictionary.keys.sorted()
            delegate?.updateContacts()
        }
    }
    private (set) var allSections: [String] = []
    
    weak var delegate: ContactViewModelDelegate?
    
    private let requester: Requestable = Requester()
    
    
    static let contactsUrl = "http://gojek-contacts-app.herokuapp.com/contacts.json"
    
    init() {
        
    }
    
}

extension ContactViewModel {

  
   
    
     func fetchAllContacts() {
        isLoading = true
        requester.request(parameter: [Contact].self, method: .get, url: ContactViewModel.contactsUrl) { (result) in
            switch result {
            case .success(let response):
                
                self.contactsDictionary = Dictionary(grouping: response ) {  String($0.firstName!.first!) }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    
}


extension ContactViewModel {
    
    func getContactAt(section: Int, row: Int) -> Contact? {
        return contactsDictionary[allSections[section]]?[row]
    }
    
}
