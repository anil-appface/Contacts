
//
//  ContactDetailViewModel.swift
//  Contacts
//
//  Created by Anil Kumar on 20/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation


protocol ContactDetailViewModelDelegate: class {
    func updateTableData()
}

class ContactDetailViewModel : BaseViewModel {
    
    
    var contactDetail: ContactDetail? {
        didSet {
            contactTableData = []
            contactTableData.append(ContactAttribute(key: "mobile",value: contactDetail?.phoneNumber))
            contactTableData.append(ContactAttribute(key: "email",value: contactDetail?.email))
            
            delegate?.updateTableData()
        }
    }
    
    weak var delegate: ContactDetailViewModelDelegate?
    
    var contactTableData: [ContactAttribute] = []
    
    private let requester: Requestable = Requester()
    

    
    private (set) var contactDetailsUrl = "http://gojek-contacts-app.herokuapp.com/contacts/{id}.json"
   
    init(_ contactId: Int?) {
        
        guard let id = contactId else {
            return
        }
        
        contactDetailsUrl = contactDetailsUrl.replacingOccurrences(of: "{id}", with: String(id))
        
        fetchContact(forContactId: id)
    }
    
    
}

extension ContactDetailViewModel {
    
    
    func getContactAttribute(atIndex index: Int) -> ContactAttribute {
        return contactTableData[index]
    }
    
    func toggleFavorite() {
        contactDetail?.favorite = !(contactDetail?.favorite ?? false)
        updateContact()
    }
    
}

extension ContactDetailViewModel {
    
    
    func getProfilePicUrl() -> String {
        
        guard let url = contactDetail?.profilePic else {
            return "http://gojek-contacts-app.herokuapp.com/images/missing.png"
        }
        print(url)
        return "http://gojek-contacts-app.herokuapp.com" + url
        
    }
    
   
    
    
    func fetchContact(forContactId id: Int) {
        
        requester.request(parameter: ContactDetail.self, method: .get, url: contactDetailsUrl) { (result) in
            switch result {
            case .success(let response):
                
                self.contactDetail = response
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
     func updateContact() {
         
        requester.request(parameter: ContactDetail.self, method: .put, url: contactDetailsUrl, httpBody:  contactDetail?.jsonData()) { (result) in
             switch result {
             case .success(let response):
                  self.contactDetail = response
             case .failure(let error):
                 print(error)
             }
         }
     }
     
}
