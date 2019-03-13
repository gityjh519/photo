//
//  JHSPhotoTableController.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/12.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import Photos

class JHSPhotoTableController: JHSBaseViewController {

    
    var photoManger = JHSAssetManger();
    var maxCount = 10; // 最多选择的张数 默认是10个
    var finished:((_ list: [UIImage]) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoManger.changeObserver = self;
        createTable(delegate: self);
        baseTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
    }

    

    // MAEK: - table view delegate implement
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = JHSAssetModelType(rawValue: section)!
        return photoManger.model[type]?.count ?? 0;

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        let type = JHSAssetModelType(rawValue: indexPath.section)!
        let list = photoManger.model[type];
        let itemModel = list?[indexPath.row];
        cell.textLabel?.text = itemModel?.title;
      
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ctrl = JHSPhotoController();
        let type = JHSAssetModelType(rawValue: indexPath.section)!
        let list = photoManger.model[type];
        ctrl.itemModel = list?[indexPath.row];
        ctrl.manger = photoManger;
        ctrl.finishedDone = finished;
        navigationController?.pushViewController(ctrl, animated: true);
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["所有", "智能", "用户"];
        return titles[section];
    }

}

extension JHSPhotoTableController: JHSAssetMangerDelegate {
    func assetManger(manger: JHSAssetManger, operation: JHSOperation) {
        if operation.operation == .smartAlbum {
            baseTable.reloadSections(section: 1);
        }
        if operation.operation == .userCollection {
            baseTable.reloadSections(section: 2);
        }
    }
    
    
}


