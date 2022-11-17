//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/8/22.
//

import Foundation

struct UdacityResponse:Codable{
    let statusCode:Int
    let statusMessage:String
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension UdacityResponse:LocalizedError{
    var errorDescription:String?{
        return statusMessage
    }
}

