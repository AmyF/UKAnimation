//
//  UKAnimation.swift
//  UKAnimation
//
//  Created by unko on 2018/9/3.
//  Copyright © 2018年 unko. All rights reserved.
//

import UIKit


class UKAnimation {
    
    deinit {
        print("UKAnimation<\(animateView)> was deinit")
    }
    
    typealias Then = (UKAnimation) -> Void
    
    private let animateView : UIView
    
    private var options     : UIViewAnimationOptions = [.curveLinear]
    private var duration    : TimeInterval = 0
    private var delay       : TimeInterval = 0
    private var damping     : CGFloat = 1
    private var velocity    : CGFloat = 1
    
    init(view: UIView) {
        animateView = view
    }
    // MARK: getter
    var frame: CGRect { return animateView.frame }
    var view: UIView { return animateView }
    
    // MARK: setter
    @discardableResult func set(options: UIViewAnimationOptions) -> Self {
        self.options = options
        return self
    }
    
    @discardableResult func set(duration: TimeInterval) -> Self {
        self.duration = duration
        return self
    }
    
    @discardableResult func set(delay: TimeInterval) -> Self {
        self.delay = delay
        return self
    }
    
    @discardableResult func set(damping: CGFloat) -> Self {
        self.damping = damping
        return self
    }
    
    @discardableResult func set(velocity: CGFloat) -> Self {
        self.velocity = velocity
        return self
    }
    
    // MARK: animate
    @discardableResult func move(to: [CGFloat], then: Then?=nil) -> Self {
        var toFrame = self.animateView.frame
        if to.count > 2 {
            toFrame = CGRect(x: to[0], y: to[1], width: to[2], height: to[3])
        } else {
            toFrame.origin.x = to[0]
            toFrame.origin.y = to[1]
        }
        return move(with: toFrame, then: then)
    }
    
    @discardableResult func move(offset: [CGFloat], then: Then?=nil) -> Self {
        var toFrame = self.animateView.frame
        toFrame.origin.x += offset[0]
        toFrame.origin.y += offset[1]
        return move(with: toFrame, then: then)
    }
    
    @discardableResult func move(center: [CGFloat], then: Then?=nil) -> Self {
        var toFrame = self.animateView.frame
        toFrame.origin.x = center[0] - toFrame.size.width/2
        toFrame.origin.y = center[1] - toFrame.size.height/2
        return move(with: toFrame, then: then)
    }
    
    @discardableResult private func move(with toFrame: CGRect, then: Then?) -> Self {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let animations = {
                    self.animateView.frame = toFrame
                }
                let completion = { (isFinish: Bool) -> Void in
                    then?(self)
                }
                UIView.animate(withDuration: self.duration,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: animations, completion: completion)
            }
        }
        return self
    }
    
    @discardableResult func scale(to: [CGFloat], then: Then?=nil) -> Self {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let animations = {
                    self.animateView.layer.transform = CATransform3DMakeScale(to[0], to[1], 1)
                }
                let completion = { (isFinish: Bool) -> Void in
                    then?(self)
                }
                UIView.animate(withDuration: self.duration,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: animations, completion: completion)
            }
        }
        return self
    }
}
