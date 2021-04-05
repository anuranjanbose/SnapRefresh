//
//  SnapRefreshController.swift
//  SnapRefresh
//
//  Created by Anuranjan Bose on 05/04/21.
//

import UIKit

class SnapRefreshController: UIViewController {
    
    fileprivate let startingHeight: CGFloat = 50.0
    fileprivate let shapeLayer: CAShapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: startingHeight)
        shapeLayer.backgroundColor = UIColor.darkGray.cgColor
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.userIsDragging)))
    }
    
    @objc fileprivate func userIsDragging(gesture: UIPanGestureRecognizer) {
        
        let gestureState = gesture.state
        if gestureState == .ended || gestureState == .failed || gestureState == .cancelled {
            
        } else {
            shapeLayer.frame.size.height = startingHeight + gesture.translation(in: self.view).y
        }
    }
}
