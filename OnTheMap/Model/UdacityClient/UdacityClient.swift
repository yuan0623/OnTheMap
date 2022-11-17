//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/8/22.
//

import Foundation

class UdacityClient{
    static let apiKey = ""
    
    struct Auth{
        static var sessionID = ""
    }
    enum Endpoints{
        case login
        
        var stringValue: String{
            switch self{
            case .login: return "https://onthemap-api.udacity.com/v1/session"
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
