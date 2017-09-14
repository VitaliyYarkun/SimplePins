//
//  UIViewController+Utils.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/14/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showProgressBar() {
        
        let progressBarView: ProgressBarView = .fromNib()
        progressBarView.frame = view.bounds
        progressBarView.dotsView.startAnimating()
        view.addSubview(progressBarView)
    }
    
    func hideProgressBar() {
        
        for lView in self.view.subviews {
            if let progressView = lView as? ProgressBarView {
                progressView.dotsView.stopAnimating()
                progressView.removeFromSuperview()
            }
        }
    }
}
