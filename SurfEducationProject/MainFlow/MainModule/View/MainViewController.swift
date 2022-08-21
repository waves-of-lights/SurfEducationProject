//
//  MainViewController.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let horisontalInset: CGFloat = 16
        static let spaceBetweenElements: CGFloat = 7
        static let spaceBetweenRows: CGFloat = 8
    }

    // MARK: - Private Properties

    var model: MainModel?
    
    private var refresher: UIRefreshControl = UIRefreshControl()

    // MARK: - Views

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Lifeсyrcle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        configureModel()
        model?.loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
}

// MARK: - Private Methods

private extension MainViewController {

    func configureApperance() {
        navigationItem.title = "Главная"
        collectionView.register(UINib(nibName: "\(MainItemCollectionViewCell.self)", bundle: .main),
                                forCellWithReuseIdentifier: "\(MainItemCollectionViewCell.self)")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
        
        refresher.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refresher
    }
    
    @objc func refreshData(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.model?.loadPosts()
        }
    }

    func configureModel() {
        model?.didItemsUpdated = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.refresher.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
        model?.didSelectedItemUpdated = { [weak self] index in
            DispatchQueue.main.asyncAfter(deadline: .now() +  2) {
                self?.collectionView.reloadItems(at: [index])
            }
        }
    }

}


// MARK: - UICollection

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.items.count) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainItemCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? MainItemCollectionViewCell {
            if let model = model {
                let item = model.items[indexPath.row]
                cell.title = item.title
                cell.isFavorite = item.isFavorite
                cell.imageUrlInString = item.imageUrlInString
                cell.didFavoritesTapped = { [weak self] in
                    self?.model!.items[indexPath.row].isFavorite.toggle()
                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (view.frame.width - Constants.horisontalInset * 2 - Constants.spaceBetweenElements) / 2
        return CGSize(width: itemWidth, height: 1.46 * itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetweenRows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetweenElements
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.model = model?.items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}
