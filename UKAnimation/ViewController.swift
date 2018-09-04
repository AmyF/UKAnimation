//
//  ViewController.swift
//  UKAnimation
//
//  Created by unko on 2018/9/3.
//  Copyright © 2018年 unko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    typealias Animation = UKAnimation
    
    let actions: [String:Selector] = [
        "shakeR":#selector(shakeR),
        "shakeX":#selector(shakeX),
        "shakeY":#selector(shakeY),
        "flip":#selector(flip),
        "move":#selector(move),
        "fade":#selector(fade),
        "group":#selector(group),
    ]
    
    let animView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    let stackView = UIStackView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 40 - 60,
                                              width: UIScreen.main.bounds.width, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        animView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        animView.backgroundColor = .green
        
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.axis = .horizontal
        
        for (name, sel) in actions {
            let btn = UIButton(type: .custom)
            btn.backgroundColor = .red
            btn.setTitleColor(.white, for: .normal)
            btn.setTitle(name, for: .normal)
            btn.addTarget(self, action: sel, for: .touchUpInside)
            stackView.addArrangedSubview(btn)
        }
        
        self.view.addSubview(animView)
        self.view.addSubview(stackView)
    }
    
    @objc func shakeR() {
        Animation(view: animView).shakeR().run()
    }
    
    @objc func shakeX() {
        Animation(view: animView).shakeX().run()
    }
    
    @objc func shakeY() {
        Animation(view: animView).shakeY().run()
    }
    
    @objc func flip() {
        Animation(view: animView).flip(v: true).run()
    }
    
    @objc func move() {
        Animation(view: animView).move(to: [100,100]).modify{$0?.autoreverses = true}.run()
    }
    
    @objc func fade() {
        Animation(view: animView).fade(from: 1, to: 0).modify{$0?.autoreverses = true}.run()
    }
    
    @objc func group() {
        Animation(view: animView)
            .move(to: [100,100]).stay()
            .fade(from: 1, to: 0).modify{$0?.autoreverses = true}.stay()
            .move(to: [300,400]).after(begin: 1, willGroup: true).stay()
            .shakeR(radian:10, times:4, duration:0.5).after(begin: 1.5, willGroup: true)
            .group().duration(2).modify{$0?.autoreverses = true}
            .run()
    }
    
}

