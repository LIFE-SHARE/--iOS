//
//  AllHouseModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

struct AllHouse: Codable {
    let status: Int
    let message: String
    let data: AllHouseData
}

struct AllHouseData: Codable {
    let house_data: [HouseData]
}
