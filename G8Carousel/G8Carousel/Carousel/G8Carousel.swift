//
//  G8Carousel.swift
//  G8Carousel
//
//  Created by Omar Juarez Ortiz on 2017-05-12.
//  Copyright © 2017 Omar Juarez Ortiz. All rights reserved.
//

import Foundation
import UIKit

class G8Carousel: UIView {

    var collectionView: UICollectionView!
    let clearFiltersButton = UIButton()
    var clearFiltersButtonCallback: (()->())?
    //DataSource
    var filters = [G8CarouselItem]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        //Flowlayout
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.itemSize = CGSize(width:58.0, height:58.0)
        flowlayout.minimumLineSpacing = 25;
        flowlayout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude; // so that its only one row
        let leftInset = flowlayout.itemSize.width/2 + flowlayout.minimumLineSpacing
        flowlayout.sectionInset = UIEdgeInsetsMake(0, leftInset, 0, flowlayout.minimumLineSpacing);
        
        //Collectionview
        let cFrameLeftMargin = 5+flowlayout.itemSize.width/2
        let cFrame = CGRect(x: cFrameLeftMargin, y: self.bounds.height-flowlayout.itemSize.height, width: self.bounds.width-cFrameLeftMargin , height: flowlayout.itemSize.height)
        collectionView = UICollectionView.init(frame: cFrame, collectionViewLayout: flowlayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleRightMargin]
        collectionView.autoresizesSubviews = true
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .red
        collectionView.collectionViewLayout = flowlayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(G8FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        
        //Clear Button
        clearFiltersButton.setImage(UIImage.init(named: "thumbReset"), for: .normal)
        clearFiltersButton.frame = CGRect(origin: CGPoint(x:5, y:collectionView.frame.origin.y), size: CGSize(width:flowlayout.itemSize.width, height:flowlayout.itemSize.height))
        clearFiltersButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        
        self.addSubview(collectionView)
        self.addSubview(clearFiltersButton)
        
    
    }
    
    func clearButtonTapped(sender: UIButton){
        clearFiltersButtonCallback?()
    }

}

extension G8Carousel: UICollectionViewDelegate, UICollectionViewDataSource{

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! G8FilterCell
        cell.imageView.image = filters[indexPath.row].thumb
        
        
        return cell
    }
    //Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("G8Carousel >> Selected index: \(indexPath.row)")
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("G8Carousel >> DeSelected index: \(indexPath.row)")
    }


}

//MARK: Custom Cell
class G8FilterCell: UICollectionViewCell {
    
    var backTransView = UIView()
    var imageView = UIImageView(image: UIImage(named: "filterThumbPlaceHolder"))
    
    override var isSelected: Bool {
        didSet{
            if(isSelected){
                self.alpha = 0.5
            }else{
                self.alpha = 1.0
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backTransView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        
        
        contentView.backgroundColor = .clear
        contentView.addSubview(backTransView)
        backTransView.backgroundColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        backTransView.layer.cornerRadius = backTransView.bounds.width/2
        
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width-4, height: contentView.bounds.height-4)
        imageView.center = contentView.center
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = imageView.bounds.width/2
        imageView.layer.masksToBounds = true
//        imageView.image = UIImage(named: "filterThumbPlaceHolder")
        backTransView.addSubview(imageView)
    }
}

//MARK: G8CarouselItem
class G8CarouselItem{
    var name: String = "Filter"
    var thumb: UIImage = UIImage(named: "filterThumbPlaceHolder")!
    
    

}
