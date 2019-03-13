//
//  JHSPhotoModel.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/11.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import Photos

class JHSPhotoModel: NSObject {
    // 相册
    var collecion: PHAssetCollection! {
        didSet{
            if collecion == nil {
                return;
            }
            results = PHAsset.fetchAssets(in: collecion, options: nil);
        }
    }

    var results: PHFetchResult<PHAsset>!
    var count: Int {
        return results?.count ?? 0;
    }
    var countAttrbute: NSAttributedString {
        let attrbute = NSMutableAttributedString(string: photoName + "\n" + "\(count)");
        attrbute.addAttributes([NSAttributedString.Key.font:UIFont.fitSize(size: 12),NSAttributedString.Key.foregroundColor:UIColor.gray], range: NSRange.init(location: photoName.count, length: attrbute.length - photoName.count));
        return attrbute;
    }
    var photoName: String {
        return collecion.localizedTitle ?? "";
    }
    func fetchImage(index: Int,size: CGSize,finished:@escaping ((_ image: UIImage?) -> Void)) -> Void {

        if results == nil || results.count <= index {
            finished(nil);
            return;
        }
        let asset = results.object(at: index);
        let dispath = DispatchQueue(label: "fetch_image");
        dispath.async {
            let options = PHImageRequestOptions();
            options.isSynchronous = true;
            PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: size.width, height: size.height), contentMode: PHImageContentMode.default, options: options) { (image, dict) in
                DispatchQueue.main.async {
                    finished(image);
                }
            };
        }
    }
    
    var selectRow: [Int]!
    

}

