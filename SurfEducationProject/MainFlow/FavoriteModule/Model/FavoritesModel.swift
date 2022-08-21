//
//  FavoritesModel.swift
//  surf
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import Foundation

final class FavoritesModel: MainModel {
    
    override func loadPosts() {
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
                }.filter { $0.isFavorite }
            case .failure(let error):
                // TODO: - Implement error state there
                break
            }
        }
    }
}
