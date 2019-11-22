//
//  SigninViewModel.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/10/25.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class SigninViewModel: ViewModelType {
    struct Input {
        let SigninTaps: Signal<Void>
        let id: Driver<String>
        let pw: Driver<String>
    }
    
    struct Output {
        let result: Driver<Member?>
    }
    
    func transform(input: SigninViewModel.Input) -> SigninViewModel.Output {
        let api = AuthAPI()
        let info = Driver.combineLatest(input.id, input.pw)
        
        let result = input.SigninTaps.withLatestFrom(info).flatMap { (id, pw) -> Driver<Member?> in
            return api.postSignin(id: id, pw: pw).map { (result) -> Member? in
                guard let result = result else { return nil }
                Token.token = result.data.token
                Token.name = result.data.member.name
                return result.data.member
            }.asDriver(onErrorJustReturn: nil)
        }
        
        return Output(result: result)
    }
    
    
}
