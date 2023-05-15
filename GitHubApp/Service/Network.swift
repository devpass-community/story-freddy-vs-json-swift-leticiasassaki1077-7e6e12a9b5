//
//  Network.swift
//  GitHubApp
//
//  Created by Rodrigo Soares on 31/01/23.
//

import Foundation

protocol NetworkProtocol {
 
    func performGet(url: URL, completion: @escaping (Data?)->Void)
}

struct Network: NetworkProtocol {
    
    func performGet(url: URL, completion: @escaping (Data?)->Void) {
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            completion(data)
        }
        
        dataTask.resume()
    }
}
