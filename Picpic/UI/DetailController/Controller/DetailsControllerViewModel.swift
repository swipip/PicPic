//
//  DetailsControllerViewModel.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

protocol DetailsControllerViewModelDelegate: AnyObject {
    func detailsControllerViewModel(didLoadPictures pictures: [Photo])
    func detailsControllerViewModel(didReciveError error: Error)
}
class DetailsControllerViewModel {
    weak var delegate: DetailsControllerViewModelDelegate?
    
    var originPhoto: Photo
    var userName: String
    private (set) var pictures: [Photo] = []
    
    init(photo: Photo) {
        self.originPhoto = photo
        self.userName = photo.user.username
    }
    
    func getUsersPictures() {
        
        PicturesService.shared.getUsersPictures(userName: userName) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let pictures):
                self.pictures = self.updatePictures(withNew: pictures)
                self.delegate?.detailsControllerViewModel(didLoadPictures: self.pictures)
            case .failure(let err):
                self.delegate?.detailsControllerViewModel(didReciveError: err)
            }
            
        }
    }
    
    func prefetchPicture(at index: Int) {
        if let url = pictures[index].urls.regular {
            ImageManager.shared.precacheImage(urlString: url)
        }
    }
    
    private func updatePictures(withNew pictures: [Photo]) -> [Photo] {
        var pictures = pictures
        pictures = pictures.filter({$0.id != self.originPhoto.id})
        pictures.insert(self.originPhoto, at: 0)
        return pictures
    }
}
