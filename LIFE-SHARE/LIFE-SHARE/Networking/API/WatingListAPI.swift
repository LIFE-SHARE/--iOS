//
//  WatingListAPI.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift

class WatingListAPI: WatingListProvider {

    private let httpClient = HTTPClient()

    func getWatingList() -> Observable<WatingList?> {
        return httpClient.get(url: LifeShareURL.watingList.getPath(),
                              param: nil,
                              header: Header.token.getHeader())
            .map { (response, data) -> WatingList? in
                guard let data = try? JSONDecoder().decode(WatingList.self, from: data) else { return nil }
                return data
        }
    }
}

