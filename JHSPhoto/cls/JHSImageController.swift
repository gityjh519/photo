//
//  JHSImageController.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/11.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class JHSImageController: JHSBaseViewController {
    
    var index = 0;
    
    var modelItems: JHSAssetItemModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        createPhoneLevel();
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        baseCollectionView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: false);
        if modelItems != nil {
            title = "\(index + 1)/\(modelItems.count)"
        }

    }
    
    
}

extension JHSImageController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func createPhoneLevel() -> Void {
        let layout = UICollectionViewFlowLayout();
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = .horizontal;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdge(size: 0);
        layout.itemSize = CGSize(width: width() + 8, height: height());
        createCollection(frame: CGRect.init(x: -4, y: 0, width: width() + 8, height: height()), layout: layout, delegate: self);
        baseCollectionView.isPagingEnabled = true;
        baseCollectionView.register(JHSImageScaleCell.self, forCellWithReuseIdentifier: "JHSImageScaleCell");
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return modelItems?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JHSImageScaleCell", for: indexPath) as! JHSImageScaleCell;
        cell.imageView.resetScale();
        
        modelItems?.fetchImage(index: indexPath.row, size: CGSize(width: width()*2, height: height()*2), finished: { (image) in
            cell.imageView.image = image;
        })
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset;
        let idx = Int((offset.x + scrollView.width/2) / scrollView.width);
        if idx != index {
            index = idx;
            let count = modelItems?.count ?? 0;
            title = "\(index + 1)/\(count)"
        }
        
    }
    
}

class JHSImageScaleCell: UICollectionViewCell  {
    var imageView: ScalePictureView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        imageView = ScalePictureView(frame: bounds.insetBy(dx: 4, dy: 0));
        addSubview(imageView);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
