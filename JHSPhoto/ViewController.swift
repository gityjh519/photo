//
//  ViewController.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/11.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit

class ViewController: JHSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let label = UILabel(frame: view.bounds);
        addSubview(subView: label);
        label.text = "打开相册";
        label.numberOfLines = 0;
        label.textAlignment = .center;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);        JHSPhotoManger.requestAuthorization(finished: nil);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ctrl = JHSPhotoTableController();
        ctrl.finished = {
            (list: [UIImage]) in
            print("list =\(list)");
        }
        let navictrl = UINavigationController(rootViewController: ctrl);
        self.present(navictrl, animated: true) {
            
        };
    }

    

}

