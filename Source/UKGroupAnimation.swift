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
        print("UKGroupAnimation<\(layer)> was deinit \n")
        #endif
    }
    
    fileprivate let layer: CALayer
    fileprivate var animations: [CAAnimation] = []
    fileprivate var animationItems: [CAAnimation:Item] = [:]
    
    fileprivate var removedOnCmp: Bool = true
    fileprivate var duration: CFTimeInterval = 1
    fileprivate var timingFuncitons : [CAMediaTimingFunction] = [
        CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    ]
    
    init(view: UIView) {
        self.layer = view.layer
    }
    
    init(layer: CALayer) {
        self.layer = layer
    }
    
    // MARK:
    @discardableResult
    func run(name: String="default") -> Self {
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = duration
        
        layer.add(group, forKey: name)
        return self
    }
    
    @discardableResult
    func remove() -> Self {
        self.layer.removeAllAnimations()
        return self
    }
    
    @discardableResult
    func add(animation: CAAnimation) -> Self {
        animation.isRemovedOnCompletion = removedOnCmp
        animations.append(animation)
        return self
    }
    
    func afterEnd(_ item: Item) -> Self {
        if let last = animations.last {
            last.delegate = item
//            animationItems[last] = item
            item.group = self
        }
        return self
    }
    
    func recent(handler: (CAAnimation) -> Swift.Void) -> Self {
        if let animation = animations.last { handler(animation) }
        return self
    }
    
    // MARK: Setter
    @discardableResult
    func set(duration: CFTimeInterval) -> Self {
        self.duration = duration
        return self
    }
    
    @discardableResult
    func set(timingFuncitons: [CAMediaTimingFunction]) -> Self {
        self.timingFuncitons = timingFuncitons
        return self
    }
    
    // MARK: Animation
    @discardableResult
    func fade(from: CGFloat, to: CGFloat) -> Self {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = from
        animation.toValue = to
        animation.timingFunction = timingFuncitons.first
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    func move(from: [CGFloat]?=nil, to: [CGFloat]) -> Self {
        let animation = CABasicAnimation(keyPath: "position")
        if let from = from { animation.fromValue = CGPoint(x: from[0], y: from[1]) }
        animation.toValue = CGPoint(x: to[0], y: to[1])
        animation.timingFunction = timingFuncitons.first
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    @discardableResult
    func move(from: CGFloat?=nil, x to: CGFloat) -> Self {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = from
        animation.toValue = to
        animation.timingFunction = timingFuncitons.first
        animation.duration = duration
        
        return add(animation: animation)
    }
    
    
    class Item: NSObject, CAAnimationDelegate {
        deinit {
            print("AnimationItem was deinit")
        }
        
        typealias EndHandler = () -> Swift.Void
        
        let end: EndHandler
        
        weak var group: UKGroupAnimation?
        
        init(end: @escaping EndHandler) {
            self.end = end
        }
        
        func animationDidStart(_ anim: CAAnimation) {
            print("animation begin")
        }
        
        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            end()
            group = nil
        }
    }
    
}

