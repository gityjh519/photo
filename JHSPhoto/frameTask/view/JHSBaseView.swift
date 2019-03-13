//
//  JHSBaseView.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/11.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class JHSBaseView: UIView {
    
    var baseImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame);
        initSubview();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initSubview() -> Void {
        
    }

}
