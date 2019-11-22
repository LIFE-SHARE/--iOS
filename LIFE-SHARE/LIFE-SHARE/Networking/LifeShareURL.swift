//
//  LifeShareURL.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

enum LifeShareURL {
    case signin
    case allHouse
    case detailHouse(id: Int)
    case visitApply
    case search
    case watingList
    case baseUrl

    func getPath() -> String {
        let baseURL = "http://192.168.1.12:8000"
        switch self {
        case .signin:
            return baseURL + "/auth/login"
        case .allHouse:
            return baseURL + "/house"
        case .detailHouse(let id):
            return baseURL + "/house/?houseId=\(id)"
        case .visitApply:
            return baseURL + "/house/apply"
        case .search:
            return baseURL + "/search"
        case .watingList:
            return baseURL + "/house/apply/getWaitApply"
        case .baseUrl:
            return baseURL
        }
    }
}
