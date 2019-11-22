//
//  SigninVC.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SigninVC: UIViewController {

    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    @IBOutlet weak var idUnderlineView: UIView!
    @IBOutlet weak var pwUnderlineView: UIView!
    @IBOutlet weak var doneBtn: HeightRoundButton!

    private let disposeBag = DisposeBag()
    private let viewModel = SigninViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModelBinding()
    }

    private func setUpUI() {
        idTxtField.configureIrisEffect(underlineView: idUnderlineView, disposeBag: disposeBag)
        pwTxtField.configureIrisEffect(underlineView: pwUnderlineView, disposeBag: disposeBag)
    }

    private func viewModelBinding() {
        let input = SigninViewModel.Input(SigninTaps: doneBtn.rx.tap.asSignal(),
                                          id: idTxtField.rx.text.orEmpty.asDriver(),
                                          pw: pwTxtField.rx.text.orEmpty.asDriver())
        let output = viewModel.transform(input: input)

        output.result.debug().drive(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            if response != nil {
                guard let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "MainTBC") else { return }
                vc.modalPresentationStyle = .fullScreen
                strongSelf.present(vc, animated: false, completion: nil)
            } else {
                strongSelf.showToast(message: "로그인 실패")
            }
        }).disposed(by: disposeBag)
    }

}
