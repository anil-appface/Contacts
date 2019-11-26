//
//  NetworkLayer.swift
//  Contacts
//
//  Created by Anil Kumar on 20/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation

struct GojekError: Codable, Error {
    var errors: [String]?
}

enum NetworkError: Error {
    case badUrl
    case parsingError
    case nullData
}


public enum Method {
    case get
    case post
    case put
    case delete
    case other(method: String)
}


extension Method {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
            
        case "GET":
            self = .get
        case "POST":
            self = .post
        case "PUT":
            self = .put
        case "DELETE":
            self = .delete
        default:
            self = .other(method: method)
        }
    }
}

extension Method: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:               return "GET"
        case .post:              return "POST"
        case .put:              return "PUT"
        case .delete:              return "DELETE"
        case .other(let method): return method.uppercased()
        }
    }
}

protocol Requestable {
    
}

extension Requestable {
    
    
    internal func request<T: Codable>(parameter: T.Type , method: Method, url: String, httpBody: Data? = nil, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completionHandler(.failure(NetworkError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.description
        request.httpBody = httpBody        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request,  completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    completionHandler(.failure(error))
                    print(error.localizedDescription)
                    
                } else if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 ,let result = try? JSONDecoder().decode(T.self, from: data!) {
                        completionHandler(.success(result))
                    }
                    else if let result = try? JSONDecoder().decode(GojekError.self, from: data!){
                        completionHandler(.failure(result))
                    }
                    else {
                        completionHandler(.failure(NetworkError.parsingError))
                    }
                }
            }
        })
        task.resume()
    }
}


struct Requester: Requestable {
    
    
    
}
