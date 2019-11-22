//
//  ApplyModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

struct WatingList: Codable {
    let status: Int
    let message: String
    let data: WatingListData
}

struct WatingListData: Codable {
    let resultList: [HouseData]
}

struct LifeShareResponse: Codable {
    let status: Int
    let message: String
}
