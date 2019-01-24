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
        "group":#selector(group)
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
        animView.uk.anim.shakeR().run()
    }
    
    @objc func shakeX() {
        animView.uk.anim.shakeX().run()
    }
    
    @objc func shakeY() {
        animView.uk.anim
            .shakeY()
            .handler(begin: {print($0)}, end: {print($0)})
            .modify{print($0 ?? "")}
            .change(key: "new_name_shakeY")
            .modify{print($0 ?? "")}
            .run()
    }
    
    @objc func flip() {
        Animation(animView).flip(v: true).duration(0.3).run()
    }
    
    @objc func move() {
        Animation(animView).move(to: [100,100]).modify{$0?.autoreverses = true}.run()
    }
    
    @objc func fade() {
        Animation(animView).fade(from: 1, to: 0).modify{$0?.autoreverses = true}.run()
    }
    
    @objc func group() {
        Animation(animView)
            .move(to: [100,100]).stay()
            .fade(from: 1, to: 0).modify{$0?.autoreverses = true}.stay()
            .move(to: [300,200]).after(begin: 1, willGroup: true).stay()
            .shakeR(radian:10, times:4, duration:0.5).after(begin: 1.5, willGroup: true)
            .forEach {print($0,$1,$2); return true}
            .group().duration(2).modify{$0?.autoreverses = true}
            .change(key: "group_01")
            .forEach {print($0,$1,$2); return true}
            .run()
    }
    
}

