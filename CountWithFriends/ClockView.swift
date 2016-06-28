//
//  ClockView.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class ClockView: UIView {

    private var shapeLayer = CAShapeLayer()
    private var countDownTimer = NSTimer()
    private var timerValue = 900
    private var label = UILabel()
    private var circleCenter = CGPoint()
    private var circleRadius = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.circleCenter = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.circleRadius = frame.size.width/2
        self.createLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    
    private func addCircle() {
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(2*M_PI-M_PI_2), clockwise: true)
        
        self.shapeLayer.path = circlePath.CGPath
        self.shapeLayer.fillColor = UIColor.clearColor().CGColor
        self.shapeLayer.strokeColor = UIColor.redColor().CGColor
        self.shapeLayer.lineWidth = 1.0
        
        self.layer.addSublayer(self.shapeLayer)
    }
    
    private func createLabel() {
        self.label = UILabel(frame: CGRect(x: circleRadius - 7, y: circleRadius - 10, width: 40, height: 20))
        self.label.font = UIFont(name: self.label.font.fontName, size: 12)
        self.label.textColor = UIColor.redColor()
        
        self.addSubview(self.label)
    }
    
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = Double(self.timerValue)
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        self.shapeLayer.addAnimation(animation, forKey: "ani")
    }
    
    private func updateLabel(value: Int) {
        self.setLabelText(self.timeFormatted(value))
        self.addCircle()
    }
    
    private func setLabelText(value: String) {
        self.label.text = value
    }
    
    private func timeFormatted(totalSeconds: Int) -> String{
        let seconds: Int = totalSeconds % 60
        //let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d",seconds)
    }
    
    @objc private func countdown(dt: NSTimer) {
        self.timerValue -= 1
        if self.timerValue < 0 {
            self.countDownTimer.invalidate()
        } else {
            self.setLabelText(self.timeFormatted(self.timerValue))
        }
        
    }
    
    func setTimer(value: Int) {
        self.timerValue = value
        self.updateLabel(value)
    }
    
    func startClockTimer() {
        self.countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ClockView.countdown(_:)), userInfo: nil, repeats: true)
        self.startAnimation()
    }

}
        