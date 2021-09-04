//
//  DetailCell.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class DetailCell: UICollectionViewCell, Reusable {
    static var reuseId = "DetailCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    
    var dataTask: URLSessionDataTask?
    var picturable: Picturable? {
        didSet {
            if let url = picturable?.urls.regular {
                dataTask = ImageManager.shared.loadImage(withUrlString: url, for: imageView)
            }
        }
    }
    
    func getStatistics() {
        statsView.isHidden = false
        if let id = picturable?.id {
            PicturesService.shared.getStatistics(forPictureId: id) { [weak self] stats in
                self?.viewsLabel.text = stats.views.desc
                self?.downloadsLabel.text = stats.downloads.desc
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel()
        statsView.isHidden = true
        imageView.image = nil
    }
}
