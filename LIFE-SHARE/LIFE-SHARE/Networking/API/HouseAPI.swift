//
//  HouseAPI.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift

class HouseAPI: HouseProvider {

    private let httpClient = HTTPClient()

    func getAllHouse() -> Observable<AllHouse?> {
        return httpClient.get(url: LifeShareURL.allHouse.getPath(),
                              param: nil,
                              header: Header.noToken.getHeader())
            .map { (response, data) -> AllHouse? in
                guard let data = try? JSONDecoder().decode(AllHouse.self, from: data) else { return nil }
                return data
        }
    }

    func getDetailHouse(houseId: Int) -> Observable<DetailHouse?> {
        return httpClient.get(url: LifeShareURL.detailHouse(id: houseId).getPath(),
                              param: nil,
                              header: Header.noToken.getHeader())
            .map { (response, data) -> DetailHouse? in
                guard let data = try? JSONDecoder().decode(DetailHouse.self, from: data) else { return nil }
                return data
        }
    }

    func postVisitApply(houseId: Int, message: String) -> Observable<String?> {
        let param = ["houseId": houseId, "message": message] as [String : Any]

        return httpClient.post(url: LifeShareURL.visitApply.getPath(),
                               param: param,
                               header: Header.token.getHeader())
            .map { (response, data) -> String? in
                guard let data = try? JSONDecoder().decode(LifeShareResponse.self, from: data), data.status == 200 else { return nil }
                print("성공")
                return "성공"
        }
    }
}
