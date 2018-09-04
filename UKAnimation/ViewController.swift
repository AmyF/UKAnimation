//
//  ViewController.swift
//  UKAnimation
//
//  Created by unko on 2018/9/3.
//  Copyright © 2018年 unko. All rights reserved.
//

import UIKit

class CustomBtn: UIButton {
    deinit {
        print("jojo")
    }
}

class ViewController: UIViewController {

    typealias Animate = UKAnimation
    typealias GroupAnimate = UKGroupAnimation
    
    @IBOutlet weak var btn: UIButton!
    
    var cBtn: CustomBtn! = CustomBtn(frame: CGRect(x: 100, y: 200, width: 60, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btn.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        btn.backgroundColor = .red
        
        cBtn.backgroundColor = .green
        cBtn.addTarget(self, action: #selector(cBtnMove), for: .touchUpInside)
        self.view.addSubview(cBtn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cBtnMove() {
        GroupAnimate(view: cBtn)
            .fade(from: 1, to: 0.3)
            .modify
            {
                guard let anim = $0 else {return}
                anim.fillMode = kCAFillModeForwards
                anim.isRemovedOnCompletion = false
                print(anim.duration,anim.beginTime)
            }
            .move(offsetX: 150)
            .modify
            {
                guard let anim = $0 else {return}
                anim.fillMode = kCAFillModeForwards
                anim.isRemovedOnCompletion = false
                print(anim.duration,anim.beginTime)
            }
            .group()
            .modify
            {
                guard let anim = $0 else {return}
                anim.fillMode = kCAFillModeForwards
                anim.isRemovedOnCompletion = false
                print(anim.duration,anim.beginTime)
            }
            .run()
    }

    @IBAction func tap(_ sender: Any) {
        let v1 = UIView(frame: CGRect(x: 50, y: 300, width: 60, height: 60))
        v1.backgroundColor = .blue
        self.view.addSubview(v1)
        let v2 = UIView(frame: CGRect(x: 150, y: 300, width: 60, height: 60))
        v2.backgroundColor = .orange
        self.view.addSubview(v2)
        animate1(view: v1)
        animate2(view: v2)
    }
    
    func animate1(view: UIView) {
        Animate(view: view)
            .set(duration: 4)
            .set(damping: 4)
            .set(velocity: 5)
            .scale(to: [2,2])
            .move(offset: [50,50])
    }
    
    func animate2(view: UIView) {
        Animate(view: view)
            .set(duration: 4)
            .set(damping: 4)
            .set(velocity: 5)
            .scale(to: [2,2])
            .move(offset: [50,50])
            .after(1) { (animate) in
                animate.stop()
        }
    }
}

