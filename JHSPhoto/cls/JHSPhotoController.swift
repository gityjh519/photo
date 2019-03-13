//
//  JHSPhotoController.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/11.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit


class JHSPhotoController: JHSBaseViewController {

//    var models: JHSPhotoModel?
    
    var itemModel: JHSAssetItemModel!
    
    var manger: JHSAssetManger!
    
    var finishedDone:((_ list: [UIImage]) -> Void)!

    
    var selectedRows = [Int]() {
        didSet{
            navigationItem.rightBarButtonItem?.title = "\(selectedRows.count)个"

        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPhoneLevel();
        
        let countItem = UIBarButtonItem(title: "0个", style: .plain, target: self, action: #selector(buttonItemAction(_:)));
        self.navigationItem.rightBarButtonItem = countItem;
        
//        guard let collection = itemModel?.collection else {
//            return;
//        }
//        if collection.canPerform(.addContent) {
//            let addImg = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonItemAction(_:)));
//            navigationItem.rightBarButtonItem = addImg;
//        }else if collection.canPerform(.delete) {
//            let addImg = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(buttonItemAction(_:)));
//            navigationItem.rightBarButtonItem = addImg;
//        }
        
    }

    
    @objc override func buttonItemAction(_ item: UIBarButtonItem) {
        
        var list = [UIImage]();
        var count = 0;
        for idx in selectedRows {
            itemModel?.fetchImage(index: idx, size: ScreenData.bounds.size, finished: { (image) in
                list.append(image!);
                count += 1;
                if count == self.selectedRows.count {
                    self.finishedDone?(list);
                }
            })
        }
        
        self.navigationController?.dismiss(animated: true, completion: {
            
        })

    }
    
    

}
extension JHSPhotoController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func createPhoneLevel() -> Void {
        let layout = UICollectionViewFlowLayout();
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        layout.sectionInset = UIEdge(size: 4);
        let perWidth = (width() - 20)/4;
        layout.itemSize = CGSize(width: perWidth, height: perWidth);
        createCollection(frame: navigateRect, layout: layout, delegate: self);
        baseCollectionView.register(JHSPhotoImageCell.self, forCellWithReuseIdentifier: "JHSPhotoImageCell");
        baseCollectionView.alwaysBounceVertical = true;

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return itemModel?.count ?? 0;

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JHSPhotoImageCell", for: indexPath) as! JHSPhotoImageCell;
        
        cell.isSelected = selectedRows.contains(indexPath.row);
        cell.selectedButn.addTarget(self, action: #selector(touchUpButtonAction(_:)));
        
        itemModel.fetchImage(index: indexPath.row, size: CGSize(width: width()/2, height: width()/2)) { (image) in
            cell.imageView.image = image;
        }
        return cell;
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ctrl = JHSImageController();
        ctrl.index = indexPath.row;
        ctrl.modelItems = itemModel;
        navigationController?.pushViewController(ctrl, animated: true);
    }
    
    override func touchUpButtonAction(_ btn: UIButton) {
        guard let cell = btn.superview as? JHSPhotoImageCell else {
            return;
        }
        let indexPath = baseCollectionView.indexPath(for: cell)!;
        if let idx = selectedRows.firstIndex(of: indexPath.row) {
            selectedRows.remove(at: idx);
            cell.isSelected = false;
        }else{
            cell.isSelected = true;
            selectedRows.append(indexPath.row);
        }
    }
}
