//
//  Session.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/20.
//

import Foundation

enum SessionError: Error {
    case noData(HTTPURLResponse)
    case noResponse
    case unacceptableStatusCode(Int, String)
    case failedToCreateComponents(URL)
    case failedToCreateURL(URLComponents)
}

final class Session {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    @discardableResult
    func send<T: Request>(_ request: T) async throws -> (T.Response, Pagination) {
        let url = request.baseURL
        
        guard var componets = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw SessionError.failedToCreateComponents(url)
        }
        componets.queryItems = request.queryParameters?.compactMap(URLQueryItem.init)
        
        guard var urlRequest = componets.url.map({ URLRequest(url: $0) }) else {
            throw SessionError.failedToCreateURL(componets)
        }
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headerFields
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw SessionError.noResponse
        }
        
        guard  200..<300 ~= response.statusCode else {
            throw SessionError.unacceptableStatusCode(response.statusCode, response.debugDescription)
        }
        
        let pagination: Pagination
        if let page = request.queryParameters?["page"] {
            let next = Int(page)! + 1
            pagination = Pagination(next: next)
        } else {
            pagination = Pagination(next: nil)
        }
        
        do {
            let object = try JSONDecoder().decode(T.Response.self, from: data)
            return (object, pagination)
        } catch {
            throw error
        }
    }
}
