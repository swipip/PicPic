//
//  DetailsAnimator.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class DetailsAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var action: Action = .present
    var duration: TimeInterval = 1.4
    var todayCell: TodayCell?

    enum Action {
        case present, dismiss
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        switch action {
        case .present:

            guard let toVc = (transitionContext.viewController(forKey: .to) as? UINavigationController)?.viewControllers.first as? DetailsController else {return}
            guard let toView = transitionContext.viewController(forKey: .to)?.view else {fatalError()}
            let tabBarController = (transitionContext.viewController(forKey: .from) as? TabBarController)
            guard let fromVC = tabBarController?.viewControllers?.first as? TodayController else {fatalError()}

            tabBarController?.animateTabBar(on: false)

            guard let cell = todayCell else {return}
            cell.imageView.isHidden = true
            let cellFrame = getCellFrame(cell)
            let imageView = UIImageView(frame: cellFrame)
            imageView.image = cell.imageView.image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 24
            imageView.layer.cornerCurve = .continuous

            let finalFrame = toVc.finalFrame

            toView.alpha = 0
            toView.frame = finalFrame
            containerView.addSubview(toView)
            containerView.addSubview(imageView)

            UIView.animate(withDuration: duration * 0.1, delay: 0, options: .curveEaseInOut) {
                imageView.transform = .init(scaleX: 0.98, y: 0.98)
                cell.userImageView.alpha = 0
            } completion: { ended in
                UIView.animate(withDuration: self.duration * 0.9, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseIn) {
                    fromVC.collectionView.alpha = 0

                    toView.alpha = 1
                    toView.frame = UIScreen.main.bounds

                    imageView.transform = .identity
                    imageView.frame = finalFrame
                    imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                } completion: { ended in
                    imageView.animateAlpha(on: false) {
                        imageView.removeFromSuperview()
                    }
                    fromVC.collectionView.alpha = 1
                    cell.imageView.isHidden = false
                    transitionContext.completeTransition(ended)
                }

            }

        case .dismiss:

            guard let fromVc = (transitionContext.viewController(forKey: .from) as? UINavigationController) else {return}

            let detailsController = fromVc.viewControllers.first as? DetailsController
            let imageViewHeight = detailsController?.layoutProvider.largeRowHeight ?? 0

            let tabBarController = (transitionContext.viewController(forKey: .to) as? TabBarController)
            tabBarController?.animateTabBar(on: true)

            let margin = detailsController?.layoutProvider.itemSpacing ?? 0

            guard let cell = todayCell else {return}
            cell.imageView.isHidden = true
            let cellFrame = getCellFrame(cell)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - margin * 2, height: imageViewHeight))
            imageView.image = cell.imageView.image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerCurve = .continuous
            imageView.backgroundColor = .systemPink

            containerView.addSubview(imageView)

            UIView.animate(withDuration: duration * 0.2) {
                fromVc.view?.alpha = 0
                fromVc.view.transform = .init(scaleX: 0.5, y: 0.5)
                fromVc.view.layer.cornerRadius = 24
            }

            UIView.animate(withDuration: duration) {
                imageView.layer.cornerRadius = 24
                imageView.frame = cellFrame
                cell.userImageView.alpha = 1

            } completion: { _ in

                if transitionContext.transitionWasCancelled {
                    fromVc.view?.alpha = 1
                    fromVc.view.transform = .identity
                } else {
                    cell.imageView.isHidden = false
                    fromVc.view.removeFromSuperview()
                }

                imageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }

        }

    }

    func getCellFrame(_ cell: UICollectionViewCell) -> CGRect {
        let origin = cell.convert(UIScreen.main.bounds, to: nil).origin
        return .init(origin: origin, size: cell.frame.size)
    }
}

fileprivate extension DetailsController {
    var finalFrame: CGRect {
        return CGRect(
            x: layoutProvider.itemSpacing,
            y: layoutProvider.itemSpacing,
            width: UIScreen.main.bounds.width - layoutProvider.itemSpacing * 2,
            height: layoutProvider.largeRowHeight)
    }
}
