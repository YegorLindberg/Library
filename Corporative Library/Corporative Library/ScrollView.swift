//
//  ScrollView.swift
//  Corporative Library
//
//  Created by Moore on 06.07.2018.
//  Copyright © 2018 Moore. All rights reserved.
//

import UIKit

class ScrollView: UIView { //UIScrollView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(with:)))
        addGestureRecognizer(panGesture)
        
    }
    
    
    
    @objc func panView(with gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        
        UIView.animate(withDuration: 0.20) {
            if ((self.bounds.origin.y - translation.y >= -1) && (self.bounds.origin.y - translation.y <= 1000)) { //TODO: вычислять размер контента и подставлять в пределы.
                self.bounds.origin.y = self.bounds.origin.y - translation.y
            }
            
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
