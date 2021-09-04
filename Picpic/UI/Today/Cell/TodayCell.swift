//
//  TodayCell.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class TodayCell: UICollectionViewCell, Reusable {
    static var reuseId = "TodayCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    var photo: Photo? {
        didSet {
            if let url = photo?.urls.regular {
                ImageManager.shared.loadImage(withUrlString: url, for: imageView)
            }
            if let url = photo?.user.profile_image.large {
                ImageManager.shared.loadImage(withUrlString: url, for: userImageView)
            }
            userNameLabel.text = photo?.user.username
            likesLabel.text = photo?.likesString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 24

        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = UIColor.white.cgColor
        
        shadow(
            color: .black,
            opacity: 0.15,
            radius: 20,
            offset: .init(width: 0, height: 5))
    }
}
