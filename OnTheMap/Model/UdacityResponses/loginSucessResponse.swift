//
//  loginSucessResponse.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/17/22.
//

import Foundation

struct account:Codable{
    let registered:Bool
    let key:String
}
struct session:Codable{
    let id:String
    let expiration:String
}

struct loginSucessResponse:Codable{
    let account:account
    let session:session
}
