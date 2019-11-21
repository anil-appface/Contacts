//
//  Contact.swift
//  Contacts
//
//  Created by Anil Kumar on 21/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation


struct Contact : IContactModel, Hashable {
    
    let id : Int?
    let firstName : String?
    let lastName : String?
    let profilePic : String?
    let favorite : Bool?
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite = "favorite"
        case url = "url"
    }
}




// MARK: Convenience initializers
extension Contact {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Contact.self, from: data)
    }
    
}
