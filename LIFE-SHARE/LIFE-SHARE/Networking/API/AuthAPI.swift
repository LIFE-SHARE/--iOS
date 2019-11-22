//
//  AuthAPI.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift

class AuthAPI: AuthProvider {
    private let httpClient = HTTPClient()

    func postSignin(id: String, pw: String) -> Observable<Signin?> {
        let param = ["id": id, "pw": pw]
        return httpClient.post(url: LifeShareURL.signin.getPath(),
                               param: param,
                               header: Header.noToken.getHeader())
            .map { (response, data) -> Signin? in
                guard let data = try? JSONDecoder().decode(Signin.self, from: data) else { return nil }
                return data
        }
    }

    
}
