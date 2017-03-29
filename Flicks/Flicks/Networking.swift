//
//  Networking.swift
//  Flicks
//
//  Created by Akshay Bhandary on 3/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class Networking {
    
    static func get(url : URL, success :  @escaping (Data)->Void, failure : @escaping (Error?)->Void) {
        let urlRequest = URLRequest(url: url);
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        
        let task = session.dataTask(with: urlRequest) { (data : Data?, response : URLResponse?, error : Error?) in
            if data == nil || error != nil {
                failure(error);
            } else {
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    failure(error);
                } else {
                    success(data!);
                }
            }
        }
        task.resume();
    }
}
