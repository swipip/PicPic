//
//  TodayControllerViewModel.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

protocol TodayControllerViewModelDelegate: AnyObject {
    func todayControllerViewModel(didLoadPictures pictures: [Photo])
    func todayControllerViewModel(didReceiveError error: Error)
}
class TodayControllerViewModel {

    weak var delegate: TodayControllerViewModelDelegate?

    var pictures: [Photo] = []

    func loadPictures() {
        PicturesService.shared.getListOfImages { [weak self] pictures in
            switch pictures {
            case .success(let pictures):
                self?.pictures = pictures
                self?.delegate?.todayControllerViewModel(didLoadPictures: pictures)
            case .failure(let err):
                self?.delegate?.todayControllerViewModel(didReceiveError: err)
            }
        }
    }

    func prefetchPicture(at index: Int) {
        if let url = pictures[index].urls.regular {
            ImageManager.shared.precacheImage(urlString: url)
        }
    }

}
