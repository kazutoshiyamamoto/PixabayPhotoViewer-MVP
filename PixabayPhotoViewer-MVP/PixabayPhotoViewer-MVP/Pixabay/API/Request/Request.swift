//
//  Request.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/20.
//

import Foundation

protocol Request {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var method: HttpMethod { get }
    var key: String { get }
    var headerFields: [String: String] { get }
    var queryParameters: [String: String]? { get }
}

extension Request {
    var baseURL: URL {
        return URL(string: "https://pixabay.com/api/")!
    }
    
    var key: String {
        return ""
    }
    
    var headerFields: [String: String] {
        return ["Accept": "application/json"]
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
