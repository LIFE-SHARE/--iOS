//
//  SearchViewModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {

    struct Input {
        let keyword: Driver<String>
        let searchTaps: Signal<Void>
        let selectedIndex: Driver<IndexPath>
    }

    struct Output {
        let houses: Driver<[HouseData]>
        let houseId: Driver<Int?>
    }

    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output {
        let api = SearchAPI()
        let previousId = BehaviorRelay<Int>(value: 100)

        let list = input.searchTaps.withLatestFrom(input.keyword).flatMap { (searchKeyword) -> Driver<[HouseData]> in
            return api.postSearch(keyword: searchKeyword).map { (response) -> [HouseData] in
                guard let response = response else { return [] }
                return response.data.house_data
            }.asDriver(onErrorJustReturn: [])
        }

        let selectedId = Observable.combineLatest(input.selectedIndex.asObservable(), list.asObservable()) { (index, data) -> Int? in
            if previousId.value == data[index.row].id { return nil }
            previousId.accept(data[index.row].id)
            return data[index.row].id
        }.asDriver(onErrorJustReturn: 0)

        return Output(houses: list.asDriver(), houseId: selectedId)
    }
}
