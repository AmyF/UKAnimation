//
//  UKAnimation.swift
//  UKAnimation
//
//  Created by unko on 2018/9/3.
//  Copyright © 2018年 unko. All rights reserved.
//

import UIKit


public class UKAnimation {
    deinit {
        #if DEBUG
        print("UKGroupAnimation[\(layer)] was deinit ")
        #endif
    }
    
    fileprivate let layer: CALayer
    fileprivate var animations: [CAAnimation] = []
    
    public convenience init(_ view: UIView) {
        self.init(view.layer)
    }
    
    public init(_ layer: CALayer) {
        self.layer = layer
    }
    
    // MARK: Operation
    public func run() {
        for animate in animations {
            layer.add(animate, forKey: nil)
        }
        animations.removeAll()
    }
    
    /// 将前面添加的CAAnimation组合成一个Group
    ///
    /// - Returns: self
    @discardableResult
    public func group() -> Self {
        let group = CAAnimationGroup()
        group.animations = animations
        
        animations.removeAll()
        return add(animation: group)
    }
    
    /// 添加一个动画
    ///
    /// - Parameter animation: CAAnimation
    /// - Returns: self
    @discardableResult
    public func add(animation: CAAnimation) -> Self {
        animations.append(animation)
        return self
    }
    
    @discardableResult
    public func add(animation handler: (CALayer) -> CAAnimation) -> Self {
        animations.append(handler(layer))
        return self
    }
    
    /// 遍历当前动画
    ///
    /// - Returns: 是否继续遍历
    @discardableResult
    public func forEach(handler: (CALayer, CAAnimation) -> Bool) -> Self {
        for anim in animations {
            if handler(layer,anim) { break }
        }
        return self
    }
    
    @discardableResult
    public func handler(begin: Item.Handler?=nil, end: Item.Handler?=nil) -> Self {
        animations.last?.delegate = Item(begin: begin, end: end)
        return self
    }
    
    @discardableResult
    public func modify<A: CAAnimation>(aniamtion handler: (A?) -> Swift.Void) -> Self {
        handler(animations.last as? A)
        return self
    }
    
    @discardableResult
    public func stay() -> Self {
        if let anim = animations.last {
            anim.fillMode = kCAFillModeForwards
            anim.isRemovedOnCompletion = false
        }
        return self
    }
    
    @discardableResult
    public func duration(_ duration: CFTimeInterval) -> Self {
        animations.last?.duration = duration
        return self
    }
    
    @discardableResult
    public func after(begin offset: CFTimeInterval, willGroup: Bool=false) -> Self {
        if willGroup {
            animations.last?.beginTime = offset
        } else {
            animations.last?.beginTime = CACurrentMediaTime() + offset
        }
        
        return self
    }
    
    // MARK: Setter
    public class Item: NSObject, CAAnimationDelegate {
        deinit {
            print("AnimationItem[] was deinit")
        }
        
        public typealias Handler = (_ anim: CAAnimation) -> Swift.Void
        
        let begin: Handler?
        let end: Handler?
        
        init(begin: Handler?, end: Handler?) {
            self.begin = begin
            self.end = end
        }
        
        public func animationDidStart(_ anim: CAAnimation) {
            begin?(anim)
        }
        
        public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            end?(anim)
        }
    }
    
}

// MARK: Animation
public extension UKAnimation {
    @discardableResult
    public func fade(from: CGFloat, to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    public func move(from: [CGFloat]?=nil, to: [CGFloat], duration: CFTimeInterval=1) -> Self {
        let animation = CABasicAnimation(keyPath: "position")
        if let from = from { animation.fromValue = CGPoint(x: from[0], y: from[1]) }
        animation.toValue = CGPoint(x: to[0], y: to[1])
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    public func move(from: CGFloat?=nil, x to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    public func move(from: CGFloat?=nil, y to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    public func move(from: [CGFloat]?=nil, offset to: [CGFloat], duration: CFTimeInterval=1) -> Self {
        let to = [
            (layer.presentation()?.frame.origin.x ?? layer.frame.origin.x) + to[0],
            (layer.presentation()?.frame.origin.y ?? layer.frame.origin.y) + to[1],
            ]
        return move(from: from, to: to, duration: duration)
    }
    
    @discardableResult
    public func move(from: CGFloat?=nil, offsetX to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let x = (layer.presentation()?.frame.origin.x ?? layer.frame.origin.x) + to
        return move(from: from, x: x, duration: duration)
    }
    
    @discardableResult
    public func move(from: CGFloat?=nil, offsetY to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let y = (layer.presentation()?.frame.origin.y ?? layer.frame.origin.y) + to
        return move(from: from, y: y, duration: duration)
    }
}

extension UKAnimation {
    @discardableResult
    public func flip(v: Bool, duration: CFTimeInterval=1) -> Self {
        if v {
            let anim = CABasicAnimation(keyPath: "transform.rotation.x")
            anim.toValue = Double.pi
            anim.duration = duration
            return add(animation: anim)
        } else {
            let anim = CABasicAnimation(keyPath: "transform.rotation.y")
            anim.toValue = Double.pi
            anim.duration = duration
            return add(animation: anim)
        }
    }
    
    @discardableResult
    public func shakeR(radian: Double=5, times: Float=3,duration: CFTimeInterval=0.4) -> Self {
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.values = [(radian/180 * Double.pi),
                       (-radian/180 * Double.pi),
                       (radian/180 * Double.pi)]
        anim.repeatCount = times
        anim.duration = duration / Double(times)
        return add(animation: anim)
    }
    
    @discardableResult
    public func shakeX(range: Int=5,times: Float=3,duration: CFTimeInterval=0.4) -> Self {
        let anim = CAKeyframeAnimation(keyPath: "transform.translation.x")
        anim.values = [range,-range,range]
        anim.repeatCount = times
        anim.duration = duration / Double(times)
        return add(animation: anim)
    }
    
    @discardableResult
    public func shakeY(range: Int=5,times: Float=3,duration: CFTimeInterval=0.4) -> Self {
        let anim = CAKeyframeAnimation(keyPath: "transform.translation.y")
        anim.values = [range,-range,range]
        anim.repeatCount = times
        anim.duration = duration / Double(times)
        return add(animation: anim)
    }
}
