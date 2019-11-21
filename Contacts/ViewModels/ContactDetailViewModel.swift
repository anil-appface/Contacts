
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

class ContactDetailViewModel {
    
    
    var contactDetail: ContactDetail? {
        didSet {
            contactTableData.append(ContactAttribute(key: "mobile",value: contactDetail?.phoneNumber))
            contactTableData.append(ContactAttribute(key: "email",value: contactDetail?.email))
            
            delegate?.updateTableData()
        }
    }
    
    weak var delegate: ContactDetailViewModelDelegate?
    
    var contactTableData: [ContactAttribute] = []
    
    private let requester: Requestable = Requester()
    
    typealias ImageDownloadCompletionClosure = (_ imageData: Data ) -> Void
    
    
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
    
}

extension ContactDetailViewModel {
    
    
    func getProfilePicUrl() -> String {
        
        guard let url = contactDetail?.profilePic else {
            return "http://gojek-contacts-app.herokuapp.com/images/missing.png"
        }
        print(url)
        return "http://gojek-contacts-app.herokuapp.com" + url
        
    }
    
    func download(url: String, completionHanlder: @escaping ImageDownloadCompletionClosure)
    {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:URL.init(string: url)!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    let rawImageData = try? Data.init(contentsOf: tempLocalUrl)
                    completionHanlder(rawImageData!)
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(String(describing: error?.localizedDescription))")
            }
        }
        
        task.resume()
        
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
    
}
