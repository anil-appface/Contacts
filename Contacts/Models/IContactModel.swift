//
//  IContact.swift
//  Contacts
//
//  Created by Anil Kumar on 21/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation


protocol IContactModel: Codable {
    
    var id : Int? { get }
    var firstName : String? { get }
    var lastName : String? { get }
    var profilePic : String? { get }
    var favorite : Bool? { get }
    var url : String? { get }
    
}



extension IContactModel {
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
}
