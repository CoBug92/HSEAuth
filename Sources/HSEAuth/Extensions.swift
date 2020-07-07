//
//  File.swift
//  
//
//  Created by Alexander Tooszovski on 07.07.2020.
//

import Foundation

extension URLComponents {
    @discardableResult
    func add(key: String, value: String?) -> URLComponents {
        var components = self
        if components.queryItems == nil { components.queryItems = [] }
        components.queryItems!.append(URLQueryItem(name: key, value: value))
        return components
    }
}
