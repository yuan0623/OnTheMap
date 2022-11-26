//
//  getUserPublicDataResponse.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/26/22.
//

import Foundation



struct getUserPublicDataResponse:Codable{
    let lastName:String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
