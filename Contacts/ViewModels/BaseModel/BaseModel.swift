//
//  BaseModel.swift
//  Contacts
//
//  Created by Anil Kumar on 25/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation



protocol BaseViewModel {
    
    typealias ImageDownloadCompletionClosure = (_ imageData: Data ) -> Void
    
}

extension BaseViewModel {
    
    func download(url: String, completionHandler: @escaping ImageDownloadCompletionClosure)
    {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:URL.init(string: url)!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            
            if let tempLocalUrl = tempLocalUrl, error == nil ,let rawImageData = try? Data.init(contentsOf: tempLocalUrl){
                completionHandler(rawImageData)
                
            } else {
                print("Error took place while downloading a file. Error description: \(String(describing: error?.localizedDescription))")
            }
        }
        
        task.resume()
        
    }
    
    
}
