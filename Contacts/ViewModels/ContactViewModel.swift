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


class ContactViewModel: BaseViewModel {
    
    private (set) var contactsDictionary: [String: [Contact]] = [:] {
        didSet {
            allSections = contactsDictionary.keys.sorted()
            delegate?.updateContacts()
        }
    }
    private (set) var allSections: [String] = []
    
    weak var delegate: ContactViewModelDelegate?
    
    private let requester: Requestable = Requester()
    
    let contactsUrl = "http://gojek-contacts-app.herokuapp.com/contacts.json"
    var deleteContactUrl = "http://gojek-contacts-app.herokuapp.com/contacts/{id}.json"
    
    init() {
        
    }
    
}

extension ContactViewModel {
    
    func fetchAllContacts() {
        
        requester.request(parameter: [Contact].self, method: .get, url: contactsUrl) { (result) in
            switch result {
            case .success(let response):
                
                self.contactsDictionary = Dictionary(grouping: response ) {  String($0.firstName!.first!) }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteContact(contact: Contact) {
        
        deleteContactUrl = deleteContactUrl.replacingOccurrences(of: "{id}", with: String(contact.id!))
        
        requester.request(parameter: Contact.self, method: .delete, url: deleteContactUrl) { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteContactAt(indexPath: IndexPath) {
        
        
        if let contact = getContactAt(section: indexPath.section, row: indexPath.row) {
            deleteContact(contact: contact)
            contactsDictionary[allSections[indexPath.section]]?.remove(at: indexPath.row)
        }
        
    }
    
    
}


extension ContactViewModel {
    
    func getContactAt(section: Int, row: Int) -> Contact? {
        return contactsDictionary[allSections[section]]?[row]
    }
    
}
