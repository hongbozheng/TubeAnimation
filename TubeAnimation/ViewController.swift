//
//  ViewController.swift
//  TubeAnimation
//
//  Created by hongbozheng on 1/30/17.
//  Copyright © 2017 fiu. All rights reserved.
//

import UIKit

private  let screenWidth = UIScreen.main.bounds.width
private let screenHeight = UIScreen.main.bounds.height
private let tubeViewHeight = CGFloat(200)
class ViewController: UIViewController,UIScrollViewDelegate ,TubeAnimationControlDelegate{
    
  private lazy var scrollView:UIScrollView = {
      let tmpsv = UIScrollView(frame: CGRect(x: 0, y: tubeViewHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - tubeViewHeight))
    tmpsv.isPagingEnabled = true
    tmpsv.showsHorizontalScrollIndicator = false
    tmpsv.bounces = false
    tmpsv.delegate = self
    tmpsv.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: tmpsv.bounds.height)
    return tmpsv
    }()
 
  private  lazy var firstBtn:UIButton = {
      let tmpBtn = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - tubeViewHeight))
    tmpBtn.backgroundColor = UIColor(displayP3Red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
    tmpBtn.setTitle("Next page", for: UIControlState.normal)
    tmpBtn.setTitleColor(UIColor.black, for: .normal)
    tmpBtn.addTarget(self, action: #selector(turnToSecondPage), for: .touchUpInside)
        return tmpBtn
    }()
    
  private  lazy var secondBtn:UIButton = {
        let tmpBtn = UIButton(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: self.scrollView.bounds.height))
        tmpBtn.backgroundColor = UIColor(displayP3Red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        tmpBtn.setTitle("Previous page", for: UIControlState.normal)
        tmpBtn.setTitleColor(UIColor.black, for: .normal)
        tmpBtn.addTarget(self, action: #selector(turnToFirstPage), for: .touchUpInside)
        return tmpBtn
    }()
    
    private lazy var indicateView:IndicateView = {
        let tmpIndicateView = IndicateView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: tubeViewHeight))
        return tmpIndicateView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // add one comment line
        self.view.addSubview(indicateView)
        self.view.addSubview(scrollView)
        scrollView.addSubview(firstBtn)
        scrollView.addSubview(secondBtn)
        indicateView.animationControlDelegate = self
           }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    //TubeAnimationControlDelegate
    func didTurnedToFirstPage() {
        print("First page")
    }
    func didTurnedToSecondPage() {
        print("Second page")
    }
   @objc private  func turnToFirstPage() {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
          indicateView.turnToFirstPage()

    }
   @objc private func turnToSecondPage() {
        scrollView.setContentOffset(CGPoint.init(x: scrollView.bounds.width, y: 0), animated: true)
          indicateView.turnToSecondPage()
    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

