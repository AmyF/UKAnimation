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
    fileprivate var animations: [(key:String,value:CAAnimation)] = []
    
    public convenience init(_ view: UIView) {
        self.init(view.layer)
    }
    
    public init(_ layer: CALayer) {
        self.layer = layer
    }
    
    fileprivate func getNewKey(with key:String?=nil) -> String {
        return key ?? "unko_anim_\(animations.count)"
    }
    
    // MARK: Operation
    public func run() {
        for animate in animations {
            layer.add(animate.value, forKey: animate.key)
        }
        animations.removeAll()
    }
    
    /// 将前面添加的CAAnimation组合成一个Group
    ///
    /// - Returns: self
    @discardableResult
    public func group() -> Self {
        let group = CAAnimationGroup()
        group.animations = animations.compactMap {$0.value}
        
        animations.removeAll()
        return add(animation: group)
    }
    
    /// 添加一个动画
    ///
    /// - Parameter animation: CAAnimation
    /// - Returns: self
    @discardableResult
    public func add(key: String?=nil, animation: CAAnimation) -> Self {
        animations.append((key: getNewKey(with: key), value: animation))
        return self
    }
    
    /// 通过handler添加一个动画
    ///
    /// - Parameter handler: handler返回一个CAAnimation
    /// - Returns: self
    @discardableResult
    public func add(key: String?=nil, animation handler: (CALayer) -> CAAnimation) -> Self {
        animations.append((key: getNewKey(with: key), value: handler(layer)))
        return self
    }
    
    /// 遍历当前动画
    ///
    /// - Returns: 是否继续遍历
    @discardableResult
    public func forEach(handler: (_ layer:CALayer,_ key: String,_ anim: CAAnimation) -> Bool) -> Self {
        for anim in animations {
            if handler(layer,anim.key, anim.value) { break }
        }
        return self
    }
    
    /// CAAnimationDelegate 的回调
    ///
    /// - Parameters:
    ///   - begin: animationDidStart
    ///   - end: animationDidStop
    /// - Returns: self
    @discardableResult
    public func handler(begin: Item.Handler?=nil, end: Item.Handler?=nil) -> Self {
        animations.last?.value.delegate = Item(begin: begin, end: end)
        return self
    }
    
    /// 修改最后一个加入的动画
    ///
    /// - Parameter handler: 修改回调立即执行
    /// - Returns: self
    @discardableResult
    public func modify<A: CAAnimation>(aniamtion handler: (A?) -> Swift.Void) -> Self {
        handler(animations.last?.value as? A)
        return self
    }
    
    @discardableResult
    public func change(key: String) -> Self {
        if let anim = animations.last?.value {
            animations.removeLast()
            animations.append((key: key, value: anim))
        }
        return self
    }
    
    /// 让动画结束后仍然保持
    ///
    /// - Returns: self
    @discardableResult
    public func stay() -> Self {
        if let anim = animations.last?.value {
            anim.fillMode = kCAFillModeForwards
            anim.isRemovedOnCompletion = false
        }
        return self
    }
    
    /// 修改最后一个动画的持续时间
    ///
    /// - Parameter duration: CFTimeInterval
    /// - Returns: self
    @discardableResult
    public func duration(_ duration: CFTimeInterval) -> Self {
        animations.last?.value.duration = duration
        return self
    }
    
    /// 修改最后一个动画在多久以后执行
    ///
    /// - Parameters:
    ///   - offset: 多久以后
    ///   - willGroup: 之后这个动画是否会加入group
    ///     特别注意，未加入Group的动画，beginTime默认从CACurrentMediaTime开始计算，
    ///     动画在加入Group后，beginTime属性计数是从0开始。
    /// - Returns: self
    @discardableResult
    public func after(begin offset: CFTimeInterval, willGroup: Bool=false) -> Self {
        if willGroup {
            animations.last?.value.beginTime = offset
        } else {
            animations.last?.value.beginTime = CACurrentMediaTime() + offset
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

/// 你可以用这个类来创建 并得到单个或者一系列动画
public class UKNoAnimation: UKAnimation {
    
    init() {
        super.init(CALayer())
    }
    
    public override func run() {
        fatalError("UKNoAnimation dont want to run")
    }
    
    public func animation(by key: String) -> CAAnimation? {
        for (mykey,myValue) in animations {
            if mykey == key {
                return myValue
            }
        }
        return nil
    }
    
    public func allAnimation() -> [(key:String,value:CAAnimation)] {
        return animations
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
