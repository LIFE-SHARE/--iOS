//
//  Provider.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift

protocol AuthProvider {
    func postSignin(id: String, pw: String) -> Observable<Signin?>
}

protocol HouseProvider {
    func getAllHouse() -> Observable<AllHouse?>
    func getDetailHouse(houseId: Int) -> Observable<DetailHouse?>
    func postVisitApply(houseId: Int, message: String) -> Observable<String?>
}

protocol WatingListProvider {
    func getWatingList() -> Observable<WatingList?>
}

protocol SearchProvider {
    func postSearch(keyword: String) -> Observable<Search?>
}
