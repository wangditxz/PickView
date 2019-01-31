//
//  PickView.swift
//  DateComponent
//
//  Created by 王迪 on 2019/1/30.
//  Copyright © 2019 王迪. All rights reserved.
//

import UIKit

class PickView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    let kPickerViewComponentH = 38.0;
    lazy var backgroundView: UIView = {
        let view = UIView(frame: self.bounds);
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4);
        view.alpha = 0;
        return view;
    }();
    lazy var alertView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.bounds.height * 0.5, width: self.bounds.width, height: self.bounds.height * 0.5));
        view.backgroundColor = UIColor.white;
        return view;
    }();
    lazy var pickerView: UIPickerView = {
        let pickView = UIPickerView();
        pickView.dataSource = self;
        pickView.delegate = self;
        return pickView;
    }();
    var dataArray: [String];
    init(frame: CGRect, dataArray: [String]) {
        self.dataArray = dataArray;
        super.init(frame: frame);
        
        self.pickerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width * 0.5);
        self.pickerView.center = self.convert(self.alertView.center, to: self.alertView);
        self.backgroundView.addSubview(self.alertView);
        self.alertView.addSubview(self.pickerView);
        self.addSubview(self.backgroundView);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = Array(touches).first;
        let point = touch?.location(in: self.backgroundView);
        if !self.alertView.frame.contains(point!) {
            self.dismiss();
        }
    }
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0.0;
        }) { (isEnd) in
            self.removeFromSuperview();
        };
    }
    func show() {
        OperationQueue.main.addOperation {
            let frontWindows = UIApplication.shared.windows.enumerated();
            for (_, element) in frontWindows {
                let a = element.screen == UIScreen.main;
                let b = !(element.isHidden) && (element.alpha) > CGFloat(0);
                let c = element.windowLevel == UIWindow.Level.normal;
                if a && b && c {
                    element.addSubview(self);
                    break;
                }
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.backgroundView.alpha = 1.0;
            }, completion: nil);
        };
    }
    //MARK: - 代理方法
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(kPickerViewComponentH);
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataArray.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataArray[row];
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel;
        if label == nil {
            label = UILabel();
            label?.textAlignment = .center;
            label?.backgroundColor = UIColor.clear;
            label?.textColor = UIColor.red;
            label?.font = UIFont.systemFont(ofSize: 16);
        }
        label?.text = self.dataArray[row];
        setSpearatorLineColor();
        return label!;
    }
    //MARK: - 设置自定义样式
    func setSpearatorLineColor() {
        self.pickerView.subviews.forEach { (subView) in
            if subView.frame.height < 1 {
                subView.backgroundColor = UIColor.orange;
            } else {
                subView.subviews.forEach({ (subView) in
                    if subView.isKind(of: NSClassFromString("UIPickerColumnView")!.self) {
                        subView.subviews.forEach({ (subView) in
                            if subView.frame.height == CGFloat(kPickerViewComponentH + 2.0) {
                                subView.backgroundColor = UIColor.blue;
                                self.setSubViewLabelStyle(view: subView);
                            }
                        })
                    }
                })
            }
        }
    }
    func setSubViewLabelStyle(view: UIView) {
        if view.isKind(of: UILabel.self) {
            (view as! UILabel).textColor = UIColor.white;
            return;
        }
        view.subviews.forEach { (subView) in
            setSubViewLabelStyle(view: subView);
        }
    }
}
