//
//  AuthModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

struct Signin: Codable {
    let status: Int
    let message: String
    let data: SigninData
}

struct SigninData: Codable {
    let token: String
    let member: Member
}

struct Member: Codable {
    let id: String
    let name: String
    let phone_number: String
    let gender: Int
    let age: Int
    let auth: Int
    let join_date: String
    let email: String
}
