//
//  WatingListViewModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class WatingListViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: Signal<Void>
        let selectedIndex: Driver<IndexPath>
    }

    struct Output {
        let houses: Driver<[HouseData]>
        let houseId: Driver<Int?>
    }

    func transform(input: WatingListViewModel.Input) -> WatingListViewModel.Output {
        let api = WatingListAPI()
        let previousId = BehaviorRelay<Int>(value: 100)

        let list = input.viewDidLoad.asObservable().flatMap { (area) -> Observable<[HouseData]> in
            return api.getWatingList().map { (response) -> [HouseData] in
                guard let houseData = response?.data.resultList else { return [] }
                return houseData
            }
        }.asDriver(onErrorJustReturn: [])

        let selectedId = Observable.combineLatest(input.selectedIndex.asObservable(), list.asObservable()) { (index, data) -> Int? in
            if previousId.value == data[index.row].id { return nil }
            previousId.accept(data[index.row].id)
            return data[index.row].id
        }.asDriver(onErrorJustReturn: 0)

        return Output(houses: list, houseId: selectedId)
    }
}
