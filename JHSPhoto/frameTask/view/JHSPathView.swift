//
//  JHSPathView.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/13.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class JHSPathView: JHSBaseView {
    var path: CGPath!
    var fillColor = UIColor.white;
    var strokColor = UIColor.white;
    
    override func initSubview() {
        contentMode = .redraw;
        backgroundColor = UIColor.clear;
        let mutablePath = CGMutablePath();
        mutablePath.addEllipse(in: bounds);
        path = mutablePath;
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect);
        let context = UIGraphicsGetCurrentContext();
        context?.addPath(path);
        context?.setFillColor(fillColor.cgColor);
        context?.fillPath();
        
        context?.addPath(path);
        context?.setStrokeColor(strokColor.cgColor);
        context?.strokePath();
        
        
    }
}
