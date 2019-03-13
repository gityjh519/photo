//
//  JHSPhtotManger.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/11.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import Photos

class JHSPhotoManger: NSObject ,PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        

  
        let detial = changeInstance.changeDetails(for: resultsd);
        print("result =\(detial),,\(detial?.changedObjects)");
        
    }
    
    // 获取 个人收藏的照片
    
    var assetCollecionList = [JHSPhotoModel]();
    static let `default` = JHSPhotoManger();
    var resultsd: PHFetchResult<PHAsset>!
    
    
    private override init() {
        super.init();
        PHPhotoLibrary.shared().register(self);
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self);
    }
    
    private func fetchCollection(finished:@escaping ((_ collectionList: [JHSPhotoModel]) -> Void)) -> Void {
        
        
        let dispatch = DispatchQueue(label: "label");
        let workItem = DispatchWorkItem {
            self.runlookPhoto();
        }
        dispatch.async(execute: workItem);
        workItem.notify(queue: DispatchQueue.main) {
            finished(self.assetCollecionList);
        }
        
    }
    
    private func runlookPhoto() -> Void {
        
        self.assetCollecionList.removeAll();
    
        
        let asset = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: nil);
        
        resultsd = PHAsset.fetchAssets(in: asset.firstObject!, options: nil);
    
        
        

        let cameraRolls = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil);
        

        cameraRolls.enumerateObjects { (item, idx, stop) in
            let model = JHSPhotoModel();
            model.collecion = item;
            if model.count > 0 {
                self.assetCollecionList.append(model);
            }
        }

        asset.enumerateObjects { (item, idx, stop) in
            let model = JHSPhotoModel();
            model.collecion = item;
            if model.count > 0 {
                self.assetCollecionList.append(model);
            }
        }
    }
    
}

extension JHSPhotoManger {
    
    class func fetchAlbum(finished:@escaping ((_ collectionList: [JHSPhotoModel]) -> Void)) -> Void {
        JHSPhotoManger.default.fetchCollection(finished: finished);
    }
    
    class func requestAuthorization(finished:((_ collectionList: [JHSPhotoModel]) -> Void)?) -> Void {
        PHPhotoLibrary.requestAuthorization { (statues) in
            if [PHAuthorizationStatus.denied,PHAuthorizationStatus.restricted].contains(statues) {
                showAlertView();
            }else if statues == PHAuthorizationStatus.authorized {
                if let done = finished {
                    fetchAlbum(finished: done);
                }
            }
        }
        
    }
    
    private class func showAlertView() -> Void {
        
        guard let topCtrl = UIApplication.shared.topViewController() else{
            return;
        }
        
        let alertCtrl = UIAlertController(title: "访问相册", message: "请您在设置中打开相册权限", preferredStyle: .alert);
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        };
        let config = UIAlertAction(title: "确定", style: .destructive) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly:UIApplication.OpenURLOptionsKey.sourceApplication], completionHandler: { (finished) in
                    
                })
            }
        };
        alertCtrl.addAction(cancel);
        alertCtrl.addAction(config);
        
        topCtrl.present(alertCtrl, animated: true) {
            
        };
    }
    
}
