//
//  WatingListVC.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class WatingListVC: UIViewController {
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    let disposeBag = DisposeBag()
    let viewModel = WatingListViewModel()
    private let watingListviewdidLoad = PublishRelay<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModelBinding()
        configureNavigationBarTitleView()
    }

    override func viewDidAppear(_ animated: Bool) {
        watingListviewdidLoad.accept(())
    }

    private func setUpUI() {
        logoutBtn.rx.tap.asSignal().emit(onNext: { (_) in
            Token.token = nil
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }).disposed(by: disposeBag)

        configureNavigationBarTitleView()
    }

    private func viewModelBinding() {
        let input = WatingListViewModel.Input(viewDidLoad: watingListviewdidLoad.asSignal(onErrorJustReturn: ()),
                                        selectedIndex: collectionView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)

        output.houses.drive(collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { (_, data, cell) in
            cell.configure(img: data.imageData, title: data.name, subTitle: data.address)
        }.disposed(by: disposeBag)

        output.houseId.drive(onNext: { [weak self] (id) in
            guard let strongSelf = self, let id = id else { return }
            let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HouseDetailVC") as! HouseDetailVC
            vc.houseId.accept(id)
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
}
