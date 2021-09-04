//
//  TodayController.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class TodayController: UIViewController {

    // MARK: UI elements 􀯱
    
    var margin: CGFloat = 24
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = margin
        let collection = UICollectionView(frame: .zero ,collectionViewLayout: layout)
        collection.registerNib(ofType: TodayCell.self)
        collection.registerHeaderNib(ofType: TodayHeader.self)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.prefetchDataSource = self
        collection.contentInset = .all(margin)
        return collection
    }()
    var transitionDelegate = DetailsAnimator()
    var interactor = Interactor()
    
    // MARK: Data Management 􀤃
    
    var viewModel = TodayControllerViewModel()
    
    // MARK: View life cycle 􀐰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(pinToEdges: 0, subView: collectionView)
        
        viewModel.delegate = self
        viewModel.loadPictures()
        
    }
    
    // MARK: Navigation 􀋒
    
    func presentDetailController(withCell cell: TodayCell) {
        guard let photo = cell.photo else {return}
        let vc = DetailsController(photo: photo)
        vc.interactor = interactor
        transitionDelegate.todayCell = cell
        let nav = vc.embedInNav()
        nav.modalPresentationStyle = .custom
        nav.transitioningDelegate = self
        self.present(nav, animated: true, completion: nil)
    }

}
// MARK: Collection view transition
extension TodayController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pictures.count
    }
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dqReusableCell(ofType: TodayCell.self, for: indexPath)
        cell.photo = viewModel.pictures[indexPath.item]
        return cell
        
    }
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dqHeader(ofType: TodayHeader.self, for: indexPath)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - margin * 2,
                      height: collectionView.frame.height * 0.6)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - margin * 2,
                      height: 100)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TodayCell {
            presentDetailController(withCell: cell)
        }
    }
}
// MARK: Navigation controller delegation
extension TodayController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionDelegate.action = .dismiss
        transitionDelegate.duration = 0.3
        return transitionDelegate
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionDelegate.action = .present
        transitionDelegate.duration = 0.8
        return transitionDelegate
        
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : nil
    }
}
extension TodayController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({ [weak viewModel] in viewModel?.prefetchPicture(at: $0.item)})
    }
}
extension TodayController: TodayControllerViewModelDelegate {
    func todayControllerViewModel(didReceiveError error: Error) {
        AlertMaker(controller: self).displayeNetworkAlert(error.localizedDescription)
        { [weak viewModel] in
            viewModel?.loadPictures()
        }
    }
    
    func todayControllerViewModel(didLoadPictures pictures: [Photo]) {
        collectionView.reloadData()
    }
}
