//
//  CollectionViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/22.
//

import UIKit

class CollectionViewController0: UICollectionViewController {
    
    // 定义数据源，例如包含字符串的数组
    let items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100.0, height: 150.0) // 设置默认的单元格大小
        collectionView.collectionViewLayout = flowLayout
        self.collectionView.register(UINib(nibName: "Collection0Cell", bundle: nil),forCellWithReuseIdentifier: "Collection0Cell")
    }
    
    // 返回集合视图中的节（sections）数，默认为1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    // 返回指定节中的项目数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    // 配置并返回单元格
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Collection0Cell", for: indexPath)as! Collection0Cell

        cell.CollectionCellImage.image = UIImage(named: "Yummy")

        return cell
    }
}


