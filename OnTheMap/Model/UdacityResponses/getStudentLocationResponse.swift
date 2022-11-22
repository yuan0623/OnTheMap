//
//  getStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/21/22.
//

import Foundation

struct studentLocation:Codable{
    let firstName:String
    let lastName:String
    let longitude:Double
    let latitude:Double
    let mapString:String
    let mediaURL:String
    let uniqueKey:String
    let objectId:String
    let createdAt:String
    let updatedAt:String
}


struct getStudentsLocaitonResponse:Codable{
    let results:[studentLocation]
}
