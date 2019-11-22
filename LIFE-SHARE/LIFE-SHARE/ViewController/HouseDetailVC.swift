//
//  HouseDetailVC.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HouseDetailVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var genderLimit: UILabel!
    @IBOutlet weak var ageLimit: UILabel!
    @IBOutlet weak var contractPeriod: UILabel!
    @IBOutlet weak var maxMember: UILabel!
    @IBOutlet weak var informationTxtView: UITextView!
    @IBOutlet weak var roomCollectionView: UICollectionView!
    @IBOutlet weak var applyBtn: UIButton!

    private let disposeBag = DisposeBag()
    private let viewModel = HouseDetailViewModel()

    let message = PublishRelay<String>()
    let houseId = BehaviorRelay<Int>(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModelBinding()
    }

    private func setUpUI() {
        navigationController?.navigationBar.isHidden = false
        applyBtn.rx.tap.asSignal().emit(onNext: { (_) in
            let alert = UIAlertController(title: "방문신청하기", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "신청하기", style: .default) { (ok) in
                if let txt = alert.textFields![0].text, txt != " " {
                    self.message.accept(txt)
                }
            }
            let cancel = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)

            alert.addTextField { (textField) in
                textField.placeholder = "집주인에게 보낼 간단한 메시지를 작성해주세요"
            }

            self.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    private func viewModelBinding() {
        let input = HouseDetailViewModel.Input(houseId: houseId.asDriver(), message: message.asDriver(onErrorJustReturn: "실패"))
        let output = viewModel.transform(input: input)

        output.imageData.drive(onNext: { [weak self] (img) in
            guard let strongSelf = self else { return }
            strongSelf.imgView.kf.setImage(with: URL(string: img))
        }).disposed(by: disposeBag)

        output.name.drive(onNext: { (name) in
            self.navigationItem.title = name
        }).disposed(by: disposeBag)
        output.address.drive(address.rx.text).disposed(by: disposeBag)
        output.genderLimit.drive(genderLimit.rx.text).disposed(by: disposeBag)
        output.ageLimit.drive(ageLimit.rx.text).disposed(by: disposeBag)
        output.contractPeriod.drive(contractPeriod.rx.text).disposed(by: disposeBag)
        output.maxMember.drive(maxMember.rx.text).disposed(by: disposeBag)
        output.information.drive(informationTxtView.rx.text).disposed(by: disposeBag)

        output.rooms.drive(roomCollectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { (_, data, cell) in
            cell.configure(img: data.imageData, title: "\(data.peopleCnt)인실", subTitle: data.money)
        }.disposed(by: disposeBag)

        output.result.drive(onNext: { (message) in
            self.showToast(message: message)
        }).disposed(by: disposeBag)
    }

}
