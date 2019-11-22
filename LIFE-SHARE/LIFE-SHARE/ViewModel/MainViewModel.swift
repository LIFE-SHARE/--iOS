//
//  MainViewModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {

    private let disposeBag = DisposeBag()

    struct Input {
        let viewDidLoad: Signal<Void>
        let selectedIndex: Driver<IndexPath>
    }

    struct Output {
        let houses: Driver<[HouseData]>
        let houseId: Driver<Int?>
    }

    func transform(input: MainViewModel.Input) -> MainViewModel.Output {
        let api = HouseAPI()
        let previousId = BehaviorRelay<Int>(value: 100)

        let list = input.viewDidLoad.flatMap { (_) -> Driver<[HouseData]> in
            return api.getAllHouse().map { (response) -> [HouseData] in
                guard let houseData = response?.data.house_data else { return [] }
                return houseData
            }.asDriver(onErrorJustReturn: [])
        }

        let selectedId = Observable.combineLatest(input.selectedIndex.asObservable(), list.asObservable()) { (index, data) -> Int? in
            if previousId.value == data[index.row].id { return nil }
            previousId.accept(data[index.row].id)
            return data[index.row].id
        }.asDriver(onErrorJustReturn: nil)

        return Output(houses: list, houseId:selectedId)
    }
}
