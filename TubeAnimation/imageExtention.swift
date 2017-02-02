//
//  imageExtention.swift
//  TubeAnimation
//
//  Created by hongbozheng on 1/31/17.
//  Copyright © 2017 fiu. All rights reserved.
//

import UIKit

extension UIImage{
    func cropToCircleWithBorderColor(color:UIColor,lineWidth:CGFloat) -> UIImage {
        let imgRect = CGRect(origin: CGPoint.zero, size: self.size)
       UIGraphicsBeginImageContext(imgRect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.addEllipse(in: imgRect)
        context?.clip()
       
        self.draw(at: CGPoint.zero)
        
        context!.addEllipse(in:imgRect)
        color.setStroke()
        context!.setLineWidth(lineWidth)
        context?.strokePath()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
}
