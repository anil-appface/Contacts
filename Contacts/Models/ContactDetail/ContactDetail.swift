//
//  ContactDetail.swift
//  Contacts
//
//  Created by Anil Kumar on 21/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation

struct ContactAttribute {
    
    var key: String?
    var value: String?
    
}

struct ContactDetail : IContactModel, Hashable {
    
    let id : Int?
    var firstName : String?
    var lastName : String?
    var profilePic : String?
    var favorite : Bool?
    var url : String?
    var email: String?
    var phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite = "favorite"
        case email = "email"
        case phoneNumber = "phone_number"
        case url = "url"
    }
}




// MARK: Convenience initializers
extension ContactDetail {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(ContactDetail.self, from: data)
    }
    
}
