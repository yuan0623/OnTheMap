//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/8/22.
//

import Foundation
import CoreLocation

class UdacityClient{
    static let apiKey = ""
    static var firstName = ""
    static var lastName = ""
    static var userId = ""
    //var studentsLocaiton:getStudentsLocaitonResponse.results
    static var studentsLocaiton: getStudentsLocaitonResponse = getStudentsLocaitonResponse(results: [])
    struct Auth{
        static var sessionID = ""
    }
    enum Endpoints{
        case login
        case logout
        case getStudentLocation(Int)
        case postStudentLocation
        case getUserPublicData(String)
        var stringValue: String{
            switch self{
            case .login: return "https://onthemap-api.udacity.com/v1/session"
            case .logout: return "https://onthemap-api.udacity.com/v1/session"
            case .getStudentLocation(let limit): return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=\(limit)&order=-updatedAt"
            case .postStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case . getUserPublicData(let userId): return "https://onthemap-api.udacity.com/v1/users/\(userId)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username:String,password:String,completion:@escaping (Bool,Error?)->Void){
        var request = URLRequest(url: UdacityClient.Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                DispatchQueue.main.async{
                    completion(false,error)
                }
                return
            }
         
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(loginSucessResponse.self, from: newData)
                Auth.sessionID = responseObject.session.id
                userId = username
                print(responseObject.session.id)
                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
            }
            catch{
                do{
                    let responseObject = try decoder.decode(loginFailResponse.self, from: newData)
                    
                    DispatchQueue.main.async {
                        completion(false,responseObject)
                    }
                    
                }
                catch{
                }
            }
            
            
            //print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    class func logout(completion:@escaping (Bool,Error?)->Void){
        var request = URLRequest(url: UdacityClient.Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
          if error != nil { // Handle error…
              DispatchQueue.main.async{
                  completion(false,error)
              }
              return
          }
        
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
            DispatchQueue.main.async{
                completion(true,nil)
            }
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
        
                                 
    }
    
    class func getUserPublicData(userId:String,completion: @escaping (Bool, Error?) -> Void){
        let request = URLRequest(url: UdacityClient.Endpoints.getUserPublicData(userId).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else{
                DispatchQueue.main.async{
                    completion(false,error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(getUserPublicDataResponse.self, from: newData)
                firstName = responseObject.firstName
                lastName = responseObject.lastName
                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
            }
            catch{
                DispatchQueue.main.async{
                completion(false,error)
                }
            }
            
            //print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func getStudentsLocation(completion: @escaping (getStudentsLocaitonResponse?, Error?) -> Void){
        var request = URLRequest(url: UdacityClient.Endpoints.getStudentLocation(100).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else{
                DispatchQueue.main.async{
                    completion(nil,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(getStudentsLocaitonResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject,nil)
                }
                self.studentsLocaiton = responseObject
            }
            catch{
                print("student location didn't parsed.")
                DispatchQueue.main.async {
                    completion(nil,error)
                }
            }
        }
        task.resume()
        
    }
    
    class func postStudentLocation(mapString:String, mediaURL:String,coordinate:CLLocationCoordinate2D,completion: @escaping (postStudentLocationResponse?, Error?) -> Void){
        
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(UdacityClient.firstName)\", \"lastName\": \"\(UdacityClient.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinate.latitude), \"longitude\": \(coordinate.longitude)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else{
                DispatchQueue.main.async{
                    completion(nil,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(postStudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject,nil)
                }
            }
            catch{
                print("json parse fail")
                DispatchQueue.main.async {
                    completion(nil,error)
                }
            }
            
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //print(String(data: data!, encoding: .utf8))
            guard let data = data else{
                DispatchQueue.main.async{
                    completion(nil,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async{
                    completion(responseObject,nil)
                }
            }
            catch {
                do{
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil,errorResponse)
                    }
                }
                catch{
                    DispatchQueue.main.async{
                        completion(nil,error)
                }
                
                }
            }
        }
        task.resume()
    }
    
}
