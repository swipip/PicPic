//
//  DetailsController.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class DetailsController: UIViewController, Interactive {
    
    // MARK: UI elements 􀯱
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.3)
        button.tintColor = .label
        button.setImage(UIImage(named: "close"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 35/2
        return button
    }()
    
    lazy var layoutProvider = DetailControllerLayoutProvider(
        largeRowHeight: 400,
        smallRowHeight: UIScreen.main.bounds.width / 2)
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: layoutProvider.layout(from: self))
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = dataSource
        collection.prefetchDataSource = self
        collection.registerNib(ofType: DetailCell.self)
        return collection
    }()
    
    var interactorHandler: InteractiveControllerPanHandler!
    weak var interactor: Interactor?
    
    // MARK: Data Management 􀤃
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int,Photo>
    var dataSource: DataSource?
    var viewModel: DetailsControllerViewModel
    
    // MARK: View life cycle 􀐰
    
    init(photo: Photo) {
        viewModel = DetailsControllerViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
        interactorHandler = InteractiveControllerPanHandler(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.backgroundColor = .systemGray6
        
        makeDataSource()
        view.addSubview(pinToEdges: 0, subView: collectionView)
        
        navigationController?.clearNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        viewModel.delegate = self
        viewModel.getUsersPictures()
        
        addPanGesture()
    }

    // MARK: Interactions 􀛹
    
    @objc private func closeButtonPressed() {
        closeButton.animateAlpha(on: false)
        dismiss(animated: true, completion: nil)
    }

    // MARK: UI construction 􀤋
    func addPanGesture() {
        let pan = UIPanGestureRecognizer(
            target: interactorHandler,
            action: #selector(interactorHandler.panHandler(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }
    
}
extension DetailsController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func makeDataSource() {
        dataSource = DataSource(collectionView: collectionView)
        { collectionView, indexPath, picture in
            
            let cell = collectionView.dqReusableCell(ofType: DetailCell.self, for: indexPath)
            cell.picturable = picture
            indexPath.item == 0 ? cell.getStatistics() : ()
            return cell
            
        }
    }
    func applySnapshot(_ pictures: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int,Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(pictures, toSection: 0)
        dataSource?.apply(snapshot)
    }
}
extension DetailsController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({ [weak viewModel] in viewModel?.prefetchPicture(at: $0.item)})
    }
}
extension DetailsController: DetailsControllerViewModelDelegate {
    func detailsControllerViewModel(didReciveError error: Error) {
        AlertMaker(controller: self).displayeNetworkAlert(error.localizedDescription)
        { [weak viewModel] in
            viewModel?.getUsersPictures()
        }
    }
    func detailsControllerViewModel(didLoadPictures pictures: [Photo]) {
        applySnapshot(pictures)
    }
}
extension DetailsController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if collectionView.contentOffset.y < self.safeAreaInsetsWithNavBar.top * 0.8 {
            return true
        } else {
            return false
        }
        
    }
}
