//
//  JHSAlbumController.swift
//  JHSPhoto
//
//  Created by yaojinhai on 2019/3/11.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import Photos

class JHSAlbumController: JHSBaseViewController {
    
    var list: [JHSPhotoModel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(buttonItemAction(_:)));
        navigationItem.leftBarButtonItem = back;
        createPhoneLevel();
        
        JHSPhotoManger.fetchAlbum { (tempList) in
            self.list = tempList;
            self.baseCollectionView.reloadData();
        };
    
        
        title = "我的相册";
    }
    
    @objc override func buttonItemAction(_ item: UIBarButtonItem) {
        self.dismiss(animated: true) {
            
        }
    }
    
}

extension JHSAlbumController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func createPhoneLevel() -> Void {
        let layout = UICollectionViewFlowLayout();
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdge(size: 10);
        let perWidth = (width() - 30)/2;
        layout.itemSize = CGSize(width: perWidth, height: perWidth + 44);
        createCollection(frame: navigateRect, layout: layout, delegate: self);
        baseCollectionView.register(JHSPhotoImageCell.self, forCellWithReuseIdentifier: "JHSPhotoImageCell");
        baseCollectionView.alwaysBounceVertical = true;
        

    }
    
    // MARK: - collection view delegate and dataSource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JHSPhotoImageCell", for: indexPath) as! JHSPhotoImageCell;
        let model = list[indexPath.row];
        cell.configTitleLabel();
        cell.configModel(model: model);
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ctrl = JHSPhotoController();
        
        navigationController?.pushViewController(ctrl, animated: true);
    }
    
}

class JHSPhotoImageCell: UICollectionViewCell {
    var imageView: UIImageView!
    private var titleLabel: UILabel!
    var title: String?{
        didSet{
            titleLabel?.text = title;
        }
    }
    var titleAttrbute: NSAttributedString!{
        didSet{
            titleLabel?.attributedText = titleAttrbute;
        }
    }
    
    var selectedButn: UIButton!
    
    override var isSelected: Bool {
        didSet{
            selectedButn.isSelected = isSelected;
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        imageView = createImageView(rect: bounds);
        selectedButn = createButton(rect: .init(x: width - 30, y: height - 30, width: 30, height: 30), title: "");
        selectedButn.setImage(UIImage(named: "invoiceUnSelected@2x"), for: .normal);
        selectedButn.setImage(UIImage(named: "invoiceSelected@2x"), for: .selected);
        let shapeLayer = CAShapeLayer();
        shapeLayer.frame = selectedButn.frame
        let path = CGMutablePath();
        path.addEllipse(in: selectedButn.bounds.insetBy(dx: 7, dy: 7));
        shapeLayer.path = path;
        shapeLayer.fillColor = UIColor.white.cgColor;
        imageView.layer.insertSublayer(shapeLayer, at: 0);
        

        
    }
    
    func configModel(model: JHSPhotoModel) -> Void {
        titleAttrbute = model.countAttrbute;
        model.fetchImage(index: 0, size: CGSize(width: ScreenData.width, height: ScreenData.width)) { (image) in
            self.imageView.image = image;
        }
    }
    
    func configTitleLabel() -> Void {
        imageView.frame.size = CGSize(width: width, height: width);
        titleLabel = createLabel(rect: .init(x: 0, y: width + 4, width: width, height: 40), text: "");
        titleLabel.textColor = UIColor.black;
        titleLabel.numberOfLines = 0;
        titleLabel.font = UIFont.fitSize(size: 15);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

