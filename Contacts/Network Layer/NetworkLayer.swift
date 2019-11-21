//
//  NetworkLayer.swift
//  Contacts
//
//  Created by Anil Kumar on 20/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case parsingError
    case nullData
}


public enum Method {
    case get
    case post
    case other(method: String)
}

enum NetworkingError: String, LocalizedError {
    case jsonError = "JSON error"
    case other
    var localizedDescription: String { return NSLocalizedString(self.rawValue, comment: "") }
}

extension Method {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
            
        case "GET":
            self = .get
        case "POST":
            self = .post
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
        case .other(let method): return method.uppercased()
        }
    }
}

protocol Requestable {
    
}

extension Requestable {
    

    internal func request<T: Codable>(parameter: T.Type , method: Method, url: String, params: [NSString: Any]? = nil, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completionHandler(.failure(NetworkError.badUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url,  completionHandler: { (data, response, error) in

            DispatchQueue.main.async {
                
                if let error = error {
                    completionHandler(.failure(error))
                    print(error.localizedDescription)
                    
                } else if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 ,let result = try? JSONDecoder().decode(T.self, from: data!) {
                        completionHandler(.success(result))
                    }
                    
                    completionHandler(.failure(NetworkError.parsingError))
                    
                }
            }
        })
        task.resume()
    }
}


struct Requester: Requestable {
    
    
    
}
