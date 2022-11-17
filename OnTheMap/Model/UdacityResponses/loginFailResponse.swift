//
//  loginFailResponse.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/17/22.
//

import Foundation

struct loginFailResponse:Codable{
    let status:Int
    let error:String
    enum CodingKeys: String, CodingKey {
        case status
        case error
    }
}


extension loginFailResponse:LocalizedError{
    var errorDescription:String?{
        return error
    }
}
