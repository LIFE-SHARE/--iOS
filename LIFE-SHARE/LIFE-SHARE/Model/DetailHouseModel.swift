//
//  DetailHouseModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

struct DetailHouse: Codable {
    let status: Int
    let message: String
    let data: DetailHouseData
}

struct DetailHouseData: Codable {
    let house_data: HouseData
    let room_data: [RoomData]
}

struct HouseData: Codable {
    let id: Int
    let userId: String
    let name: String
    let address: String
    let genderLimit: String
    let ageLimit: Int
    let maxMember: Int
    let contractperiod: String
    let information: String
    let imageData: String
    let join_date: String
}

struct RoomData: Codable {
    let id: Int
    let house_id: Int
    let peopleCnt: Int
    let money: String
    let imageData: String
}
