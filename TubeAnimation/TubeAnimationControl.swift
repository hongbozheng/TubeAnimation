//
//  TubeAnimationControl.swift
//  TubeAnimation
//
//  Created by hongbozheng on 2/1/17.
//  Copyright © 2017 fiu. All rights reserved.
//

import UIKit

protocol TubeAnimationControlDelegate {
    func didTurnedToSecondPage()
    func didTurnedToFirstPage()
}

class TubeAnimationControl: UIView,TubeAnimationViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate : TubeAnimationControlDelegate? = nil
    
    var origin:Bool{
        get{
            if narrowView.d <= 10 {
                return true
            }else{
                return false
            }
        }
    }
    
    private lazy var narrowView:TubeAnimationView = {
        let tmpnv = TubeAnimationView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        tmpnv.towardsType = .TowardRight
        tmpnv.delegate = self
        return tmpnv
    }()
    
    private lazy var opNarrowView:TubeAnimationView = {
        let tmpnv = TubeAnimationView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        tmpnv.towardsType = .TowardLeft
        tmpnv.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI))
        tmpnv.isHidden = true
        tmpnv.delegate = self
        return tmpnv
    }()
    // NYTubeAnimtionViewDelegate
    func didTurnedToLeft() {
        if delegate != nil {
            delegate?.didTurnedToFirstPage()
        }
    }
    
    func didTurnedToRight() {
        if delegate != nil {
            delegate?.didTurnedToSecondPage()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(narrowView)
        self.addSubview(opNarrowView)
        narrowView.chosen_d = 0.001
        opNarrowView.chosen_d = 0.001
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnToFirstPage() {
        narrowView.chosen_d = 0.001
        narrowView.isHidden = true
        opNarrowView.chosen_d = Double(self.frame.width)/2
        opNarrowView.isHidden = false
    }
    
    func turnToSecondPage() {
        narrowView.chosen_d = Double(self.frame.width)/2
        narrowView.isHidden = false
        opNarrowView.chosen_d = 0.001
        opNarrowView.isHidden = true
    }
    

}
