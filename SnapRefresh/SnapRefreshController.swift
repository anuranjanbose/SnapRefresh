//
//  SnapRefreshController.swift
//  SnapRefresh
//
//  Created by Anuranjan Bose on 05/04/21.
//

import UIKit

class SnapRefreshController: UIViewController {
    
    fileprivate let startingHeight: CGFloat = 50.0
    fileprivate let maxDragHeight: CGFloat = 150.0
    fileprivate let shapeLayer: CAShapeLayer = CAShapeLayer()
    fileprivate let leftThree = UIView()
    fileprivate let leftTwo = UIView()
    fileprivate let leftOne = UIView()
    fileprivate let centerZero = UIView()
    fileprivate let rightOne = UIView()
    fileprivate let rightTwo = UIView()
    fileprivate let rightThree = UIView()
    
    fileprivate lazy var views: [UIView] = [
        leftThree,
        leftTwo,
        leftOne,
        centerZero,
        rightOne,
        rightTwo,
        rightThree
    ]
    
    fileprivate func layoutViewPoints(minHeight: CGFloat, dragY: CGFloat, dragX: CGFloat) {
        let minX: CGFloat = 0.0
        let maxX: CGFloat = view.frame.width
        
        leftThree.center = CGPoint(x: minX, y: minHeight)
        leftTwo.center = CGPoint(x: minX, y: minHeight + dragY)
        leftOne.center = CGPoint(x: minX, y: minHeight)
        centerZero.center = CGPoint(x: dragX, y: minHeight + dragY * 2)
        rightOne.center = CGPoint(x: maxX, y: minHeight)
        rightTwo.center = CGPoint(x: maxX, y: minHeight + dragY)
        rightThree.center = CGPoint(x: maxX, y: minHeight)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views.forEach { (layoutViewPoint) in
            layoutViewPoint.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
            layoutViewPoint.backgroundColor = .cyan
            view.addSubview(layoutViewPoint)
        }
        
        layoutViewPoints(minHeight: startingHeight, dragY: 100, dragX: view.frame.width/2)
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: startingHeight)
        shapeLayer.backgroundColor = UIColor.darkGray.cgColor
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.userIsDragging)))
    }
    
    @objc fileprivate func userIsDragging(gesture: UIPanGestureRecognizer) {
        
        let gestureState = gesture.state
        if gestureState == .ended || gestureState == .failed || gestureState == .cancelled {
            
        } else {
            //shapeLayer.frame.size.height = startingHeight + gesture.translation(in: self.view).y
            let dragHeight = gesture.translation(in: view).y
            
            let dragY = min(dragHeight * 0.5, maxDragHeight)
            let minimumHeight = startingHeight + dragHeight - dragY
            
            let dragX = gesture.location(in: view).x
            
            layoutViewPoints(minHeight: minimumHeight, dragY: dragY, dragX: dragX)
        }
    }
}
