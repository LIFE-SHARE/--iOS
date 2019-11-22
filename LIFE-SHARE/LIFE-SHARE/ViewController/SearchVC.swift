//
//  SearchVC.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 2019/11/21.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SearchVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var refreshBtn: HeightRoundButton!

    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()

    let searhTaps = BehaviorRelay<Void>(value: ())
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfigure()
        setUpUI()
        viewModelBinding()
    }

    private func setUpUI() {
        refreshBtn.rx.tap.asDriver().drive(onNext: { (_) in
            self.searhTaps.accept(())
        }).disposed(by: disposeBag)
    }

    private func viewModelBinding() {
        let input = SearchViewModel.Input(keyword: searchBar.searchTextField.rx.text.orEmpty.asDriver(),
                                          searchTaps: searhTaps.asSignal(onErrorJustReturn: ()), selectedIndex: collectionView.rx.itemSelected.asDriver())
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

extension SearchVC: UISearchBarDelegate {
    private func searchBarConfigure() {
        searchBar.placeholder = "위치검색 ex)어쩌구"
        searchBar.delegate = self
        definesPresentationContext = true
        let searchBarWrapper = SearchBarContainerView(customSearchBar: searchBar)
        searchBarWrapper.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarWrapper
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searhTaps.accept(())
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searhTaps.accept(())
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

class SearchBarContainerView: UIView {
    let searchBar: UISearchBar
    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        addSubview(searchBar)
    }

    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
