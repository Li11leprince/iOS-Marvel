//
//  File.swift
//  Labs
//
//  Created by Effective on 20.03.2023.
//

import Foundation
import UIKit

protocol HorizontalPaginationManagerDelegate: AnyObject {
    func refreshAll(completion: @escaping (Bool) -> Void)
    func loadMore(completion: @escaping (Bool) -> Void)
}

class HorizontalPaginationManager: NSObject {
    
    private var isLoading = false
    private var isObservingKeyPath: Bool = false
    private var scrollView: UIScrollView!
    private var leftMostLoader: UIView?
    private var rightMostLoader: UIView?
    var refreshViewColor: UIColor = .clear
    var loaderColor: UIColor = .white
    
    weak var delegate: HorizontalPaginationManagerDelegate?
    
    init(scrollView: UIScrollView) {
        super.init()
        self.scrollView = scrollView
        //self.addScrollViewOffsetObserver()
    }
    
    deinit {
        //self.removeScrollViewOffsetObserver()
    }
    
}


extension HorizontalPaginationManager {
    
    private func addLeftMostControl() {
        let view = UIView()
        view.backgroundColor = self.refreshViewColor
        view.frame.origin = CGPoint(x: -60, y: 0)
        view.frame.size = CGSize(width: 60,
                                 height: self.scrollView.bounds.height)
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.color = self.loaderColor
        activity.frame = view.bounds
        activity.startAnimating()
        view.addSubview(activity)
        self.scrollView.contentInset.left = view.frame.width
        self.leftMostLoader = view
        self.scrollView.addSubview(view)
    }
    
    func removeLeftLoader() {
        self.leftMostLoader?.removeFromSuperview()
        self.leftMostLoader = nil
        self.scrollView.contentInset.left = 0
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
}

extension HorizontalPaginationManager {
    
    private func addRightMostControl() {
        let view = UIView()
        view.backgroundColor = self.refreshViewColor
        view.frame.origin = CGPoint(x: self.scrollView.contentSize.width,
                                    y: 0)
        view.frame.size = CGSize(width: 60,
                                 height: self.scrollView.bounds.height)
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.color = self.loaderColor
        activity.frame = view.bounds
        activity.startAnimating()
        view.addSubview(activity)
        self.scrollView.contentInset.right = view.frame.width
        self.rightMostLoader = view
        self.scrollView.addSubview(view)
    }
    
    func removeRightLoader() {
        self.rightMostLoader?.removeFromSuperview()
        self.rightMostLoader = nil
        self.scrollView.contentInset.right = 0
    }
    
}


extension HorizontalPaginationManager {
    
    func setContentOffSet(_ offset: CGPoint) {
        let offsetX = offset.x
        if offsetX < -100 && !self.isLoading {
            self.isLoading = true
            self.addLeftMostControl()
            self.delegate?.refreshAll { success in
                self.isLoading = false
                self.removeLeftLoader()
            }
            return
        }
        
        let contentWidth = self.scrollView.contentSize.width
        let frameWidth = self.scrollView.bounds.size.width
        let diffX = contentWidth - frameWidth
        if contentWidth > frameWidth,
        offsetX > (diffX + 100) && !self.isLoading {
            self.isLoading = true
            self.addRightMostControl()
            self.delegate?.loadMore { success in
                self.isLoading = false
                self.removeRightLoader()
            }
        }
    }
}
