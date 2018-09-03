//
//  UKAnimation.swift
//  UKAnimation
//
//  Created by unko on 2018/9/3.
//  Copyright © 2018年 unko. All rights reserved.
//

import UIKit


class UKAnimation {
    
    #if DEBUG
    deinit {
        print("UKAnimation<\(animateView)> was deinit \n")
    }
    #endif
    
    typealias Then = (UKAnimation) -> Void
    
    fileprivate let animateView : UIView
    
    fileprivate var options     : UIViewAnimationOptions = [.curveLinear]
    fileprivate var duration    : TimeInterval = 1
    fileprivate var delay       : TimeInterval = 0
    fileprivate var damping     : CGFloat = 1
    fileprivate var velocity    : CGFloat = 1
    
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
    
    @discardableResult func after(_ time: TimeInterval, then: @escaping Then) -> Self {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            then(self)
        }
        return self
    }
    
    // MARK: Public Animate
    @discardableResult
    func move(to: [CGFloat], then: Then?=nil) -> Self {
        var toFrame = self.animateView.frame
        if to.count > 2 {
            toFrame = CGRect(x: to[0], y: to[1], width: to[2], height: to[3])
        } else {
            toFrame.origin.x = to[0]
            toFrame.origin.y = to[1]
        }
        return move(with: toFrame, then: then)
    }
    
    @discardableResult
    func move(offset: [CGFloat], then: Then?=nil) -> Self {
        var toFrame = self.animateView.frame
        toFrame.origin.x += offset[0]
        toFrame.origin.y += offset[1]
        return move(with: toFrame, then: then)
    }
    
    @discardableResult
    func move(center: [CGFloat], then: Then?=nil) -> Self {
        var toFrame = self.animateView.frame
        toFrame.origin.x = center[0] - toFrame.size.width/2
        toFrame.origin.y = center[1] - toFrame.size.height/2
        return move(with: toFrame, then: then)
    }
    
    @discardableResult
    func scale(to: [CGFloat], then: Then?=nil) -> Self {
        let scr = self.animateView.layer.transform
        var des: CATransform3D
        if to.count > 2 {
            des = CATransform3DScale(scr, to[0], to[1], to[2])
        } else {
            des = CATransform3DScale(scr, to[0], to[1], 1)
        }
        return change(transform: des, then: then)
    }
    
    @discardableResult
    func scale(to: CGFloat, then: Then?=nil) -> Self {
        let scr = self.animateView.layer.transform
        let des = CATransform3DScale(scr, to, to, 1)
        return change(transform: des, then: then)
    }
    
    enum Direction {
        case vertical,horizontal
    }
    @discardableResult
    func flip(_ direction: Direction = .horizontal, then: Then?=nil) -> Self {
        switch direction {
        case .horizontal:
            return scale(to: [-1,1], then: then)
        case .vertical:
            return scale(to: [1,-1], then: then)
        }
    }
    
    @discardableResult
    func fade(_ alpha: CGFloat, then: Then?=nil) -> Self {
        assert(Thread.isMainThread, "is not main thread")
        
        let animations = {
            self.animateView.alpha = alpha
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
        return self
    }
    
    @discardableResult
    func stop() -> Self {
        let nowT = self.animateView.layer.presentation()?.transform
        self.animateView.layer.removeAllAnimations()
        self.animateView.layer.transform = nowT ?? CATransform3DIdentity
        return self
    }
    
    @discardableResult
    func reset() -> Self {
        self.animateView.layer.removeAllAnimations()
        self.animateView.layer.transform = CATransform3DIdentity
        return self
    }
    
    // MARK: Private Animate
    @discardableResult
    fileprivate func move(with toFrame: CGRect, then: Then?) -> Self {
        assert(Thread.isMainThread, "is not main thread")
        
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
        return self
    }
    
    @discardableResult
    fileprivate func change(transform: CATransform3D, then: Then?) -> Self {
        assert(Thread.isMainThread, "is not main thread")
        
        let animations = {
            self.animateView.layer.transform = transform
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
        return self
    }
    
}
