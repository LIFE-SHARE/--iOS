//
//  HouseDetailViewModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class HouseDetailViewModel: ViewModelType {

    private let disposeBag = DisposeBag()

    struct Input {
        let houseId: Driver<Int>
        let message: Driver<String>
    }

    struct Output {
        let name: Driver<String>
        let address: Driver<String>
        let genderLimit: Driver<String>
        let ageLimit: Driver<String>
        let maxMember: Driver<String>
        let contractPeriod: Driver<String>
        let information: Driver<String>
        let imageData: Driver<String>
        let rooms: Driver<[RoomData]>
        let result: Driver<String>
    }

    func transform(input: HouseDetailViewModel.Input) -> HouseDetailViewModel.Output {
        let api = HouseAPI()
        let name = BehaviorRelay<String>(value: "")
        let address = BehaviorRelay<String>(value: "")
        let genderLimit = BehaviorRelay<String>(value: "")
        let ageLimit = BehaviorRelay<String>(value: "")
        let maxMember = BehaviorRelay<String>(value: "")
        let contractPeriod = BehaviorRelay<String>(value: "")
        let information = BehaviorRelay<String>(value: "")
        let imageData = BehaviorRelay<String>(value: "")
        let rooms = BehaviorRelay<[RoomData]>(value: [])
        let previousId = BehaviorRelay<Int>(value: 0)

        let result = Driver.combineLatest(input.houseId, input.message) { ($0, $1) }
            .asObservable().flatMap { (id, message) -> Driver<String> in
                if message.isEmpty && previousId.value == id { return Driver.of("") }
                return api.postVisitApply(houseId: id, message: message).map { (code) -> String in
                    if code == "성공" {
                        previousId.accept(id)
                        return code!
                    }
                    return "실패"
                }.asDriver(onErrorJustReturn: "실패")
        }

        input.houseId.asObservable().subscribe(onNext: { [weak self] (id) in
            guard let strongSelf = self else { return }
            api.getDetailHouse(houseId: id).asObservable().subscribe(onNext: { (response) in
                guard let data = response else { return }
                name.accept(data.data.house_data.name)
                address.accept(data.data.house_data.address)
                genderLimit.accept(data.data.house_data.genderLimit)
                ageLimit.accept("최소 \(data.data.house_data.ageLimit)세")
                maxMember.accept("\(data.data.house_data.maxMember)명")
                contractPeriod.accept(data.data.house_data.contractperiod)
                information.accept(data.data.house_data.information)
                imageData.accept(LifeShareURL.baseUrl.getPath() + "/" + data.data.house_data.imageData)
                rooms.accept(data.data.room_data)
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)

        return Output(name: name.asDriver(),
                      address: address.asDriver(),
                      genderLimit: genderLimit.asDriver(),
                      ageLimit: ageLimit.asDriver(),
                      maxMember: maxMember.asDriver(),
                      contractPeriod: contractPeriod.asDriver(),
                      information: information.asDriver(),
                      imageData: imageData.asDriver(),
                      rooms: rooms.asDriver(),
                      result: result.asDriver(onErrorJustReturn: "실패"))
    }
}
