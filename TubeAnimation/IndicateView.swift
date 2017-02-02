//
//  IndicateView.swift
//  TubeAnimation
//
//  Created by hongbozheng on 1/31/17.
//  Copyright © 2017 fiu. All rights reserved.
//

import UIKit
private  let screenWidth = UIScreen.main.bounds.width
private let screenHeight = UIScreen.main.bounds.height

class IndicateView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private lazy var imageView:UIImageView = {
        let tmpImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
         tmpImageView.image = UIImage(named: "assetbg")
        return tmpImageView
    }()

    private lazy var animationControl:TubeAnimationControl = {
        let tmpAV = TubeAnimationControl(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        tmpAV.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 96)
        return tmpAV
    }()
    
    func turnToFirstPage() {
        if animationControl.origin {
            return
        }
        animationControl.turnToFirstPage()
    }

    func turnToSecondPage() {
        if !animationControl.origin {
            return
        }
        animationControl.turnToSecondePage()
    }
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
        self.addSubview(imageView)
        self.addSubview(animationControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
}
