//
//  ViewController.swift
//  DateComponent
//
//  Created by 王迪 on 2019/1/30.
//  Copyright © 2019 王迪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dataArray = ["北京", "上海", "天津", "青岛", "洛阳", "南京", "杭州", "苏州"];
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: .custom);
        btn.setTitle("我是按钮", for: .normal);
        btn.frame = CGRect(x: 100, y: 88, width: 100, height: 50);
        btn.backgroundColor = UIColor.purple;
        btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside);
        self.view.addSubview(btn);
    }
    
    @objc func clickBtn(sender: UIButton) {
        let pickView = PickView(frame: self.view.bounds, dataArray: dataArray);
        pickView.show();
    }

}

