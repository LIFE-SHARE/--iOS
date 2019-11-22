//
//  MainVC.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

class MainVC: UIViewController {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    let mainviewdidLoad = BehaviorRelay<Void>(value: ())

    override func viewDidLoad() {
        super.viewDidLoad()
        loginCheck()
        setUpUI()
        viewModelBinding()
    }

    private func setUpUI() {
        if let name = Token.name {
            userNameLbl.text = name + "님!"
        }
        configureNavigationBarTitleView()
    }
    
    private func loginCheck() {
        if Token.token == nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }

    private func viewModelBinding() {
        mainviewdidLoad.accept(())
        let input = MainViewModel.Input(viewDidLoad: mainviewdidLoad.asSignal(onErrorJustReturn: ()),
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

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var subTitleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(img: String, title: String, subTitle: String) {
        titleLbl.text = title
        subTitleLbl.text = subTitle
        let img = LifeShareURL.baseUrl.getPath() + "/" + img
        let url = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        imgView.kf.setImage(with: URL(string: url))
    }

}
