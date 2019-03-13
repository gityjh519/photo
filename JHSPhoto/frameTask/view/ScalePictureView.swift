//
//  ScalePictureView.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/11.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class ScalePictureView: JHSBaseView,UIScrollViewDelegate {

    private var contentView: UIScrollView!
    
    var image: UIImage! {
        didSet{
            baseImageView.image = image;
        }
    }
    
    override func initSubview() {
        baseImageView = UIImageView(frame: bounds);
        baseImageView.contentMode = .scaleAspectFit;
        
        contentView = UIScrollView(frame: bounds);
        addSubview(contentView);
        contentView.maximumZoomScale = 4;
        contentView.minimumZoomScale = 1;
        contentView.delegate = self;
        contentView.addSubview(baseImageView);
        contentView.showsVerticalScrollIndicator = false;
        contentView.showsHorizontalScrollIndicator = false;
        if #available(iOS 11.0, *) {
            contentView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func resetScale() -> Void {
        contentView.zoomScale = 1;
    }
   
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return baseImageView;
    }

}
