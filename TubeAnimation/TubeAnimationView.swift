//
//  TubeAnimationView.swift
//  TubeAnimation
//
//  Created by hongbozheng on 1/31/17.
//  Copyright © 2017 fiu. All rights reserved.
//

import UIKit

protocol TubeAnimationViewDelegate {
    func didTurnedToRight()
    func didTurnedToLeft()
}

class TubeAnimationView: UIView {

    
    enum TowardsType{
        case TowardRight
        case TowardLeft
    }

    var delegate:TubeAnimationViewDelegate? = nil
    
    var r1:Double = 0.0
    var r2:Double = 0.0
    var d:Double = 0.0
    var towardsType:TowardsType = .TowardRight
    private var finished = false
    private var a = 0.0
    private var increment = 0.0
    private var mainRect_w = 0.0
    private var uber_w = 0.0
    private var uber_rate = 0.0
    private var tube_w = 0.0
    private var tube_rate = 0.0
    
    private var leftSemiShape = CAShapeLayer()
    private var maintubeShape = CAShapeLayer()
    private var volcanoShape = CAShapeLayer()
    private var rightCircleShape = CAShapeLayer()
    private var tailCircleShape = CAShapeLayer()
    private var tubeShape = CAShapeLayer()
    private var wholeShape  = CAShapeLayer()
    
    private var wholeShapeView = UIView()
    private var animationShapeView = UIView()
    private var chosendDisplayLink = CADisplayLink()
    
    
    private var pointO = CGPoint()
    private var pointQ = CGPoint()
    private var pointQ2 = CGPoint()
    private var pointO2 = CGPoint()
    private var pointP = CGPoint()
     private var pointP2 = CGPoint()
     private var pointR = CGPoint()
     private var pointA = CGPoint()
     private var pointB = CGPoint()
     private var pointC = CGPoint()
     private var pointD = CGPoint()
    
    private var tube_h = 0.0
    private var dynamic_Q_d = 0.0
    private var dynamic_Q2_d = 0.0
    private var pointOx = 0.0
    
    private var displayLink : CADisplayLink? = nil
    
    var _chosen_d:Double = 0.0
    var chosen_d:Double {
        
        get{
            return _chosen_d
        }
        set{
          _chosen_d = newValue
            d = 0.0
            initParams()
            if displayLink != nil {
                displayLink?.invalidate()
                displayLink = nil
            }
            displayLink = CADisplayLink(target: self, selector: #selector(changeParamManually))
            displayLink?.add(to:RunLoop.main, forMode: .commonModes)
        }
       }

    func changeParamManually() {
        if d >= chosen_d {
            return
        }
        drawWithParams()
        d = d + increment
    }
    
    func animationDidfinish()  {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initParams()
        initShape()
        drawWholeShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initParams(){
        finished = false
        r1 = Double(self.frame.height/2) - 4
        r2 = r1/2
        a = 27.0
        d = 0.0
        increment = 2.0
        mainRect_w = r1*2
        pointOx = r1 + mainRect_w + 5
        
        pointO = CGPoint(x: pointOx, y: Double(self.frame.height/2))
        pointQ = pointO
        pointQ2 = pointQ
        
        pointP = CGPoint(x: 1.5*r1*cos(a/180*M_PI) + Double(pointO.x), y: -1.5*r1*sin(a/180*M_PI) + Double(pointO.y))
        
        uber_w = Double(pointP.x) - Double(pointO.x)
        tube_w = Double(self.frame.width) - pointOx*2 - uber_w*2
        
        pointO2 = CGPoint(x: Double(pointO.x) + tube_w + 2*uber_w, y: Double(pointO.y))
        pointP2 = CGPoint(x:  Double(pointP.x) + tube_w, y: Double(pointP.y))
        
        pointA = CGPoint(x: r1*cos(a/180*M_PI) + Double(pointO.x), y: Double(pointO.y) - r1*sin(a/180*M_PI))
        pointB = CGPoint(x: Double(pointA.y), y: Double(pointO.y) + (Double(pointO.y) - Double(pointA.y)))
        pointC = CGPoint(x:  Double(pointP.x), y:  Double(pointP.y) + r2)
        tube_h = 2*( Double(pointO.y) -  Double(pointC.y))
        pointD = CGPoint(x:  Double(pointC.x), y:  Double(pointC.y)+tube_h)
        
        dynamic_Q_d = 0.0
        dynamic_Q2_d = 0.0
        
        uber_rate = 2.5
        tube_rate = 6.0
    }
    
    private func initShape(){
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let color = UIColor.white
        leftSemiShape.frame = frame
        leftSemiShape.fillColor = color.cgColor
        volcanoShape.frame = frame
        volcanoShape.fillColor = color.cgColor
        rightCircleShape.frame = frame
        rightCircleShape.fillColor = color.cgColor
        tubeShape.frame = frame
        tubeShape.fillColor = color.cgColor
        maintubeShape.frame = frame
        maintubeShape.fillColor = color.cgColor
        tailCircleShape.initWithFrame(frame: frame, color: color)
        wholeShape.initWithFrame(frame: frame, color: color)
        
        wholeShapeView.frame = frame
        animationShapeView.frame = frame
        
        animationShapeView.layer.addSublayer(wholeShape)
        animationShapeView.layer.addSublayer(leftSemiShape)
        animationShapeView.layer.addSublayer(maintubeShape)
        animationShapeView.layer.addSublayer(volcanoShape)
         animationShapeView.layer.addSublayer(rightCircleShape)
         animationShapeView.layer.addSublayer(tubeShape)
         animationShapeView.layer.addSublayer(tailCircleShape)
        
        self.addSubview(wholeShapeView)
        self.addSubview(animationShapeView)
        
    }
    
    private func drawWholeShape(){
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let color = UIColor(colorLiteralRed: 225/255.0, green: 65/255.0, blue: 67/255.0, alpha: 1.0)
        let _r1 = r1 + 2.0
        
        let leftSemiPath = UIBezierPath()
        let pointR = CGPoint(x: Double(pointO.x) - mainRect_w, y: Double(pointO.y))
        leftSemiPath.addArc(withCenter: pointR, radius: CGFloat(_r1), startAngle:CGFloat(0.5*M_PI) , endAngle: CGFloat(1.5*M_PI), clockwise: true)
     let leftSemiShape =  CAShapeLayer.initWithFrame(frame: frame, color: color, path: leftSemiPath)
       
        let mainRectPath = UIBezierPath()
        mainRectPath.move(to: CGPoint(x: Double(pointR.x) - 0.2, y: Double(pointR.y) - _r1))
        mainRectPath.addLine(to: CGPoint(x:Double(pointR.x) - 0.2, y: Double(pointR.y) + _r1))
        mainRectPath.addLine(to: CGPoint(x:Double(pointO.x) + 0.2, y: Double(pointO.y) + _r1))
        mainRectPath.addLine(to: CGPoint(x:Double(pointO.x) + 0.2, y: Double(pointO.y) - _r1))
        let mainTubeShape = CAShapeLayer.initWithFrame(frame: frame, color: color, path: mainRectPath)
        
        let rightSemiPath = UIBezierPath()
        rightSemiPath.addArc(withCenter: pointO, radius: CGFloat(_r1), startAngle: CGFloat(1.5*M_PI), endAngle: CGFloat(0.5*M_PI), clockwise: true)
        let rightSemiShape =  CAShapeLayer.initWithFrame(frame: frame, color: color, path: rightSemiPath)
       
        let vocalnoPath = UIBezierPath()
        vocalnoPath.addArc(withCenter: pointP, radius: CGFloat(r2 - 2), startAngle: CGFloat(0.5*M_PI), endAngle: CGFloat(((180 - a)/180)*M_PI), clockwise: true)
        vocalnoPath.addArc(withCenter: CGPoint(x: Double(pointP.x), y: Double(pointO.y + pointO.y - pointP.y)), radius: CGFloat(r2 - 2), startAngle: CGFloat((180 + a)/180*M_PI), endAngle: CGFloat(1.5*M_PI), clockwise: true)
        let vocalnoSemiShape =  CAShapeLayer.initWithFrame(frame: frame, color: color, path: vocalnoPath)
        //vocalnoSemiShape.fillColor = UIColor.purple.cgColor
        
        let _tube_h = (tube_h + 4)
        let recPath = UIBezierPath()
        recPath.move(to: CGPoint(x: Double(pointO.x), y: Double(pointO.y) - _tube_h/2))
        recPath.addLine(to: CGPoint(x:Double(pointO.x), y: Double(pointO.y) + _tube_h/2))
        recPath.addLine(to: CGPoint(x:Double(pointO.x) + tube_w + uber_w*2, y: Double(pointO.y) + _tube_h/2))
        recPath.addLine(to: CGPoint(x:Double(pointO.x) + tube_w + uber_w*2, y: Double(pointO.y) - _tube_h/2))
        recPath.addLine(to: CGPoint(x:Double(pointO.x), y: Double(pointO.y) - _tube_h/2))
        recPath.close()
        let tubeShape = CAShapeLayer.initWithFrame(frame: frame, color: color, path: recPath)
        
        let r_leftSemiPath = UIBezierPath()
        let pointR2 = CGPoint(x: Double(pointO.x) + uber_w*2 + tube_w, y: Double(pointO.y))
        r_leftSemiPath.addArc(withCenter: pointR2, radius: CGFloat(_r1), startAngle:CGFloat(0.5*M_PI) , endAngle: CGFloat(1.5*M_PI), clockwise: true)
        let r_leftSemiShape =  CAShapeLayer.initWithFrame(frame: frame, color: color, path: r_leftSemiPath)
        
        let r_mainRectPath = UIBezierPath()
        r_mainRectPath.move(to: CGPoint(x: Double(pointR2.x) - 0.35, y: Double(pointR2.y) - _r1))
        r_mainRectPath.addLine(to: CGPoint(x:Double(pointR2.x) - 0.35, y: Double(pointR2.y) + _r1))
        r_mainRectPath.addLine(to: CGPoint(x:Double(pointR2.x) + mainRect_w + 0.3, y: Double(pointR2.y) + _r1))
        r_mainRectPath.addLine(to: CGPoint(x:Double(pointR2.x) + mainRect_w + 0.3, y: Double(pointR2.y) - _r1))
        let r_mainTubeShape = CAShapeLayer.initWithFrame(frame: frame, color: color, path: r_mainRectPath)
        
        let r_rightSemiPath = UIBezierPath()
        r_rightSemiPath.addArc(withCenter: CGPoint(x: Double(pointR2.x) + mainRect_w, y: Double(pointR2.y)), radius: CGFloat(_r1), startAngle: CGFloat(1.5*M_PI), endAngle: CGFloat(0.5*M_PI), clockwise: true)
        let r_rightSemiShape =  CAShapeLayer.initWithFrame(frame: frame, color: color, path: r_rightSemiPath)
        
        let r_vocalnoPath = UIBezierPath()
        r_vocalnoPath.addArc(withCenter: CGPoint(x: Double(pointO2.x) - uber_w, y: Double(pointP.y)), radius: CGFloat(r2 - 2), startAngle: CGFloat(a/180*M_PI), endAngle: CGFloat(0.5*M_PI), clockwise: true)
        r_vocalnoPath.addArc(withCenter: CGPoint(x: Double(pointO2.x) - uber_w, y: Double(pointO.y + pointO.y - pointP.y)), radius: CGFloat(r2 - 2), startAngle: CGFloat(1.5*M_PI), endAngle: CGFloat(((360 - a)/180)*M_PI), clockwise: true)
        let r_vocalnoSemiShape =  CAShapeLayer.initWithFrame(frame: frame, color: color, path: r_vocalnoPath)

        
        wholeShapeView.layer.addSublayer(leftSemiShape)
        wholeShapeView.layer.addSublayer(mainTubeShape)
        wholeShapeView.layer.addSublayer(rightSemiShape)
        wholeShapeView.layer.addSublayer(vocalnoSemiShape)
        wholeShapeView.layer.addSublayer(tubeShape)
        wholeShapeView.layer.addSublayer(r_leftSemiShape)
        wholeShapeView.layer.addSublayer(r_mainTubeShape)
        wholeShapeView.layer.addSublayer(r_rightSemiShape)
        wholeShapeView.layer.addSublayer(r_vocalnoSemiShape)
       
        
        
    }
    
    func drawWithParams() {
        pointR = CGPoint(x: Double(pointO.x) - mainRect_w + d, y: Double(pointO.y))
        if dynamic_Q2_d <= uber_w {
            if d <= mainRect_w {
                dynamic_Q2_d = 0
            }else{
                dynamic_Q2_d += uber_rate*increment
            }
        }else if dynamic_Q2_d <= tube_w + uber_w {
            dynamic_Q2_d += tube_rate*increment
        }else if dynamic_Q2_d < uber_w + tube_w + uber_w{
            dynamic_Q2_d += uber_rate*increment
            if dynamic_Q2_d >= uber_w + tube_w + uber_w {
                dynamic_Q2_d = uber_w + tube_w + uber_w
            }
        }else{
            dynamic_Q2_d = uber_w + tube_w + uber_w
        }
        
        pointQ2 = CGPoint(x:Double(pointO.x) + dynamic_Q2_d,y:Double(pointO.y))
        
        if (dynamic_Q_d <= uber_w)
        {
            dynamic_Q_d += uber_rate * increment;
        }
        else if (dynamic_Q_d < uber_w + tube_w)
        {
            dynamic_Q_d += tube_rate * increment;
            if (dynamic_Q_d > tube_w + uber_w)
            {
                dynamic_Q_d = tube_w + uber_w;
            }
        }
        else if (dynamic_Q_d <= uber_w + tube_w + uber_w)
        {
            dynamic_Q_d += uber_rate * increment;
        }
        else if(dynamic_Q_d <= uber_w + tube_w + uber_w + mainRect_w)
        {   //到右方后原速行驶
            dynamic_Q_d += increment;
            if (dynamic_Q_d > uber_w + tube_w + uber_w + mainRect_w)
            {
                dynamic_Q_d = uber_w + tube_w + uber_w + mainRect_w;
                
                if (!finished) {
                    finished = !finished;
                    animationDidfinish()
                    
                    if towardsType == .TowardRight {
                        if delegate != nil{
                            delegate?.didTurnedToRight()
                        }
                    }else{
                        if delegate != nil{
                               delegate?.didTurnedToLeft()
                        }
                    }
                }
            }
        }
        
        //动态圆弧的圆心
        pointQ = CGPoint(x:Double(pointO.x) + dynamic_Q_d, y:Double(pointO.y));
        
        //动态圆弧端-圆心与y轴的夹角
        let  c:Double
        
        if (dynamic_Q_d <= uber_w)
        {
        
            c = atan((Double(pointP.x - pointO.x) - dynamic_Q_d)/Double(pointO.y - pointP.y))*180/M_PI
        }
        else if (dynamic_Q_d <= uber_w + tube_w)
        {
            c = 0;
        }
        else if (dynamic_Q_d <= uber_w + tube_w + uber_w)
        {
            c = atan(Double(pointQ.x - pointP2.x)/Double(pointO.y - pointP.y))*180/M_PI;
        }
        else{
            c = 90 - a;
        }
        
        //动态圆的半径
        let r3 = Double(pointO.y - pointP.y)/cos(c/180*M_PI) - r2;

        let leftSemiPath = UIBezierPath()
        if (d <= mainRect_w) {
        leftSemiPath.addArc(withCenter: pointR, radius: CGFloat(r1), startAngle:CGFloat(0.5*M_PI) , endAngle: CGFloat(1.5*M_PI), clockwise: true)
        }else if dynamic_Q_d >= uber_w + tube_w + uber_w{
             leftSemiPath.addArc(withCenter:  CGPoint(x:Double(pointQ.x) - 0.3, y:Double(pointQ.y)), radius: CGFloat(r1), startAngle:CGFloat(1.5*M_PI) , endAngle: CGFloat(0.5*M_PI), clockwise: true)
        }
        leftSemiShape.path = leftSemiPath.cgPath
        
        let mainRectPath = UIBezierPath()
        if d <= mainRect_w{
        mainRectPath.move(to: CGPoint(x: Double(pointR.x), y: Double(pointR.y) - r1))
        mainRectPath.addLine(to: CGPoint(x:Double(pointR.x), y: Double(pointR.y) + r1))
        mainRectPath.addLine(to: CGPoint(x:Double(pointO.x), y: Double(pointO.y) + r1))
        mainRectPath.addLine(to: CGPoint(x:Double(pointO.x), y: Double(pointO.y) - r1))
        }else if dynamic_Q_d >= uber_w + tube_w + uber_w {
            mainRectPath.move(to: CGPoint(x: Double(pointO2.x), y: Double(pointO2.y) - r1))
            mainRectPath.addLine(to: CGPoint(x:Double(pointO2.x), y: Double(pointO2.y) + r1))
            mainRectPath.addLine(to: CGPoint(x:Double(pointQ.x), y: Double(pointQ.y) + r1))
            mainRectPath.addLine(to: CGPoint(x:Double(pointQ.x), y: Double(pointQ.y) - r1))
        }
        maintubeShape.path = mainRectPath.cgPath
        
        let vocalnoPath = UIBezierPath()
        if d <= mainRect_w{
            let temC = (c <= 0) ? 0:c
            vocalnoPath.addArc(withCenter: pointP, radius: CGFloat(r2), startAngle: CGFloat(((90 + temC)/180)*M_PI), endAngle: CGFloat(((180 - a)/180)*M_PI), clockwise: true)
            vocalnoPath.addArc(withCenter: CGPoint(x: Double(pointP.x), y: Double(pointO.y + pointO.y - pointP.y)), radius: CGFloat(r2), startAngle: CGFloat((180 + a)/180*M_PI), endAngle: CGFloat(((270-temC)/180)*M_PI), clockwise: true)
            
        }else if dynamic_Q2_d <= uber_w {
           
            let temC = atan((Double(pointP.x - pointO.x) - dynamic_Q2_d)/Double(pointO.y - pointP.y))*180/M_PI
            vocalnoPath.addArc(withCenter: pointP, radius: CGFloat(r2), startAngle: CGFloat(0.5*M_PI), endAngle: CGFloat(((90 + temC)/180)*M_PI), clockwise: true)
            vocalnoPath.addArc(withCenter: CGPoint(x: Double(pointP.x), y: Double(pointO.y + pointO.y - pointP.y)), radius: CGFloat(r2), startAngle: CGFloat((270-temC)/180*M_PI), endAngle: CGFloat(1.5*M_PI), clockwise: true)
        }else if dynamic_Q_d >= tube_w + uber_w && dynamic_Q2_d <= tube_w + uber_w{
            let temC = atan((Double(pointQ.x - pointO.x) - tube_w - uber_w)/Double(pointO.y - pointP.y))*180/M_PI
            vocalnoPath.addArc(withCenter: pointP2, radius: CGFloat(r2), startAngle:CGFloat(((90 - temC)/180)*M_PI) , endAngle: CGFloat(0.5*M_PI), clockwise: true)
            vocalnoPath.addArc(withCenter: CGPoint(x: Double(pointP2.x), y: Double(pointO.y + pointO.y - pointP.y)), radius: CGFloat(r2), startAngle:CGFloat(1.5*M_PI) , endAngle:CGFloat((270+temC)/180*M_PI) , clockwise: true)
        }else if dynamic_Q2_d < uber_w + tube_w + uber_w && dynamic_Q2_d >= uber_w + tube_w{
            let temC = atan((Double(pointQ2.x - pointP2.x))/Double(pointO.y - pointP.y))*180/M_PI
            vocalnoPath.addArc(withCenter: pointP2, radius: CGFloat(r2), startAngle:CGFloat(a/180*M_PI) , endAngle: CGFloat(((90 - temC)/180)*M_PI), clockwise: true)
            vocalnoPath.addArc(withCenter: CGPoint(x: Double(pointP2.x), y: Double(pointO.y + pointO.y - pointP.y)), radius: CGFloat(r2), startAngle:CGFloat((270+temC)/180*M_PI) , endAngle:CGFloat(((360 - a)/180) * M_PI) , clockwise: true)
        }
        volcanoShape.path = vocalnoPath.cgPath
        
        let rightSemiPath = UIBezierPath()
        if (dynamic_Q_d <= uber_w + tube_w + uber_w) {
            rightSemiPath.addArc(withCenter:  CGPoint(x: Double(pointQ.x), y: Double(pointQ.y)), radius: CGFloat(r3), startAngle:CGFloat(0.0*M_PI) , endAngle: CGFloat(2*M_PI), clockwise: true)
        }else {
            rightSemiPath.addArc(withCenter:  CGPoint(x:Double(pointO2.x), y:Double(pointQ.y)), radius: CGFloat(r3), startAngle:CGFloat(0.0*M_PI) , endAngle: CGFloat(2*M_PI), clockwise: true)
        }
        rightCircleShape.path = rightSemiPath.cgPath

        let tailPath = UIBezierPath()
        if d <= mainRect_w{
            tailPath.addArc(withCenter: pointO, radius: CGFloat(r1), startAngle:CGFloat(0.0*M_PI) , endAngle: CGFloat(2.0*M_PI), clockwise: true)

        }else if (dynamic_Q2_d <= uber_w) {
        
            let temC = atan((Double(pointP.x - pointO.x) - dynamic_Q2_d)/Double(pointO.y - pointP.y))*180/M_PI
            let temR3 = Double(pointO.y - pointP.y)/cos(temC/180*M_PI) - r2
            tailPath.addArc(withCenter: pointQ2, radius: CGFloat(temR3), startAngle:CGFloat(0.0*M_PI) , endAngle: CGFloat(2.0*M_PI), clockwise: true)
 
        }else if dynamic_Q2_d <= uber_w + tube_w   {
            let tmp_pointQ = CGPoint(x: Double(pointO.x) + dynamic_Q2_d, y: Double(pointO.y))
            
             tailPath.addArc(withCenter:tmp_pointQ, radius: CGFloat(tube_h/2), startAngle:CGFloat(0.0*M_PI) , endAngle: CGFloat(2.0*M_PI), clockwise: true)

        }else if dynamic_Q2_d <= uber_w + tube_w + uber_w  {
            let temC = atan((Double(pointQ2.x - pointO.x) - uber_w - tube_w)/Double(pointO.y - pointP.y))*180/M_PI
            let temR3 = Double(pointO.y - pointP.y)/cos(temC/180*M_PI) - r2
         tailPath.addArc(withCenter: pointQ2, radius: CGFloat(temR3), startAngle:CGFloat(0.0*M_PI) , endAngle: CGFloat(2.0*M_PI), clockwise: true)
        }
        tailCircleShape.path = tailPath.cgPath
        
        let recPath = UIBezierPath()
        if d <= tube_w + uber_w {
        recPath.move(to: CGPoint(x: Double(pointQ2.x), y: Double(pointC.y)))
        recPath.addLine(to: CGPoint(x:Double(pointQ2.x), y: Double(pointD.y)))
        recPath.addLine(to: CGPoint(x:Double(pointQ.x), y: Double(pointD.y)))
        recPath.addLine(to: CGPoint(x:Double(pointQ.x), y: Double(pointC.y)))
        recPath.addLine(to: pointC)
        recPath.close()
        }
        tubeShape.path = recPath.cgPath
        
        leftSemiShape.setNeedsDisplay()
        maintubeShape.setNeedsDisplay()
        volcanoShape.setNeedsDisplay()
        rightCircleShape.setNeedsDisplay()
        tubeShape.setNeedsDisplay()
        tailCircleShape.setNeedsDisplay()



    }
    
    
}

extension CAShapeLayer {
    func initWithFrame(frame:CGRect, color:UIColor){
        self.frame = frame
        self.fillColor = color.cgColor
    }
    
  class func initWithFrame(frame:CGRect, color:UIColor, path:UIBezierPath) -> CAShapeLayer{
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = frame
        shapeLayer.fillColor = color.cgColor
        shapeLayer.path = path.cgPath
        return shapeLayer
    }
    /*
     func initWithFrame(frame:CGRect, color:UIColor, path:UIBezierPath){
        
          self.frame = frame
         self.fillColor = color.cgColor
         self.path = path.cgPath
        
    }
*/
 
}

