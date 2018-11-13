//
//  BaseService.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//

import Foundation

class BaseServiceLocalFile {
    
    /**
     Creates a method for fetching feed data from the bundled json file in the JSON format.
     
     - Parameter
     
     - Throws:
     
     - Returns: JSON Object with key value pairs
     */
    
    func getDataFromJsonFile(completion: @escaping (ServiceResponse) -> Void){
        if let filepath = Bundle.main.path(forResource: "jsonResponse", ofType: "txt") {
            do {
                var json: Any?
                let jsonContents = try String(contentsOfFile: filepath)
                if let data = jsonContents.data(using: String.Encoding.utf8) {
                    do {
                        
                        json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                    } catch {
                        completion(.failure)
                        return
                    }
                }
                
                guard let result = json as? JsonDictionay else {
                     completion(.failure)
                    return
                }
                completion(.success(response: result))
                
            } catch {
                // contents could not be loaded
                completion(.failure)
            }
        } else {
            // jsonResponse.txt not found!
            completion(.fileNotExist)
        }
    }
}
