//
//  DetailControllerLayoutProvider.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class DetailControllerLayoutProvider {
    
    private (set) var largeRowHeight: CGFloat
    private (set) var smallRowHeight: CGFloat
    private (set) var mainGroupHeight: CGFloat
    
    var itemSpacing: CGFloat = 0
    
    private var smallPercentage: CGFloat {
        return smallRowHeight / mainGroupHeight
    }
    
    private var largePercentage: CGFloat {
        return largeRowHeight / mainGroupHeight
    }
    
    init(largeRowHeight: CGFloat, smallRowHeight: CGFloat) {
        self.mainGroupHeight = largeRowHeight + smallRowHeight
        self.largeRowHeight = largeRowHeight
        self.smallRowHeight = smallRowHeight
    }
    
    func layout(from viewController: UIViewController) -> UICollectionViewCompositionalLayout {
        guard let view = viewController.view else {fatalError("You must pass a viewController to compute a layout")}
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
        
        let topGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(largePercentage)), subitem: item, count: 1)
        
        let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(smallPercentage)), subitem: item, count: 2)
        
        let subGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [topGroup,bottomGroup])
        
        let finalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(mainGroupHeight)), subitems: [subGroup])
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(view.frame.height)), subitems: [finalGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: -viewController.safeAreaInsetsWithNavBar.top + itemSpacing, leading: itemSpacing, bottom: 0, trailing: itemSpacing)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}
