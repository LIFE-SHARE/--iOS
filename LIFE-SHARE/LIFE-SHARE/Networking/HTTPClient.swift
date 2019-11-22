//
//  HTTPClient.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxAlamofire
import Alamofire

class HTTPClient {
    typealias param = [String: Any]?

    func get(url: String, param: param, header: [String: String]) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.get,
                           url,
                           parameters: param,
                           encoding: URLEncoding.default,
                           headers: header)
    }

    func queryGet(url: String, param: param, header: [String: String]) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.get,
                           url,
                           parameters: param,
                           encoding: URLEncoding.queryString,
                           headers: header)
    }

    func post(url: String, param: param, header: [String: String]) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.post,
                           url,
                           parameters: param,
                           encoding: URLEncoding.default,
                           headers: header)
    }

}

enum Header {
    case token, noToken

    func getHeader() -> [String: String] {
        switch self {
        case .token:
            guard let token = Token.token else { return [:] }
            return ["x-access-token": token]
        case .noToken:
            return [:]
        }
    }
}

struct Token {
    static var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "Token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Token")
        }
    }

    static var name: String? {
        get {
            return UserDefaults.standard.string(forKey: "Name")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Name")
        }
    }
}
