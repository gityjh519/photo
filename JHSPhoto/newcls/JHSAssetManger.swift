//
//  JHSAssetManger.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/12.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import Photos

enum JHSAssetOperationType {
    case defalt
    case remove
    case insert
    case changed
    case reload
    
    case userCollection
    case smartAlbum
    case allPhoto
}

protocol JHSAssetMangerDelegate:NSObjectProtocol {
    func assetManger(manger: JHSAssetManger,operation: JHSOperation) -> Void
}

class JHSAssetManger: NSObject {
    
    weak var changeObserver: JHSAssetMangerDelegate?

    private var allPhoto: PHFetchResult<PHAsset>! // 所有照片
    private var smartALbums: PHFetchResult<PHAssetCollection>! // 智能相册集
    private var userCollecions: PHFetchResult<PHCollection>! // 用户自定相册集和
    
    var model = JHAassetModel();
    
    override init() {
        super.init();
        
        model.resetAssetList();
        
        let allOptions = PHFetchOptions();
        allOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)];
        allPhoto = PHAsset.fetchAssets(with: allOptions);
        let item = JHSAssetItemModel(asset: allPhoto);
        if item.count > 0 {
            model.addItemModel(model: item);
        }
        

        
        smartALbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil);
        
        smartALbums.enumerateObjects { (collection, idx, stop) in
            let item = JHSAssetItemModel(collection: collection, type: .smart);
            if item.count > 0 {
                self.model.addItemModel(model: item);
            }
        }
        
        userCollecions = PHCollectionList.fetchTopLevelUserCollections(with: nil);
        userCollecions.enumerateObjects { (collection, idx, stop) in
            let item = JHSAssetItemModel(collection: collection, type: .collection);
            if item.count > 0 {
                self.model.addItemModel(model: item);
            }
        }
        
        PHPhotoLibrary.shared().register(self);
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self);
    }
    
}

extension JHSAssetManger {
    // 添加一个文件夹
    func addAlbumToPhoto(name: String,finished:((_ success: Bool,_ withError: JHSError?) -> Void)?) -> Void {
        if name.isEmpty {
            finished?(true,JHSError(code: 1, description: "文件的名字为空"));
            return;
        }
        PHPhotoLibrary.shared().performChanges({
            
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name);
        }) { (tempsuccess, error) in
            if tempsuccess{
                finished?(true,nil);
            }else{
                finished?(false,JHSError(code: -1, description: "Error creating album"));
            }
            
        }
    }
    //    添加一个图片 到指定的 文件夹
    func addImageToAlbum(image: UIImage,collection: PHAssetCollection,finished:((_ success: Bool,_ withError: JHSError?) -> Void)?) -> Void {
        
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image);
            let asset = PHAssetCollectionChangeRequest(for: collection);
            asset?.addAssets([request.placeholderForCreatedAsset] as NSFastEnumeration)
        }) { (isOk, error) in
            if isOk {
                finished?(true,nil);
            }else{
                finished?(false,JHSError(code: -1, description: "Error creating album"));
            }
        }
    }
    
    func deleteURL(removeAsset: [PHAsset],collection:PHAssetCollection?) -> Void {

        PHPhotoLibrary.shared().performChanges({
            if let sel = collection {
                let request = PHAssetCollectionChangeRequest(for: sel);
                request?.removeAssets(removeAsset as NSFastEnumeration);
            }else {
                PHAssetChangeRequest.deleteAssets(removeAsset as NSFastEnumeration)
            }
            
        }) { (scuccess, error) in
            
        }
    }
}

extension JHSAssetManger: PHPhotoLibraryChangeObserver{
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        if let sAlbums = changeInstance.changeDetails(for: smartALbums) {
            smartALbums = sAlbums.fetchResultAfterChanges;
            model.resetType(type: .smart);
            smartALbums.enumerateObjects { (collection, idx, stop) in
                let item = JHSAssetItemModel(collection: collection, type: .smart);
                self.model.addItemModel(model: item);
            }
            runMainThread(operation: JHSOperation(operation: .smartAlbum));
        }
        
        if let user = changeInstance.changeDetails(for: userCollecions) {
            userCollecions = user.fetchResultAfterChanges;
            model.resetType(type: .collection);
            userCollecions.enumerateObjects { (collection, idx, stop) in
                let item = JHSAssetItemModel(collection: collection, type: .collection);
                self.model.addItemModel(model: item);
            }
            runMainThread(operation: JHSOperation(operation: .userCollection));

        }
        
        if let changes = changeInstance.changeDetails(for: allPhoto) {
            allPhoto = changes.fetchResultAfterChanges;
            let item = JHSAssetItemModel(asset: allPhoto);
            model.resetType(type: .image);
            model.addItemModel(model: item);
            runMainThread(operation: JHSOperation(operation: .allPhoto));
            if changes.hasIncrementalChanges {
                if let removed = changes.removedIndexes,!removed.isEmpty {
                    runMainThread(operation: JHSOperation(operation: .remove, sets: removed));
                }
                if let inserted = changes.insertedIndexes,!inserted.isEmpty {
                    runMainThread(operation: JHSOperation(operation: .insert, sets: inserted));
                }
                if let changed = changes.changedIndexes,!changed.isEmpty {
                    runMainThread(operation: JHSOperation(operation: .changed, sets: changed));
                }
            }else {
                runMainThread(operation: JHSOperation(operation: .reload));
            }
        }
    }
    private func runMainThread(operation: JHSOperation) -> Void {
        DispatchQueue.main.async {
            self.changeObserver?.assetManger(manger: self, operation: operation);
        }
    }
}


class JHSOperation {
    var operation = JHSAssetOperationType.defalt;
    var indexSet: IndexSet!

    init(operation:JHSAssetOperationType,sets: IndexSet) {
        self.operation = operation;
        indexSet = sets;
    }
    init(operation: JHSAssetOperationType) {
        self.operation = operation;
    }
    var index: [Int]? {
        if indexSet == nil || indexSet.isEmpty {
            return nil;
        }
        return indexSet.map({ (idx) -> Int in
            return idx;
        })
        
    }
    
    var indexPaths: [IndexPath]? {
        if indexSet == nil || indexSet.isEmpty {
            return nil;
        }
        return indexSet.map({ (idx) -> IndexPath in
            return IndexPath(item: idx, section: 0);
        })
    }
}
