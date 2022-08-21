//
//  FavoriteViewController.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import UIKit

final class FavoriteViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let horisontalInset: CGFloat = 16
        static let spaceBetweenElements: CGFloat = 7
        static let spaceBetweenRows: CGFloat = 8
    }

    // MARK: - Private Properties

    var model: MainModel?

    // MARK: - Views

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Lifeсyrcle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        configureModel()
    }
}


private extension FavoriteViewController {

    func configureApperance() {
        navigationItem.title = "Избранное"
        collectionView.register(UINib(nibName: "\(MainItemCollectionViewCell.self)", bundle: .main),
                                forCellWithReuseIdentifier: "\(MainItemCollectionViewCell.self)")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
    }

    func configureModel() {
        model?.didItemsUpdated = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.favorites.count) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainItemCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? MainItemCollectionViewCell {
            if let model = model {
                let item = model.favorites[indexPath.row]
                cell.title = item.title
                cell.isFavorite = item.isFavorite
                cell.imageUrlInString = item.imageUrlInString
                cell.didFavoritesTapped = { [weak self] in
                    self?.model!.favorites[indexPath.row].isFavorite.toggle()
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
        vc.model = model?.favorites[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}
