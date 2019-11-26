//
//  CreateEditContactViewModel.swift
//  Contacts
//
//  Created by Anil Kumar on 22/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation
import UIKit

enum CellType {
    case firstName
    case lastName
    case mobile
    case email
}

struct ContactTableCellAttribute {
    
    var key: String?
    var value: String?
    var textFieldType: UIKeyboardType = .default
    var cellType: CellType?
}

protocol CreateEditContactViewModelDelegate: class {
    func updateTableData()
    func errorCreatingUpdatingContact(error: String?)
    func successCreatingUpdatingContact()
}


class CreateEditContactViewModel {
    
    var contactDetail: ContactDetail? {
        
        didSet {
            if contractAttribute.count > 0 { return }
            
            contractAttribute.append(ContactTableCellAttribute(key: "First Name", value: contactDetail?.firstName, cellType: .firstName))
            contractAttribute.append(ContactTableCellAttribute(key: "Last Name", value: contactDetail?.lastName, cellType: .lastName))
            contractAttribute.append(ContactTableCellAttribute(key: "Mobile", value: contactDetail?.phoneNumber, textFieldType: .phonePad, cellType: .mobile))
            contractAttribute.append(ContactTableCellAttribute(key: "Email", value: contactDetail?.email, textFieldType: .emailAddress, cellType: .email))
            
            
            delegate?.updateTableData()
            
            
        }
    }
    
    var contractAttribute: [ContactTableCellAttribute] = []
    
    var isCreate: Bool? {
        didSet {
            if isCreate == true {
                contactDetail = ContactDetail(id: nil, firstName: nil, lastName: nil, profilePic: nil, favorite: false, url: nil, email: nil, phoneNumber: nil)
                
            }
        }
    }
    
    weak var delegate: CreateEditContactViewModelDelegate?
    
    private let requester: Requestable = Requester()
    
    private (set) var contactDetailsUrl = "http://gojek-contacts-app.herokuapp.com/contacts/{id}.json"
    
    private (set) var createContactUrl = "http://gojek-contacts-app.herokuapp.com/contacts.json"
    
    private (set) var updateContactUrl = "http://gojek-contacts-app.herokuapp.com/contacts/{id}.json"
    
    init(_ contactId: Int? = nil) {
        
        guard let id = contactId else {
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.isCreate = true
            }
            
            return
        }
        
        isCreate = false
        
        contactDetailsUrl = contactDetailsUrl.replacingOccurrences(of: "{id}", with: String(id))
        updateContactUrl = updateContactUrl.replacingOccurrences(of: "{id}", with: String(id))
        
        fetchContact(forContactId: id)
        
    }
    
    
}

extension CreateEditContactViewModel{
    
    func updateContactDetailValue(cellType: CellType?, value: String?) {
        
        guard let type = cellType else {
            return
        }
        
        switch type {
        case .email:
            contactDetail?.email = value
        case .firstName:
            contactDetail?.firstName = value
        case .lastName:
            contactDetail?.lastName = value
        case .mobile:
            contactDetail?.phoneNumber = value
        }
        
    }
    
    func updateOrCreateContact(){

        if isCreate == true {
            createContact()
        } else {
            updateContact()
        }
    }
    
    func isValidContactEmail() -> Bool {
        
        guard let email = contactDetail?.email else {
            return true
        }
        
        return email.isValidEmail
    }
    
    func isValidContactMobile() -> Bool {
        
        guard let phoneNumber = contactDetail?.phoneNumber else {
            return true
        }
        
        return phoneNumber.isValidPhone
    }
}

extension CreateEditContactViewModel {
    
    
    func fetchContact(forContactId id: Int) {
        
        requester.request(parameter: ContactDetail.self, method: .get, url: contactDetailsUrl) { [weak self] (result) in
            switch result {
            case .success(let response):
                
                self?.contactDetail = response
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func updateContact() {
        
        requester.request(parameter: ContactDetail.self, method: .put, url: updateContactUrl, httpBody:  contactDetail?.jsonData()) { [weak self] (result) in
            switch result {
            case .success(let response):
                print(response)
                self?.delegate?.successCreatingUpdatingContact()
            case .failure(let error):
                if let e = error as? GojekError {
                    self?.delegate?.errorCreatingUpdatingContact(error: e.errors?.first)
                }
                self?.delegate?.errorCreatingUpdatingContact(error: error.localizedDescription)
            }
        }
    }
    
    
    
    func createContact() {
        
        requester.request(parameter: ContactDetail.self, method: .post, url: createContactUrl, httpBody:  contactDetail?.jsonData()) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.delegate?.successCreatingUpdatingContact()
            case .failure(let error):
                if let e = error as? GojekError {
                    self?.delegate?.errorCreatingUpdatingContact(error: e.errors?.first)
                }
                self?.delegate?.errorCreatingUpdatingContact(error: error.localizedDescription)
            }
        }
    }
    
}
