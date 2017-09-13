//
//  ViewController.swift
//  PhotoKitDemo
//
//  Created by lokizero00 on 2017/9/13.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    let screenWidth=UIScreen.main.bounds.width
    let screenHeight=UIScreen.main.bounds.height
    @IBOutlet weak var imageCollection:UICollectionView!
    var assetArray=Array<PHAsset>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化CollectionView的layout
        let layout=UICollectionViewFlowLayout()
        layout.itemSize=CGSize(width: screenWidth/4, height: screenWidth/4)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        
        //注册CollectionView
        imageCollection.register(UINib(nibName:"CollectionViewCell",bundle:nil), forCellWithReuseIdentifier: "imageCell")
        
        imageCollection.collectionViewLayout=layout
        
        //获取智能相册
        let smartAlbums:PHFetchResult=PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        print(smartAlbums.count)
        
        for i in 0..<smartAlbums.count {
            let collection=smartAlbums[i]
            if collection.isKind(of: PHAssetCollection.classForCoder()){
                
                
                let options:PHFetchOptions=PHFetchOptions.init()
//                options.sortDescriptors=[NSSortDescriptor.init(key: "createDate", ascending: true)]
                
                let assetsFetchResults=PHAsset.fetchAssets(in: collection, options: options)
                
                for j in 0..<assetsFetchResults.count{
                    //获取一个资源(PHAsset)
                    let asset:PHAsset=assetsFetchResults[j]
                    //添加到数组
                    assetArray.append(asset)
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        
        let manager=PHImageManager.default()
        let option=PHImageRequestOptions()
        option.isSynchronous=true
        
        //targetSize为获取图片的尺寸，如果想获取原图，可传入 PHImageManagerMaximumSize
        manager.requestImage(for: assetArray[indexPath.row], targetSize: CGSize(width:screenWidth/4,height:screenWidth/4), contentMode: .aspectFill, options: option, resultHandler: {
            (result,info)->Void in
            //回调函数，result中就是image的资源，类型为UIImage
            cell.imageView.image=result!
        })
        
        return cell
    }
}

