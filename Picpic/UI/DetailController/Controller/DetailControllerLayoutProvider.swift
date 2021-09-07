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

        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)

        let topGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(largePercentage))
        let topGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: topGroupSize, subitem: item, count: 1)

        let bottomGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(smallPercentage))
        let bottomGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: bottomGroupSize, subitem: item, count: 2)

        let subGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let subGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: subGroupSize, subitems: [topGroup, bottomGroup])

        let finalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(mainGroupHeight))
        let finalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: finalGroupSize, subitems: [subGroup])

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(view.frame.height))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [finalGroup])

        let section = NSCollectionLayoutSection(group: group)

        let sectionContentInsets = NSDirectionalEdgeInsets(
            top: -viewController.safeAreaInsetsWithNavBar.top + itemSpacing,
            leading: itemSpacing,
            bottom: 0,
            trailing: itemSpacing)
        section.contentInsets = sectionContentInsets

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

}
