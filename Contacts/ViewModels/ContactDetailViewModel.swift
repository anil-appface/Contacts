
//
//  ContactDetailViewModel.swift
//  Contacts
//
//  Created by Anil Kumar on 20/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation


class ContactDetailViewModel {
    
    
    var contact: Contact? {
        didSet {
            contactTableData["mobile"] = contact.
        }
    }
    var contactTableData: [String: String?] = [:]
    
    typealias ImageDownloadCompletionClosure = (_ imageData: Data ) -> Void
    
    init(_ _contact: Contact?) {
        contact = _contact
    }
    
    
}


extension ContactDetailViewModel {
    
    
    func getProfilePicUrl() -> String {
        
        guard let url = contact?.profilePic else {
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
    
}
