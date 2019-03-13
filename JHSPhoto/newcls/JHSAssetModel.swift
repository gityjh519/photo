//
//  JHSAssetModel.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/12.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import Foundation
import Photos

enum JHSAssetModelType: Int {
    case image
    case smart
    case collection
}

class JHAassetModel{
    private var assetList: [JHSAssetModelType:[JHSAssetItemModel]]!;
    init() {
        assetList = [JHSAssetModelType:[JHSAssetItemModel]]();
    }
    func addItemModel(model: JHSAssetItemModel) -> Void {
        var list = assetList[model.type] ?? [JHSAssetItemModel]();
        list.append(model);
        assetList[model.type] = list;
    }
    func resetType(type: JHSAssetModelType) -> Void {
        assetList.removeValue(forKey: type);
    }
    subscript(type: JHSAssetModelType) -> [JHSAssetItemModel]? {
        return assetList[type];
    }
    func resetAssetList() -> Void {
        assetList.removeAll();
    }
    
}

class JHSAssetItemModel: NSObject {

    var type = JHSAssetModelType.image;
    
    var results: PHFetchResult<PHAsset>!
    var collection: PHAssetCollection!
    
    var chachesImage = [String:UIImage]();
    
    var title = "";
    var count: Int {
        return results?.count ?? 0;
    }
    
    private override init() {
        super.init();
    }
    convenience init(collection: PHCollection,type: JHSAssetModelType = JHSAssetModelType.image) {
        self.init();
        if let asset = collection as? PHAssetCollection {
            title = asset.localizedTitle ?? "";
            results = PHAsset.fetchAssets(in: asset, options: nil);
            self.collection = asset;
        }
        self.type = type;
    }
    
    convenience init(asset: PHFetchResult<PHAsset>) {
        self.init();
        title = "全部照片";
        results = asset;
    }

    
    func fetchImage(index: Int,size: CGSize,finished:@escaping ((_ image: UIImage?) -> Void)) -> Void {
        
        
        let key = NSStringFromRange(NSRange(location: size.width.intValue, length: size.height.intValue)) + "\(index)" + (collection?.localIdentifier ?? "");
        
        if let img = chachesImage[key] {
            finished(img);
            return;
        }
        
        if results == nil || count <= index {
            finished(nil);
            return;
        }
        let asset = results.object(at: index);
        let dispath = DispatchQueue(label: "fetch_image");
        dispath.async {
            let options = PHImageRequestOptions();
            options.isSynchronous = true;
            PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: size.width, height: size.height), contentMode: PHImageContentMode.default, options: options) { (image, dict) in
                self.chachesImage[key] = image;
                DispatchQueue.main.async {
                    finished(image);
                }
            };
        }
    }
    
}
