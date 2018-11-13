//
//  BaseService.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//

import Foundation
import Alamofire

typealias JsonDictionay = [String : Any]

enum ServiceResponse {
    case success(response: JsonDictionay)
    case failure
    case notConnectedToInternet
    case fileNotExist
}

enum ResponseStatusCode: Int {
    case success = 200
}

class BaseService {
    
    var dataRequestArray: [DataRequest] = []
    var sessionManager: [String : Alamofire.SessionManager] = [:]
    
    /**
     Creates a method for fetching feeds data from the server in JSON format.
     
     - Parameter recipient: 
     
     - Throws: Getting error when user don't allow to add ATS in info.plist or some server error
     
     - Returns: JSON Object with key value pairs
     */
    
    func callEndPoint(method: Alamofire.HTTPMethod = .get, headers: [String:String]? = [:], params: JsonDictionay? = [:], completion: @escaping (ServiceResponse) -> Void){
        
        let url = ProductEndPoint.baseUrl
        
        switch method {
        case .post:
            _ = request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
                self.serializeResponse(response: response, completion: completion)
                self.sessionManager.removeValue(forKey: url)
            }
        default:
            _ = request(url, method: method, parameters: params, headers: headers).responseString { (response) in
                self.serializeResponse(response: response, completion: completion)
                self.sessionManager.removeValue(forKey: url)
            }
        }
    }
    
    func serializeResponse(response: Alamofire.DataResponse<String>,  completion: @escaping (ServiceResponse) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let strongSelf = self else { return }
            
            var json: Any?
            guard let urlResponse = response.response else {
                if let error = response.result.error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
                    strongSelf.notConnectedToInternet(completion: completion)
                } else {
                    strongSelf.failure(completion: completion)
                }
                return
            }
            
            if let data = response.result.value?.data(using: String.Encoding.utf8) {
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                } catch {
                    strongSelf.failure(completion: completion)
                    return
                }
            }
            
            guard let jsonResponse = json as? JsonDictionay else {
                strongSelf.failure(completion: completion)
                return
            }
            
            if jsonResponse["success"] as? Bool == false {
                strongSelf.failure(completion: completion)
                return
            }
            
            strongSelf.success(result:jsonResponse , headers: urlResponse.allHeaderFields, completion: completion)
        }
    }
    /**
     Creates a method for calcel the running process and remove all saved data in the  array.
     
     - Parameter recipient:
     
     - Throws:
     
     - Returns:
     */
    func cancelAllRequests () {
        for dataRequest in self.dataRequestArray {
            dataRequest.cancel()
        }
        self.dataRequestArray.removeAll()
    }
    
    func notConnectedToInternet (completion:@escaping (ServiceResponse) -> Void) {
        completion(.notConnectedToInternet)
    }
    
    func failure (completion:@escaping (ServiceResponse) -> Void) {
        completion(.failure)
    }
    
    func success (result: JsonDictionay?, headers: [AnyHashable: Any], completion:@escaping (ServiceResponse) -> Void) {
        completion(.success(response: result!))
    }
}
