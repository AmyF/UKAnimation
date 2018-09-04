//
//  UKGroupAnimation.swift
//  UKAnimation
//
//  Created by unko on 2018/9/3.
//  Copyright © 2018年 unko. All rights reserved.
//

import UIKit


class UKGroupAnimation {
    
    
    deinit {
        #if DEBUG
        print("UKGroupAnimation[\(layer)] was deinit ")
        #endif
    }
    
    fileprivate let layer: CALayer
    fileprivate var animations: [CAAnimation] = []
    
    convenience init(view: UIView) {
        self.init(layer: view.layer)
    }
    
    init(layer: CALayer) {
        self.layer = layer
    }
    
    // MARK: Operation
    func run() {
        for animate in animations {
            layer.add(animate, forKey: nil)
        }
        animations.removeAll()
    }
    
    /// 将前面添加的CAAnimation组合成一个Group
    ///
    /// - Returns: self
    @discardableResult
    func group() -> Self {
        let group = CAAnimationGroup()
        group.animations = animations

        animations.removeAll()
        return add(animation: group)
    }
    
    /// 移除所有的动画，无论是否在运行
    ///
    /// - Returns: self
    @discardableResult
    func remove() -> Self {
        animations.removeAll()
        
        self.layer.removeAllAnimations()
        return self
    }
    
    
    /// 添加一个动画
    ///
    /// - Parameter animation: CAAnimation
    /// - Returns: self
    @discardableResult
    func add(animation: CAAnimation) -> Self {
        animations.append(animation)
        return self
    }
    
    
    @discardableResult
    func handler(begin: Item.Handler?=nil, end: Item.Handler?=nil) -> Self {
        animations.last?.delegate = Item(begin: begin, end: end)
        return self
    }
    
    @discardableResult
    func modify<A: CAAnimation>(aniamtion handler: (A?) -> Swift.Void) -> Self {
        handler(animations.last as? A)
        return self
    }
    
    // MARK: Setter
    class Item: NSObject, CAAnimationDelegate {
        deinit {
            print("AnimationItem[] was deinit")
        }
        
        typealias Handler = (_ anim: CAAnimation) -> Swift.Void
        
        let begin: Handler?
        let end: Handler?
        
        init(begin: Handler?, end: Handler?) {
            self.begin = begin
            self.end = end
        }
        
        func animationDidStart(_ anim: CAAnimation) {
            begin?(anim)
        }
        
        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            end?(anim)
        }
    }
    
}

// MARK: Animation
extension UKGroupAnimation {
    @discardableResult
    func fade(from: CGFloat, to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    func move(from: [CGFloat]?=nil, to: [CGFloat], duration: CFTimeInterval=1) -> Self {
        let animation = CABasicAnimation(keyPath: "position")
        if let from = from { animation.fromValue = CGPoint(x: from[0], y: from[1]) }
        animation.toValue = CGPoint(x: to[0], y: to[1])
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    func move(from: CGFloat?=nil, x to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    func move(from: CGFloat?=nil, y to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    func move(from: [CGFloat]?=nil, offset to: [CGFloat], duration: CFTimeInterval=1) -> Self {
        let to = [
            (layer.presentation()?.frame.origin.x ?? layer.frame.origin.x) + to[0],
            (layer.presentation()?.frame.origin.y ?? layer.frame.origin.y) + to[1],
        ]
        return move(from: from, to: to, duration: duration)
    }
    
    @discardableResult
    func move(from: CGFloat?=nil, offsetX to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let x = (layer.presentation()?.frame.origin.x ?? layer.frame.origin.x) + to
        return move(from: from, x: x, duration: duration)
    }
    
    @discardableResult
    func move(from: CGFloat?=nil, offsetY to: CGFloat, duration: CFTimeInterval=1) -> Self {
        let y = (layer.presentation()?.frame.origin.y ?? layer.frame.origin.y) + to
        return move(from: from, y: y, duration: duration)
    }
}
