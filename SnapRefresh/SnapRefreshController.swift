//
//  SnapRefreshController.swift
//  SnapRefresh
//
//  Created by Anuranjan Bose on 05/04/21.
//

import UIKit

class SnapRefreshController: UIViewController {
    
    fileprivate let startingHeight: CGFloat = 90.0
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
    
    fileprivate var displayLink: CADisplayLink!
    fileprivate var animating = false {
        didSet {
            view.isUserInteractionEnabled = !animating
            displayLink.isPaused = !animating
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        shapeLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: startingHeight)
        shapeLayer.fillColor = UIColor.darkGray.cgColor
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.userIsDragging)))
        
        self.setUpViewPoints()
        self.setupCADisplayLink()
    }
    
    fileprivate func setupCADisplayLink() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(generatePath))
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        
    }
    
    fileprivate func setUpViewPoints() {
        views.forEach { (layoutViewPoint) in
            layoutViewPoint.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
            layoutViewPoint.backgroundColor = .cyan
            view.addSubview(layoutViewPoint)
        }
        
        layoutViewPoints(minHeight: startingHeight, dragY: 0, dragX: view.frame.width/2)
        
        generatePath()
    }
    
    @objc fileprivate func generatePath() {
        let screenWidth = UIScreen.main.bounds.width
        
        let leftThreeCenter = leftThree.center
        let leftTwoCenter = leftTwo.center
        let leftOneCenter = leftOne.center
        let centerZeroCenter = centerZero.center
        let rightOneCenter = rightOne.center
        let rightTwoCenter = rightTwo.center
        let rightThreeCenter = rightThree.center
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: leftThreeCenter.y))
        
        bezierPath.addCurve(to: leftOneCenter, controlPoint1: leftThreeCenter, controlPoint2: leftTwoCenter)
        bezierPath.addCurve(to: rightOneCenter, controlPoint1: centerZeroCenter, controlPoint2: rightOneCenter)
        bezierPath.addCurve(to: rightThreeCenter, controlPoint1: rightOneCenter, controlPoint2: rightTwoCenter)

        
        bezierPath.addLine(to: CGPoint(x: screenWidth, y: 0))
        
        shapeLayer.path = bezierPath.cgPath

    }
    
    fileprivate func layoutViewPoints(minHeight: CGFloat, dragY: CGFloat, dragX: CGFloat) {
        let minX: CGFloat = 0.0
        let maxX: CGFloat = view.frame.width
        
        let leftPart = dragX - minX
        let rightPart = maxX - dragX
        
        leftThree.center = CGPoint(x: minX, y: minHeight)
        
        leftTwo.center = CGPoint(x: minX + (leftPart * 0.44), y: minHeight)
        leftOne.center = CGPoint(x: minX + (leftPart * 0.71), y: minHeight + (dragY * 0.64))
        centerZero.center = CGPoint(x: dragX, y: minHeight + (dragY * 1.36))
        rightOne.center = CGPoint(x: maxX - (rightPart * 0.71), y: minHeight + (dragY * 0.64))
        rightTwo.center = CGPoint(x: maxX - (rightPart * 0.44), y: minHeight)
        
        rightThree.center = CGPoint(x: maxX, y: minHeight)
        
    }
        
    @objc fileprivate func userIsDragging(gesture: UIPanGestureRecognizer) {
        
        let gestureState = gesture.state
        if gestureState == .ended || gestureState == .failed || gestureState == .cancelled {
            animating = true
            UIView.animate(withDuration: 05, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.views.forEach({ view in
                    view.center.y = self.startingHeight
                })
            }, completion: { [weak self] complete in
                if complete {
                    self?.animating = false
                }
            })
        } else {
            //shapeLayer.frame.size.height = startingHeight + gesture.translation(in: self.view).y
            let dragHeight = gesture.translation(in: view).y
            
            let dragY = min(dragHeight * 0.5, maxDragHeight)
            let minimumHeight = startingHeight + dragHeight - dragY
            
            let dragX = gesture.location(in: view).x
            
            layoutViewPoints(minHeight: minimumHeight, dragY: dragY, dragX: dragX)
            generatePath()
        }
    }
}
