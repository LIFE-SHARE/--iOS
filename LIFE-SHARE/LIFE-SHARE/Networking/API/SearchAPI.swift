//
//  SearchAPI.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift

class SearchAPI: SearchProvider {

    private let httpClient = HTTPClient()

    func postSearch(keyword: String) -> Observable<Search?> {
        let param = ["keyword": keyword]
        return httpClient.post(url: LifeShareURL.search.getPath(),
                              param: param,
                              header: Header.noToken.getHeader())
            .map { (response, data) -> Search? in
                print(response)
                print(data)
                guard let data = try? JSONDecoder().decode(Search.self, from: data) else { return nil }
                return data
        }
    }
}

