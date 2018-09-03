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
        let x = cBtn.frame.origin.x
        let y = cBtn.frame.origin.y
        Animate(view: cBtn).set(duration: 2).move(to: [x+100,y+100])
        { animation in
            print(animation)
            let bounds = self.view.bounds
            animation.set(duration: 2).move(center: [bounds.midX,bounds.midY])
            { animation in
                animation.view.removeFromSuperview()
                self.cBtn = nil
            }
        }
    }

    @IBAction func tap(_ sender: Any) {
        Animate(view: btn)
            .set(duration: 2)
            .set(damping: 2)
            .scale(to: [2,2])
    }
    
}

