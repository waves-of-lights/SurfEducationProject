//
//  MainModel.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import Foundation
import UIKit

class MainModel {

    // MARK: - Events

    var didItemsUpdated: (() -> Void)?
    var didSelectedItemUpdated: ((IndexPath) -> Void)?

    // MARK: - Properties

    let pictureService = PicturesService()
    var items: [DetailItemModel] = [] {
        didSet {
            let changedIndexes = zip(items, oldValue)
                .map{ $0 != $1 }
                .enumerated()
                .filter{ $1 }
                .map{ $0.0 }

            for index in changedIndexes {
                didSelectedItemUpdated?(
                    IndexPath(row: index, section: 0)
                )
            }
        }
    }
    
    var favorites: [DetailItemModel] {
        
        get {
            return items.filter { $0.isFavorite }
        }
        
        set {
            for f in newValue {
                let index = items.firstIndex { item in item.id == f.id }!
                items[index] = f
            }
        }
    }

    // MARK: - Methods
    
    func filterItems() {
        self.items = self.items.filter { $0.isFavorite }
    }

    func loadPosts() {
        pictureService.loadPictures { [weak self] result in
            switch result {
            case .success(let pictures):
                self?.items = pictures.map { pictureModel in
                    DetailItemModel(
                        id: pictureModel.id,
                        imageUrlInString: pictureModel.photoUrl,
                        title: pictureModel.title,
                        isFavorite: FavoritesStorage.validate(postId: pictureModel.id),
                        content: pictureModel.content,
                        dateCreation: pictureModel.date
                    )
                }
                self?.didItemsUpdated?()
            case .failure(let error):
                // TODO: - Implement error state there
                break
            }
        }
    }
}
